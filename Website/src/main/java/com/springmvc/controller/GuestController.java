package com.springmvc.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class GuestController {
	
	// Default
	@RequestMapping(value="/", method=RequestMethod.GET)
	public String defaultIndexPage() {
		return "index";
	}
	
	// Index
	@RequestMapping(value="/index", method=RequestMethod.GET)
	public ModelAndView openIndexPage() {
		ModelAndView mav = new ModelAndView("index");
			return mav;
	}
	
	// home
	@RequestMapping(value="/home", method=RequestMethod.GET)
	public ModelAndView openHomePage() {
		ModelAndView mav = new ModelAndView("home");
			return mav;
	}

	//---------------------------------------------------------------------------
	
	// Signin
	@RequestMapping(value="/signin", method=RequestMethod.GET)
	public ModelAndView openLoginPage() {
		ModelAndView mav = new ModelAndView("signin");
			return mav;
	}
	
	//---------------------------------------------------------------------------


	
	
}
