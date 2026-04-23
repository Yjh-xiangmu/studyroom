package com.studyroom.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.studyroom.common.Result;
import com.studyroom.entity.ForumPost;
import com.studyroom.entity.ForumReply;
import com.studyroom.entity.User;
import com.studyroom.service.ForumPostService;
import com.studyroom.service.ForumReplyService;
import com.studyroom.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/forum")
public class ForumController {

    @Autowired
    private ForumPostService forumPostService;

    @Autowired
    private ForumReplyService forumReplyService;

    @Autowired
    private UserService userService;

    @GetMapping("/posts")
    public Result<Map<String, Object>> getPosts(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword) {
        
        LambdaQueryWrapper<ForumPost> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ForumPost::getStatus, 1);
        
        if (category != null && !category.isEmpty()) {
            // category是字符串，categoryId是Long，这里简化处理
            // 实际应该根据category名称查询categoryId
            // 暂时不根据分类筛选，或根据postType筛选
            if ("feedback".equals(category)) {
                wrapper.eq(ForumPost::getPostType, 1);
            } else if ("report".equals(category)) {
                wrapper.eq(ForumPost::getPostType, 2);
            } else if ("complaint".equals(category)) {
                wrapper.eq(ForumPost::getPostType, 3);
            } else if ("discussion".equals(category)) {
                wrapper.eq(ForumPost::getPostType, 4);
            }
        }
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(ForumPost::getTitle, keyword)
                    .or()
                    .like(ForumPost::getContent, keyword));
        }
        
        wrapper.orderByDesc(ForumPost::getIsTop);
        wrapper.orderByDesc(ForumPost::getCreateTime);
        
        Page<ForumPost> pageResult = forumPostService.page(new Page<>(page, size), wrapper);
        
        // 组装返回数据，包含作者信息
        List<Map<String, Object>> records = new ArrayList<>();
        for (ForumPost post : pageResult.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", post.getId());
            map.put("title", post.getTitle());
            map.put("content", post.getContent());
            map.put("category", getCategoryByPostType(post.getPostType()));
            map.put("viewCount", post.getViewCount());
            map.put("replyCount", post.getReplyCount());
            map.put("likeCount", post.getLikeCount());
            map.put("createTime", post.getCreateTime());
            map.put("updateTime", post.getUpdateTime());
            
            // 获取作者信息
            User user = userService.getById(post.getUserId());
            map.put("authorName", user != null ? user.getRealName() : "未知用户");
            map.put("authorType", user != null ? user.getUserType() : 1);

            records.add(map);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("records", records);
        result.put("total", pageResult.getTotal());
        result.put("pages", pageResult.getPages());
        result.put("current", pageResult.getCurrent());
        result.put("size", pageResult.getSize());
        
        return Result.success(result);
    }

    @GetMapping("/post/{id}")
    public Result<Map<String, Object>> getPostDetail(@PathVariable Long id) {
        ForumPost post = forumPostService.getById(id);
        if (post == null || post.getStatus() != 1) {
            return Result.error(404, "帖子不存在");
        }
        
        // 增加浏览量
        post.setViewCount(post.getViewCount() + 1);
        forumPostService.updateById(post);
        
        // 组装帖子数据，包含作者信息
        Map<String, Object> postMap = new HashMap<>();
        postMap.put("id", post.getId());
        postMap.put("title", post.getTitle());
        postMap.put("content", post.getContent());
        postMap.put("category", getCategoryByPostType(post.getPostType()));
        postMap.put("viewCount", post.getViewCount());
        postMap.put("replyCount", post.getReplyCount());
        postMap.put("likeCount", post.getLikeCount());
        postMap.put("createTime", post.getCreateTime());
        postMap.put("updateTime", post.getUpdateTime());
        
        // 获取作者信息
        User user = userService.getById(post.getUserId());
        postMap.put("authorName", user != null ? user.getRealName() : "未知用户");
        postMap.put("authorType", user != null ? user.getUserType() : 1);
        
        Map<String, Object> result = new HashMap<>();
        result.put("post", postMap);
        
        // 获取回复并组装作者信息
        LambdaQueryWrapper<ForumReply> replyWrapper = new LambdaQueryWrapper<>();
        replyWrapper.eq(ForumReply::getPostId, id);
        replyWrapper.eq(ForumReply::getStatus, 1);
        replyWrapper.orderByAsc(ForumReply::getCreateTime);
        List<ForumReply> replies = forumReplyService.list(replyWrapper);
        
        List<Map<String, Object>> replyList = new ArrayList<>();
        for (ForumReply reply : replies) {
            Map<String, Object> replyMap = new HashMap<>();
            replyMap.put("id", reply.getId());
            replyMap.put("content", reply.getContent());
            replyMap.put("createTime", reply.getCreateTime());
            
            // 获取回复作者信息
            User replyUser = userService.getById(reply.getUserId());
            replyMap.put("authorName", replyUser != null ? replyUser.getRealName() : "未知用户");
            
            replyList.add(replyMap);
        }
        result.put("replies", replyList);
        
        return Result.success(result);
    }

    @PostMapping("/post")
    public Result<String> createPost(@RequestBody Map<String, Object> params, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }

        ForumPost post = new ForumPost();
        post.setUserId(user.getId());
        // 将前端 category 字符串映射到 postType 整数
        String category = (String) params.get("category");
        post.setPostType(categoryToPostType(category));
        post.setTitle((String) params.get("title"));
        post.setContent((String) params.get("content"));
        post.setViewCount(0);
        post.setReplyCount(0);
        post.setLikeCount(0);
        post.setStatus(1);
        post.setIsTop(0);
        post.setCreateTime(LocalDateTime.now());
        post.setUpdateTime(LocalDateTime.now());

        boolean success = forumPostService.save(post);
        if (success) {
            return Result.success("发布成功");
        }
        return Result.error(500, "发布失败");
    }

    // 将 category 字符串转换为 postType 整数
    private int categoryToPostType(String category) {
        if (category == null) return 4;
        switch (category) {
            case "feedback": return 1;
            case "report": return 2;
            case "complaint": return 3;
            case "discussion": return 4;
            default: return 4;
        }
    }

    @PostMapping("/post/{id}/reply")
    public Result<String> createReply(@PathVariable Long id, @RequestBody Map<String, String> params, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        ForumPost post = forumPostService.getById(id);
        if (post == null) {
            return Result.error(404, "帖子不存在");
        }
        
        ForumReply reply = new ForumReply();
        reply.setPostId(id);
        reply.setUserId(user.getId());
        // reply.setAuthorName(user.getUsername()); // 实体类无此字段
        reply.setContent(params.get("content"));
        reply.setStatus(1);
        reply.setCreateTime(LocalDateTime.now());
        reply.setUpdateTime(LocalDateTime.now());
        
        boolean success = forumReplyService.save(reply);
        if (success) {
            // 更新帖子回复数
            post.setReplyCount(post.getReplyCount() + 1);
            forumPostService.updateById(post);
            return Result.success("回复成功");
        }
        return Result.error(500, "回复失败");
    }

    @PostMapping("/post/{id}/like")
    public Result<String> likePost(@PathVariable Long id) {
        ForumPost post = forumPostService.getById(id);
        if (post == null) {
            return Result.error(404, "帖子不存在");
        }
        
        post.setLikeCount(post.getLikeCount() + 1);
        forumPostService.updateById(post);
        return Result.success("点赞成功");
    }

    @GetMapping("/categories")
    public Result<List<Map<String, Object>>> getCategories() {
        List<Map<String, Object>> categories = new ArrayList<>();
        
        Map<String, Object> cat1 = new HashMap<>();
        cat1.put("value", "学习交流");
        cat1.put("label", "学习交流");
        categories.add(cat1);
        
        Map<String, Object> cat2 = new HashMap<>();
        cat2.put("value", "经验分享");
        cat2.put("label", "经验分享");
        categories.add(cat2);
        
        Map<String, Object> cat3 = new HashMap<>();
        cat3.put("value", "问题求助");
        cat3.put("label", "问题求助");
        categories.add(cat3);
        
        Map<String, Object> cat4 = new HashMap<>();
        cat4.put("value", "闲聊灌水");
        cat4.put("label", "闲聊灌水");
        categories.add(cat4);
        
        return Result.success(categories);
    }

    // 根据postType获取category字符串
    private String getCategoryByPostType(Integer postType) {
        if (postType == null) return "other";
        switch (postType) {
            case 1: return "feedback";
            case 2: return "report";
            case 3: return "complaint";
            case 4: return "discussion";
            default: return "other";
        }
    }
}
