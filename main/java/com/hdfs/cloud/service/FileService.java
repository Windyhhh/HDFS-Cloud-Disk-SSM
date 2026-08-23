package com.hdfs.cloud.service;

import com.hdfs.cloud.entity.FileInfo;
import com.hdfs.cloud.mapper.FileInfoMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class FileService {

    @Autowired
    private FileInfoMapper fileInfoMapper;

    @Autowired
    private HdfsService hdfsService;

    public FileInfo createDirectory(Integer userId, String dirName, String parentPath) {
        String dirPath = parentPath.endsWith("/") ? parentPath + dirName : parentPath + "/" + dirName;
        FileInfo fileInfo = new FileInfo(userId, dirName, dirPath, "directory", 0L, 1, parentPath);
        fileInfoMapper.insert(fileInfo);
        return fileInfo;
    }

    public FileInfo uploadFile(Integer userId, String fileName, String filePath, String fileType, Long fileSize, String parentPath) {
        FileInfo fileInfo = new FileInfo(userId, fileName, filePath, fileType, fileSize, 0, parentPath);
        fileInfoMapper.insert(fileInfo);
        return fileInfo;
    }

    public boolean deleteFile(Integer userId, Integer fileId) {
        FileInfo fileInfo = fileInfoMapper.selectById(fileId);
        if (fileInfo != null && fileInfo.getUserId().equals(userId)) {
            // Delete from HDFS
            String hdfsPath = "/user/" + userId + fileInfo.getFilePath();
            hdfsService.deleteFile(hdfsPath);
            // Delete from database
            fileInfoMapper.deleteByParentPath(userId, fileInfo.getFilePath());
            return true;
        }
        return false;
    }

    public boolean renameFile(Integer userId, Integer fileId, String newName) {
        FileInfo fileInfo = fileInfoMapper.selectById(fileId);
        if (fileInfo != null && fileInfo.getUserId().equals(userId)) {
            fileInfo.setFileName(newName);
            fileInfo.setUpdateTime(new Date());
            fileInfoMapper.update(fileInfo);
            return true;
        }
        return false;
    }

    public boolean moveFile(Integer userId, Integer fileId, String newParentPath) {
        FileInfo fileInfo = fileInfoMapper.selectById(fileId);
        if (fileInfo != null && fileInfo.getUserId().equals(userId)) {
            fileInfo.setParentPath(newParentPath);
            fileInfo.setUpdateTime(new Date());
            fileInfoMapper.update(fileInfo);
            return true;
        }
        return false;
    }

    public List<FileInfo> listFiles(Integer userId, String parentPath) {
        return fileInfoMapper.selectByUserAndParent(userId, parentPath);
    }

    public FileInfo getFileInfo(Integer userId, Integer fileId) {
        FileInfo fileInfo = fileInfoMapper.selectById(fileId);
        if (fileInfo != null && fileInfo.getUserId().equals(userId)) {
            return fileInfo;
        }
        return null;
    }
}

