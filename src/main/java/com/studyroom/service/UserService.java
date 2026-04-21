package com.studyroom.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.studyroom.entity.User;

import java.util.List;
import java.util.Map;

public interface UserService extends IService<User> {

    Map<String, Object> login(String username, String password);

    User register(User user);

    User getUserInfo(Long userId);

    List<String> getUserRoles(Long userId);

    boolean verifyIdentity(String username, String email, String phone);

    void resetPassword(String username, String newPassword);
}
