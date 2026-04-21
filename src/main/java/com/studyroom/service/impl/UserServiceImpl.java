package com.studyroom.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.studyroom.entity.User;
import com.studyroom.entity.UserRole;
import com.studyroom.mapper.UserMapper;
import com.studyroom.mapper.UserRoleMapper;
import com.studyroom.service.UserService;
import com.studyroom.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserRoleMapper userRoleMapper;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public Map<String, Object> login(String username, String password) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username);
        User user = getOne(wrapper);

        if (user == null) {
            throw new RuntimeException("用户名或密码错误");
        }

        if (user.getStatus() == 0) {
            throw new RuntimeException("账号已被禁用");
        }

        System.out.println("输入密码: " + password);
        System.out.println("数据库存储密码: " + user.getPassword());
        System.out.println("匹配结果: " + passwordEncoder.matches(password, user.getPassword()));

        // 验证密码 - 支持BCrypt和明文密码（用于测试）
        boolean passwordValid = passwordEncoder.matches(password, user.getPassword())
                || password.equals(user.getPassword()); // 明文密码验证（仅用于测试）
        
        if (!passwordValid) {
            throw new RuntimeException("用户名或密码错误");
        }

        // 更新登录信息
        user.setLastLoginTime(LocalDateTime.now());
        updateById(user);

        // 生成token
        String token = jwtUtil.generateToken(user.getId(), user.getUsername());

        // 获取角色
        List<String> roles = getUserRoles(user.getId());

        // 清除密码
        user.setPassword(null);

        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("tokenType", "Bearer");
        result.put("expiresIn", 7200);
        result.put("user", user);
        result.put("roles", roles);

        return result;
    }

    @Override
    @Transactional
    public User register(User user) {
        // 检查用户名是否已存在
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, user.getUsername());
        if (count(wrapper) > 0) {
            throw new RuntimeException("用户名已存在");
        }

        // 检查手机号是否已存在
        if (user.getPhone() != null) {
            LambdaQueryWrapper<User> phoneWrapper = new LambdaQueryWrapper<>();
            phoneWrapper.eq(User::getPhone, user.getPhone());
            if (count(phoneWrapper) > 0) {
                throw new RuntimeException("手机号已被注册");
            }
        }

        // 加密密码
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setStatus(1);
        user.setUserType(1); // 默认为普通用户

        save(user);

        // 分配普通用户角色
        UserRole userRole = new UserRole();
        userRole.setUserId(user.getId());
        userRole.setRoleId(1L); // ROLE_USER
        userRoleMapper.insert(userRole);

        // 清除密码返回
        user.setPassword(null);
        return user;
    }

    @Override
    public User getUserInfo(Long userId) {
        User user = getById(userId);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public List<String> getUserRoles(Long userId) {
        return baseMapper.selectRolesByUserId(userId);
    }
// 在 UserServiceImpl 类中补充以下代码

    @Override
    public boolean verifyIdentity(String username, String email, String phone) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username)
                .eq(User::getEmail, email)
                .eq(User::getPhone, phone);
        return count(wrapper) > 0;
    }

    @Override
    public void resetPassword(String username, String newPassword) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username);
        User user = getOne(wrapper);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        // 对新密码进行加密保存
        user.setPassword(passwordEncoder.encode(newPassword));
        updateById(user);
    }
}
