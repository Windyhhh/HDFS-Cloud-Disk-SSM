package com.hdfs.cloud.mapper;

import com.hdfs.cloud.entity.User;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface UserMapper {

    @Insert("INSERT INTO user (username, password, email, phone, status, create_time, update_time) " +
            "VALUES (#{username}, #{password}, #{email}, #{phone}, #{status}, #{createTime}, #{updateTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(User user);

    @Update("UPDATE user SET username=#{username}, password=#{password}, email=#{email}, " +
            "phone=#{phone}, status=#{status}, update_time=#{updateTime} WHERE id=#{id}")
    int update(User user);

    @Delete("DELETE FROM user WHERE id=#{id}")
    int delete(Integer id);

    @Select("SELECT * FROM user WHERE id=#{id}")
    User selectById(Integer id);

    @Select("SELECT * FROM user WHERE username=#{username}")
    User selectByUsername(String username);

    @Select("SELECT * FROM user")
    List<User> selectAll();

    @Select("SELECT * FROM user WHERE status=#{status}")
    List<User> selectByStatus(Integer status);
}

