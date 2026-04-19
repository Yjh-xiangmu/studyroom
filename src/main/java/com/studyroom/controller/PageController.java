package com.studyroom.controller;

import com.studyroom.entity.Notice;
import com.studyroom.entity.Seat;
import com.studyroom.entity.StudyRoom;
import com.studyroom.entity.User;
import com.studyroom.service.NoticeService;
import com.studyroom.service.SeatService;
import com.studyroom.service.StudyRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class PageController {

    @Autowired
    private StudyRoomService studyRoomService;

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private SeatService seatService;

    // ========== 认证页面 ==========

    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }

    @GetMapping("/register")
    public String register() {
        return "auth/register";
    }

    // ========== 用户端页面 ==========

    @GetMapping({"/", "/home"})
    public String home(Model model, HttpSession session) {
        model.addAttribute("notices", noticeService.getLatestNotices(5));
        model.addAttribute("hotRooms", studyRoomService.getHotStudyRooms(4));
        model.addAttribute("currentUser", session.getAttribute("user"));
        return "user/home";
    }

    @GetMapping("/studyroom")
    public String studyRoomList(Model model, HttpSession session) {
        model.addAttribute("currentUser", session.getAttribute("user"));
        return "user/studyroom";
    }

    @GetMapping("/studyroom/{id}")
    public String studyRoomDetail(@PathVariable Long id, Model model, HttpSession session) {
        StudyRoom room = studyRoomService.getById(id);
        if (room == null) return "redirect:/studyroom";
        model.addAttribute("room", room);
        model.addAttribute("seats", seatService.getSeatsByRoomId(id));
        model.addAttribute("currentUser", session.getAttribute("user"));
        return "user/studyroomDetail";
    }

    @GetMapping("/studyroom/{id}/reserve")
    public String reservePage(@PathVariable Long id, @RequestParam Long seatId, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) return "redirect:/login";
        StudyRoom room = studyRoomService.getById(id);
        Seat seat = seatService.getById(seatId);
        if (room == null || seat == null) return "redirect:/studyroom";
        model.addAttribute("room", room);
        model.addAttribute("seat", seat);
        return "user/reserve";
    }

    @GetMapping("/reservation")
    public String myReservation(HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        return "user/reservation";
    }

    @GetMapping("/checkin")
    public String checkIn(HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        return "user/checkin";
    }

    @GetMapping("/forum")
    public String forum(HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        return "user/forum";
    }

    @GetMapping("/forum/post/{id}")
    public String forumPostDetail(@PathVariable Long id, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        return "user/forumDetail";
    }

    @GetMapping("/notice/{id}")
    public String noticeDetail(@PathVariable Long id, Model model, HttpSession session) {
        Notice notice = noticeService.getById(id);
        if (notice == null) return "redirect:/";
        // 增加浏览量
        notice.setViewCount(notice.getViewCount() == null ? 1 : notice.getViewCount() + 1);
        noticeService.updateById(notice);
        model.addAttribute("notice", notice);
        model.addAttribute("currentUser", session.getAttribute("user"));
        return "user/noticeDetail";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        return "user/profile";
    }

    // ========== 自习室管理员页面 ==========

    @GetMapping("/admin/dashboard")
    public String adminDashboard(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return "redirect:/login";
        }
        return "roomAdmin/dashboard";
    }

    @GetMapping("/admin/studyroom")
    public String adminStudyRoom(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return "redirect:/login";
        }
        return "roomAdmin/studyroom";
    }

    @GetMapping("/admin/reservation")
    public String adminReservation(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return "redirect:/login";
        }
        return "roomAdmin/reservation";
    }

    @GetMapping("/admin/checkin")
    public String adminCheckIn(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return "redirect:/login";
        }
        return "roomAdmin/checkin";
    }

    @GetMapping("/admin/forum")
    public String adminForum(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return "redirect:/login";
        }
        return "roomAdmin/forum";
    }

    @GetMapping("/admin/notice")
    public String adminNotice(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return "redirect:/login";
        }
        return "roomAdmin/notice";
    }

    @GetMapping("/admin/profile")
    public String adminProfile(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return "redirect:/login";
        }
        return "roomAdmin/profile";
    }

    // ========== 系统管理员页面 ==========

    @GetMapping("/sysadmin/dashboard")
    public String sysAdminDashboard(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 3) {
            return "redirect:/login";
        }
        return "sysAdmin/dashboard";
    }

    @GetMapping("/sysadmin/user")
    public String sysAdminUser(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 3) {
            return "redirect:/login";
        }
        return "sysAdmin/user";
    }

    @GetMapping("/sysadmin/studyroom")
    public String sysAdminStudyRoom(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 3) {
            return "redirect:/login";
        }
        return "sysAdmin/studyroom";
    }

    @GetMapping("/sysadmin/reservation")
    public String sysAdminReservation(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 3) {
            return "redirect:/login";
        }
        return "sysAdmin/reservation";
    }

    @GetMapping("/sysadmin/attendance")
    public String sysAdminAttendance(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 3) {
            return "redirect:/login";
        }
        return "sysAdmin/attendance";
    }

    @GetMapping("/sysadmin/notice")
    public String sysAdminNotice(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 3) {
            return "redirect:/login";
        }
        return "sysAdmin/notice";
    }

    @GetMapping("/sysadmin/statistics")
    public String sysAdminStatistics(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 3) {
            return "redirect:/login";
        }
        return "sysAdmin/statistics";
    }

    @GetMapping("/sysadmin/forum")
    public String sysAdminForum(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 3) {
            return "redirect:/login";
        }
        return "sysAdmin/forum";
    }
}
