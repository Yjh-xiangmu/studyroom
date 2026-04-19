package com.studyroom.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.studyroom.common.Result;
import com.studyroom.entity.Notice;
import com.studyroom.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/notices")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    @GetMapping
    public Result<List<Notice>> list(
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Integer top,
            @RequestParam(defaultValue = "10") Integer limit) {
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        // 只返回已发布的公告（status=2）
        wrapper.eq(Notice::getStatus, 2);
        if (top != null && top == 1) {
            wrapper.eq(Notice::getIsTop, 1);
        }
        wrapper.orderByDesc(Notice::getIsTop, Notice::getPublishTime);
        wrapper.last("LIMIT " + limit);
        return Result.success(noticeService.list(wrapper));
    }

    @GetMapping("/{id}")
    public Result<Notice> getById(@PathVariable Long id) {
        Notice notice = noticeService.getById(id);
        // 增加浏览量
        if (notice != null) {
            notice.setViewCount(notice.getViewCount() + 1);
            noticeService.updateById(notice);
        }
        return Result.success(notice);
    }

    @PostMapping
    public Result<Notice> save(@RequestBody Notice notice) {
        noticeService.save(notice);
        return Result.success("发布成功", notice);
    }

    @PutMapping("/{id}")
    public Result<Notice> update(@PathVariable Long id, @RequestBody Notice notice) {
        notice.setId(id);
        noticeService.updateById(notice);
        return Result.success("更新成功", notice);
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        noticeService.removeById(id);
        return Result.success("删除成功");
    }

}
