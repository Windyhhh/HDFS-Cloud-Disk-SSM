package com.hdfs.cloud.service;

import com.hdfs.cloud.entity.User;
import com.hdfs.cloud.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserMapper userMapper;

    public User addUser(String username, String password, String email, String phone) {
        User user = new User(username, password, email);
        user.setPhone(phone);
        userMapper.insert(user);
        return user;
    }

    public User updateUser(Integer id, String username, String password, String email, String phone) {
        User user = userMapper.selectById(id);
        if (user != null) {
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);
            user.setPhone(phone);
            user.setUpdateTime(new Date());
            userMapper.update(user);
        }
        return user;
    }

    public boolean deleteUser(Integer id) {
        return userMapper.delete(id) > 0;
    }

    public User getUserById(Integer id) {
        return userMapper.selectById(id);
    }

    public User getUserByUsername(String username) {
        return userMapper.selectByUsername(username);
    }

    public List<User> getAllUsers() {
        return userMapper.selectAll();
    }

    public List<User> getUsersByStatus(Integer status) {
        return userMapper.selectByStatus(status);
    }

    public boolean validateUser(String username, String password) {
        User user = userMapper.selectByUsername(username);
        return user != null && user.getPassword().equals(password) && user.getStatus() == 1;
    }
}

