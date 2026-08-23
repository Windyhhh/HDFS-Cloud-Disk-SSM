package com.hdfs.cloud.controller;

import com.hdfs.cloud.entity.FileInfo;
import com.hdfs.cloud.service.FileService;
import com.hdfs.cloud.service.HdfsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;

    @Autowired
    private HdfsService hdfsService;

    @PostMapping("/mkdir")
    @ResponseBody
    public Map<String, Object> createDirectory(String dirName, String parentPath, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        FileInfo fileInfo = fileService.createDirectory(userId, dirName, parentPath);
        String hdfsPath = "/user/" + userId + fileInfo.getFilePath();
        hdfsService.createDirectory(hdfsPath);

        result.put("success", true);
        result.put("message", "文件夹创建成功");
        result.put("data", fileInfo);
        return result;
    }

    @PostMapping("/upload")
    @ResponseBody
    public Map<String, Object> uploadFile(@RequestParam("file") MultipartFile file, String parentPath, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        try {
            String fileName = file.getOriginalFilename();
            String filePath = parentPath.endsWith("/") ? parentPath + fileName : parentPath + "/" + fileName;
            String hdfsPath = "/user/" + userId + filePath;

            hdfsService.uploadFile(hdfsPath, file.getInputStream());
            FileInfo fileInfo = fileService.uploadFile(userId, fileName, filePath, getFileType(fileName), file.getSize(), parentPath);

            result.put("success", true);
            result.put("message", "文件上传成功");
            result.put("data", fileInfo);
        } catch (IOException e) {
            result.put("success", false);
            result.put("message", "上传失败: " + e.getMessage());
        }
        return result;
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> deleteFile(Integer fileId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        boolean success = fileService.deleteFile(userId, fileId);
        result.put("success", success);
        result.put("message", success ? "文件删除成功" : "删除失败");
        return result;
    }

    @PostMapping("/rename")
    @ResponseBody
    public Map<String, Object> renameFile(Integer fileId, String newName, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        boolean success = fileService.renameFile(userId, fileId, newName);
        result.put("success", success);
        result.put("message", success ? "文件重命名成功" : "重命名失败");
        return result;
    }

    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> listFiles(String parentPath, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        List<FileInfo> files = fileService.listFiles(userId, parentPath);
        result.put("success", true);
        result.put("data", files);
        return result;
    }

    @GetMapping("/download")
    public void downloadFile(Integer fileId, HttpSession session, javax.servlet.http.HttpServletResponse response) {
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            try {
                response.sendError(401, "未登录");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }

        FileInfo fileInfo = fileService.getFileInfo(userId, fileId);
        if (fileInfo == null) {
            try {
                response.sendError(404, "文件不存在");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }

        String hdfsPath = "/user/" + userId + fileInfo.getFilePath();
        java.io.InputStream inputStream = hdfsService.downloadFile(hdfsPath);

        if (inputStream == null) {
            try {
                response.sendError(404, "HDFS中文件不存在");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }

        try {
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileInfo.getFileName() + "\"");
            if (fileInfo.getFileSize() != null) {
                response.setContentLength(fileInfo.getFileSize().intValue());
            }

            java.io.OutputStream outputStream = response.getOutputStream();
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) > 0) {
                outputStream.write(buffer, 0, length);
            }
            outputStream.flush();
            outputStream.close();
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String getFileType(String fileName) {
        int lastDot = fileName.lastIndexOf(".");
        return lastDot > 0 ? fileName.substring(lastDot + 1) : "unknown";
    }
}

