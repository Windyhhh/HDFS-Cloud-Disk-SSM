package com.hdfs.cloud.service;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

@Service
public class HdfsService {
    private static final Logger logger = LoggerFactory.getLogger(HdfsService.class);

    @Value("${hdfs.namenode.uri:hdfs://localhost:9000}")
    private String hdfsUri;

    private FileSystem getFileSystem() throws IOException {
        Configuration conf = new Configuration();
        conf.set("fs.defaultFS", hdfsUri);
        return FileSystem.get(conf);
    }

    public boolean createDirectory(String path) {
        try {
            FileSystem fs = getFileSystem();
            Path dirPath = new Path(path);
            if (!fs.exists(dirPath)) {
                fs.mkdirs(dirPath);
                logger.info("Created directory: {}", path);
                return true;
            }
            return false;
        } catch (IOException e) {
            logger.error("Error creating directory: {}", path, e);
            return false;
        }
    }

    public boolean uploadFile(String hdfsPath, InputStream inputStream) {
        try {
            FileSystem fs = getFileSystem();
            Path path = new Path(hdfsPath);
            OutputStream out = fs.create(path);
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) > 0) {
                out.write(buffer, 0, length);
            }
            out.close();
            inputStream.close();
            logger.info("Uploaded file: {}", hdfsPath);
            return true;
        } catch (IOException e) {
            logger.error("Error uploading file: {}", hdfsPath, e);
            return false;
        }
    }

    public boolean deleteFile(String hdfsPath) {
        try {
            FileSystem fs = getFileSystem();
            Path path = new Path(hdfsPath);
            if (fs.exists(path)) {
                fs.delete(path, true);
                logger.info("Deleted file: {}", hdfsPath);
                return true;
            }
            return false;
        } catch (IOException e) {
            logger.error("Error deleting file: {}", hdfsPath, e);
            return false;
        }
    }

    public InputStream downloadFile(String hdfsPath) {
        try {
            FileSystem fs = getFileSystem();
            Path path = new Path(hdfsPath);
            if (fs.exists(path)) {
                return fs.open(path);
            }
        } catch (IOException e) {
            logger.error("Error downloading file: {}", hdfsPath, e);
        }
        return null;
    }
}

