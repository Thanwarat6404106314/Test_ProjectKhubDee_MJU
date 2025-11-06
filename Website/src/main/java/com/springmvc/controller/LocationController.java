package com.springmvc.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.manager.LocationManager;
import com.springmvc.manager.NewsManager;
import com.springmvc.model.HibernateConnection;
import com.springmvc.model.Location;
import com.springmvc.model.News;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class LocationController {
	
	@RequestMapping(value="/location", method=RequestMethod.GET)
	public ModelAndView locationPage(HttpServletRequest request) {

		LocationManager lm = new LocationManager();
		List<Location> location = lm.getListLocation();

		ModelAndView mav = new ModelAndView("list_location");
		mav.addObject("ListLocation", location);
		return mav;
	}
	
	@RequestMapping(value="/viewAddLocation", method=RequestMethod.GET)
	public ModelAndView addNewsPage(HttpServletRequest request) {

		ModelAndView mav = new ModelAndView("add_location");
		mav.addObject("add_location");
		return mav;
	}
	
	//add-location	
	@RequestMapping(value = "/add-location", method = RequestMethod.POST)
	public ModelAndView addLocation(HttpServletRequest request) {
	    String location_id = request.getParameter("location-id");
	    String location_name = request.getParameter("location-name");

	    LocationManager lm = new LocationManager();
	    Location location = new Location(location_id, location_name);

	    Location existingLocation = lm.findLocationById(location_id);

	    ModelAndView mav = null;

	    if (existingLocation != null) {
	        mav = new ModelAndView("add_location");
	        mav.addObject("error", "ไม่สามารถเพิ่มสถานที่ได้ เนื่องจากรหัสสถานที่ซ้ำกัน");
	    } else {
	        boolean isAdded = lm.addLocation(location);
	        
	        if (isAdded) {
	            mav = new ModelAndView("redirect:/location");
	            mav.addObject("location", location);
	            mav.addObject("success", "เพิ่มสถานที่สำเร็จ");
	        } else {
	            mav = new ModelAndView("add_location");
	        }
	    }
	    return mav;
	}
	
	//Edit Location Page
	@RequestMapping(value="/viewEditLocation", method=RequestMethod.GET)
	public ModelAndView editLocationPage(HttpServletRequest request) {
	    String location_id = request.getParameter("location_id");
	    LocationManager lm = new LocationManager();
	    Location location = lm.getLocatonByID(location_id);

	    ModelAndView mav = new ModelAndView("edit_location");
	    mav.addObject("location", location);
	    return mav;
	}
	
	//edit-location
	@RequestMapping(value = "/edit-location", method = RequestMethod.POST)
	public ModelAndView editLocation(HttpServletRequest request) {
	    String location_id = request.getParameter("location-id");
	    String location_name = request.getParameter("location-name");

	    LocationManager lm = new LocationManager();
	    Location location = new Location(location_id, location_name);
	    ModelAndView mav = null;

	    boolean isEditted = lm.updateNews(location);
	    
	    if (isEditted) {
	    	mav = new ModelAndView("redirect:/location");
	    	mav.addObject("location", location);
	        mav.addObject("success", "แก้ไขสถานที่สำเร็จ");
	    } else {
	    	mav = new ModelAndView("edit_location");
	    	mav.addObject("error", "แก้ไขสถานที่ไม่สำเร็จ");
	    }
	    return new ModelAndView("redirect:/location");
	}
	    
	
	
	
	//Delete Location
	@RequestMapping(value="/delete-location", method=RequestMethod.POST)
	public ResponseEntity<String> deleteNews(@RequestParam("location_id") String location_id) {
	    LocationManager lm = new LocationManager();
	    Location location= lm.getLocatonByID(location_id);
	    
	    boolean isDeleted = lm.deleteLocation(location);
	    
	    if (isDeleted) {
	        System.out.println("Delete location: " + isDeleted);
	        return ResponseEntity.ok("ลบสถานที่สำเร็จ");
	    } else {
	    	System.out.println("Delete location: " + isDeleted);
	    	return ResponseEntity.status(400).body("ไม่สามารถลบสถานที่นี้ได้");
	    }
	}
	

	
	
	
	

}
