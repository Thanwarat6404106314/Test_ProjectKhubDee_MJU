package com.springmvc.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.*;
import com.springmvc.manager.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class OfficerController {
	
	// Index
	@RequestMapping(value="/home", method=RequestMethod.POST)
	public ModelAndView signinOffcierPage(HttpServletRequest request, HttpSession session) {
	    String email = request.getParameter("email");
	    String pwd = request.getParameter("password");
	    System.out.println("Login Email: " + email + " Password: " + pwd);

	    ModelAndView mav = null;
	    OfficerManager ofm = new OfficerManager();
	    Officer officer = ofm.getOfficerByEmail(email);

	    if (officer == null) { // กรณีที่อีเมลไม่มีอยู่ในระบบ
	        System.out.println("Email not found.");
	        mav = new ModelAndView("signin");
	        mav.addObject("error", "อีเมลของคุณไม่ถูกต้อง กรุณาตรวจสอบและลองใหม่อีกครั้ง");
	    } else if (officer.getPassword().equals(pwd)) { // ตรวจสอบรหัสผ่าน
	        System.out.println("Login successful. Position: " + officer.getPosition());
	        mav = new ModelAndView("home");
	        session.setAttribute("officer", officer);
	        mav.addObject("success", "เข้าสู่ระบบสำเร็จ! มาลุยกันเถอะ!");
	    } else { // รหัสผ่านไม่ถูกต้อง
	        System.out.println("Password invalid.");
	        mav = new ModelAndView("signin");
	        mav.addObject("error", "รหัสผ่านของคุณไม่ถูกต้อง กรุณาตรวจสอบและลองใหม่อีกครั้ง");
	    }

	    return mav;
	}

	
	@RequestMapping(value = "/logout", method = RequestMethod.GET) 
    public String logout(HttpSession session){
        session.removeAttribute("officer");
        session.setMaxInactiveInterval(0);
        return "index";
    }

}
