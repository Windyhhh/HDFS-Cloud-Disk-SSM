package com.hdfs.cloud.controller;

import com.hdfs.cloud.entity.User;
import com.hdfs.cloud.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    @ResponseBody
    public Map<String, Object> login(String username, String password, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = userService.getUserByUsername(username);

        if (user != null && user.getPassword().equals(password) && user.getStatus() == 1) {
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            result.put("success", true);
            result.put("message", "登录成功");
            result.put("userId", user.getId());
        } else {
            result.put("success", false);
            result.put("message", "用户名或密码错误");
        }
        return result;
    }

    @PostMapping("/register")
    @ResponseBody
    public Map<String, Object> register(String username, String password, String email, String phone) {
        Map<String, Object> result = new HashMap<>();

        if (userService.getUserByUsername(username) != null) {
            result.put("success", false);
            result.put("message", "用户名已存在");
            return result;
        }

        User user = userService.addUser(username, password, email, phone);
        result.put("success", true);
        result.put("message", "注册成功");
        result.put("userId", user.getId());
        return result;
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> updateUser(Integer id, String username, String password, String email, String phone) {
        Map<String, Object> result = new HashMap<>();
        User user = userService.updateUser(id, username, password, email, phone);
        result.put("success", user != null);
        result.put("message", user != null ? "更新成功" : "更新失败");
        return result;
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> deleteUser(Integer id) {
        Map<String, Object> result = new HashMap<>();
        boolean success = userService.deleteUser(id);
        result.put("success", success);
        result.put("message", success ? "删除成功" : "删除失败");
        return result;
    }

    @GetMapping("/info")
    @ResponseBody
    public Map<String, Object> getUserInfo(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        User user = userService.getUserById(userId);
        result.put("success", user != null);
        result.put("data", user);
        return result;
    }
}

