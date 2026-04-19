package com.studyroom.controller;

import com.studyroom.common.Result;
import com.studyroom.entity.User;
import com.studyroom.service.UserService;
import com.studyroom.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody User loginUser, HttpSession session) {
        Map<String, Object> result = userService.login(loginUser.getUsername(), loginUser.getPassword());
        
        // 将用户信息存入session
        User user = (User) result.get("user");
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("roles", result.get("roles"));
        
        return Result.success("登录成功", result);
    }

    @PostMapping("/register")
    public Result<User> register(@RequestBody User user) {
        User newUser = userService.register(user);
        return Result.success("注册成功", newUser);
    }

    @PostMapping("/logout")
    public Result<String> logout() {
        return Result.success("退出成功");
    }

    @GetMapping("/userinfo")
    public Result<User> getUserInfo(HttpServletRequest request) {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
            Long userId = jwtUtil.getUserIdFromToken(token);
            User user = userService.getUserInfo(userId);
            return Result.success(user);
        }
        return Result.error(401, "未登录");
    }

}
