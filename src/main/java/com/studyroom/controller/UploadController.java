package com.studyroom.controller;

import com.studyroom.common.Result;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@RestController
@RequestMapping("/api/upload")
public class UploadController {

    private static final String UPLOAD_DIR = System.getProperty("user.dir") + "/uploads/";

    @PostMapping("/image")
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error(400, "文件不能为空");
        }
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return Result.error(400, "只允许上传图片文件");
        }
        long size = file.getSize();
        if (size > 5 * 1024 * 1024) {
            return Result.error(400, "图片大小不能超过5MB");
        }

        try {
            File dir = new File(UPLOAD_DIR);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            String originalName = file.getOriginalFilename();
            String ext = (originalName != null && originalName.contains("."))
                    ? originalName.substring(originalName.lastIndexOf("."))
                    : ".jpg";
            String filename = UUID.randomUUID().toString().replace("-", "") + ext;
            Path dest = Paths.get(UPLOAD_DIR + filename);
            Files.copy(file.getInputStream(), dest);
            return Result.success("/uploads/" + filename);
        } catch (IOException e) {
            return Result.error(500, "上传失败：" + e.getMessage());
        }
    }
}
