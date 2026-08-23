package com.hdfs.cloud.mapper;

import com.hdfs.cloud.entity.FileInfo;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface FileInfoMapper {

    @Insert("INSERT INTO file_info (user_id, file_name, file_path, file_type, file_size, is_directory, parent_path, create_time, update_time) " +
            "VALUES (#{userId}, #{fileName}, #{filePath}, #{fileType}, #{fileSize}, #{isDirectory}, #{parentPath}, #{createTime}, #{updateTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(FileInfo fileInfo);

    @Update("UPDATE file_info SET file_name=#{fileName}, file_path=#{filePath}, file_type=#{fileType}, " +
            "file_size=#{fileSize}, parent_path=#{parentPath}, update_time=#{updateTime} WHERE id=#{id}")
    int update(FileInfo fileInfo);

    @Delete("DELETE FROM file_info WHERE id=#{id}")
    int delete(Integer id);

    @Select("SELECT * FROM file_info WHERE id=#{id}")
    FileInfo selectById(Integer id);

    @Select("SELECT * FROM file_info WHERE user_id=#{userId} AND parent_path=#{parentPath}")
    List<FileInfo> selectByUserAndParent(@Param("userId") Integer userId, @Param("parentPath") String parentPath);

    @Select("SELECT * FROM file_info WHERE user_id=#{userId}")
    List<FileInfo> selectByUserId(Integer userId);

    @Select("SELECT * FROM file_info WHERE user_id=#{userId} AND file_path=#{filePath}")
    FileInfo selectByUserAndPath(@Param("userId") Integer userId, @Param("filePath") String filePath);

    @Delete("DELETE FROM file_info WHERE user_id=#{userId} AND parent_path LIKE CONCAT(#{parentPath}, '%')")
    int deleteByParentPath(@Param("userId") Integer userId, @Param("parentPath") String parentPath);
}

