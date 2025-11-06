package com.springmvc.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.*;
import com.springmvc.manager.*;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class StudentController {
	
//	News Page
	@RequestMapping(value="/student", method=RequestMethod.GET)
	public ModelAndView studentPage(HttpServletRequest request) {

		StudentManager sm = new StudentManager();
		List<Student> student = sm.getListStudent();

		ModelAndView mav = new ModelAndView("ListStudent");
		mav.addObject("ListStudent", student);
		return mav;
	}
	
//	Search News
	@RequestMapping(value="/student/search", method=RequestMethod.POST) 
	public ModelAndView searchStudent(HttpServletRequest request) {
		String searchtext = request.getParameter("searchtext");
		
		ModelAndView mav = new ModelAndView("ListStudent");
		StudentManager sm = new StudentManager();
		List<Student> ls = sm.getSearchStudent(searchtext);
		mav.addObject("Student", ls);
		return mav;
	}
	
}
