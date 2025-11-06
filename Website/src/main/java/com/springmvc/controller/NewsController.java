package com.springmvc.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.springmvc.model.*;
import com.springmvc.manager.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

@Controller
public class NewsController {
	
//	News Page
	@RequestMapping(value="/news", method=RequestMethod.GET)
	public ModelAndView newsPage(HttpServletRequest request) {

		NewsManager nm = new NewsManager();
		List<News> news = nm.getListNews();

		ModelAndView mav = new ModelAndView("news");
		mav.addObject("ListNews", news);
		return mav;
	}
	
//	News Detail Page
	@RequestMapping(value="/view-news", method=RequestMethod.GET)
	public ModelAndView newsDetailPage(HttpServletRequest request) {
	    String news_id = request.getParameter("news_id");
	    NewsManager nm = new NewsManager();
	    News news = nm.getNewsByID(news_id);
	   
	    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
	    String postDateTH = outputFormat.format(news.getPost_date());

	    ModelAndView mav = new ModelAndView("view_news");
	    mav.addObject("news", news);
	    mav.addObject("postDateTH", postDateTH);
	    return mav;
	}
	
//	Add News Page
	@RequestMapping(value="/viewAddNews", method=RequestMethod.GET)
	public ModelAndView addNewsPage(HttpServletRequest request) {

		ModelAndView mav = new ModelAndView("add_news");
		mav.addObject("add_news");
		return mav;
	}

	@SuppressWarnings("unused")
	private String getFileExtension(String fileName) {
		int dotIndex = fileName.lastIndexOf('.');
		if (dotIndex > 0 && dotIndex < fileName.length() - 1) {
			 return fileName.substring(dotIndex);
		}
		return "";
	}
	
// ฟังก์ชัน parseDate แก้ไขเพื่อเพิ่มปี พ.ศ.
		private Date parseDate(String dateStr) throws ParseException {
		    // กำหนดรูปแบบวันที่ที่รับมา
		    SimpleDateFormat sDate = new SimpleDateFormat("yyyy-MM-dd");
		    Date postDate = sDate.parse(dateStr);

		    // สร้าง Calendar เพื่อเพิ่มปี พ.ศ.
		    Calendar calendar = Calendar.getInstance();
		    calendar.setTime(postDate);
		    calendar.add(Calendar.YEAR, 543); // เพิ่ม 543 ปี

		    return calendar.getTime(); // คืนค่าเป็น Date
		}
	
	public String generateFileNameWithTimestamp(String originalFilename) {
	    String extension = getFileExtension(originalFilename);
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
	    String timestamp = dateFormat.format(new Date());
	    return timestamp + (extension.isEmpty() ? "" : "." + extension);
	}

//	Add News
	@RequestMapping(value = "/add-news", method = RequestMethod.POST)
	public ModelAndView addNews(HttpServletRequest request, @RequestParam("news-date") String news_date
	) throws IOException, ParseException, Exception {
					
	    String uid = request.getParameter("officer-id");
	    String title = request.getParameter("news-title");
	    String desc = request.getParameter("news-desc");
	    Date postDate = parseDate(news_date);
	    StringBuilder news_img = new StringBuilder(); // ใช้ StringBuilder เพื่อเก็บชื่อไฟล์ภาพ

	    OfficerManager om = new OfficerManager();
	    Officer officer = om.getOfficerByID(uid);
	    ModelAndView mav = null;

	    String path = "C://img//img_news//";

	    int imageIndex = 1; // ตัวเลขเริ่มต้นสำหรับชื่อไฟล์

	    for (Part filePart : request.getParts()) {
	        if (filePart.getName().equals("imageUpload") && filePart.getSize() > 0) {
	            String originalFilename = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

	            // แยกนามสกุลไฟล์
	            String fileExtension = "";
	            int dotIndex = originalFilename.lastIndexOf('.');
	            if (dotIndex > 0) {
	                fileExtension = originalFilename.substring(dotIndex); // ดึงนามสกุลไฟล์ เช่น .png
	            }

	            // สร้างชื่อไฟล์ที่ไม่ซ้ำกันโดยเพิ่มตัวเลขต่อท้ายวันที่
	            Date dd = new Date();
	            String date1 = new SimpleDateFormat("dd-MM-yyyy-HH.mm.ss").format(dd);
	            String newFilename = "NW_" + date1 + "_" + (imageIndex++) + ".png";

	            // เขียนไฟล์ลงในโฟลเดอร์
	            filePart.write(path + File.separator + newFilename);

	            // เพิ่มชื่อไฟล์ลงใน news_img
	            if (news_img.length() > 0) {
	                news_img.append(",");
	            }
	            news_img.append(newFilename);
	        }
	    }


	    if (news_img.length() == 0) {
	        mav = new ModelAndView("add_news");
	        mav.addObject("error", "กรุณาอัพโหลดรูปภาพก่อน");
	        return mav;
	    } else {
	        mav = new ModelAndView("news");
	        mav.addObject("success", "เพิ่มข่าวสำเร็จ!");
	    }

	    // ส่วนที่ไม่เกี่ยวข้องยังคงเดิม
	    NewsManager nm = new NewsManager();
	    News news = new News();
	    news.setNews_id(null);
	    news.setTitle(title);
	    news.setDescription(desc);
	    news.setPost_date(postDate);
	    news.setImage(news_img.toString()); // บันทึกชื่อไฟล์ภาพทั้งหมดในฟิลด์เดียว
	    news.setOfficer(officer);

	    boolean isAdded = nm.addNews(news);

	    if (isAdded) {
	        mav = new ModelAndView("news");
	        mav.addObject("news", news);
	        mav.addObject("success", "เพิ่มข่าวสำเร็จ!");
	    } else {
	        mav = new ModelAndView("add_news");
	        mav.addObject("error", "เกิดข้อผิดพลาดในการเพิ่มข่าว");
	    }

	    List<News> newsList = nm.getListNews();

	    SimpleDateFormat outputFormat = new SimpleDateFormat("dd/MM/yyyy", new Locale("th", "TH"));
	    List<Map<String, Object>> formattedNewsList = new ArrayList<>();
	    for (News n : newsList) {
	        Map<String, Object> newsData = new HashMap<>();
	        newsData.put("news", n);
	        if (n.getPost_date() != null) {
	            String formattedDate = outputFormat.format(n.getPost_date());
	            newsData.put("formattedPostDate", formattedDate);
	        } else {
	            newsData.put("formattedPostDate", "ไม่มีวันที่");
	        }
	        formattedNewsList.add(newsData);
	    }

	    return new ModelAndView("redirect:/news");
	}

	
	
//	Edit News Page
	@RequestMapping(value="/viewEditNews", method=RequestMethod.GET)
	public ModelAndView editNewsPage(HttpServletRequest request) {
	    String news_id = request.getParameter("news_id");
	    NewsManager nm = new NewsManager();
	    News news = nm.getNewsByID(news_id);
	    
	    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
	    String postDateTH = outputFormat.format(news.getPost_date());

	    ModelAndView mav = new ModelAndView("edit_news");
	    mav.addObject("news", news);
	    mav.addObject("postDateTH", postDateTH);
	    return mav;
	}
	
//	Edit News
	@RequestMapping(value = "/edit-news", method = RequestMethod.POST)
	public ModelAndView editNews(HttpServletRequest request, @RequestParam("news-date") String news_date) 
	        throws IOException, ParseException, Exception {

	    String news_id = request.getParameter("news_id");
	    String title = request.getParameter("news-title");
	    String desc = request.getParameter("news-desc");
	    String news_img = "";  
	    String uid = request.getParameter("officer-id");

	    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");  
	    Date postDate = df.parse(news_date);  // แปลงวันที่

	    OfficerManager om = new OfficerManager();
	    Officer officer = om.getOfficerByID(uid);

	    Part filePart = request.getPart("imageUpload");
	    if (filePart != null && filePart.getSize() > 0) {
	        news_img = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
	        String path = "C://img//img_news//";

	        System.out.println("Img news: " + news_img + " path: " + path);

	        Date dd = new Date();
	        Calendar c1 = Calendar.getInstance();
	        c1.setTime(dd);
	        dd = c1.getTime();
	        String date1 = new SimpleDateFormat("dd-MM-yyyy-HH.mm.ss").format(dd);
	        String newFilename = "NW_" + date1 + ".png";

	        filePart.write(path + File.separator + newFilename); 
	        news_img = newFilename;  
	        System.out.println("NEW: " + news_img);
	    } else {
	        news_img = request.getParameter("imageUpload");
	    }

	    NewsManager nm = new NewsManager();
	    News news = new News();
	    news.setNews_id(news_id);
	    news.setTitle(title);
	    news.setDescription(desc);
	    news.setPost_date(postDate);
	    
	    if (filePart != null && filePart.getSize() > 0) { 
	    	news.setImage(news_img);
	    } else {
	    	News n = nm.getNewsByID(news_id);
	    	String img = n.getImage();
	    	news.setImage(img);
	    }
	    
	    news.setOfficer(officer);

	    boolean repo = nm.updateNews(news);  // อัปเดตข้อมูลข่าวสารในฐานข้อมูล

	    // ดึงข้อมูลข่าวสารทั้งหมด
	    List<News> newsList = nm.getListNews();
	    SimpleDateFormat outputFormat = new SimpleDateFormat("dd/MM/yyyy", new Locale("th", "TH"));
	    List<Map<String, Object>> formattedNewsList = new ArrayList<>();

	    for (News n : newsList) {
	        Map<String, Object> newsData = new HashMap<>();
	        newsData.put("news", n);
	        if (n.getPost_date() != null) {
	            String formattedDate = outputFormat.format(n.getPost_date());
	            newsData.put("formattedPostDate", formattedDate);
	        } else {
	            newsData.put("formattedPostDate", "ไม่มีวันที่");
	        }
	        formattedNewsList.add(newsData);
	    }

	    // ส่งกลับไปยังหน้าหลักของข่าว
	    return new ModelAndView("redirect:/news");
	}


//	Delete News
	@RequestMapping(value="/delete-news", method=RequestMethod.POST)
	public ResponseEntity<String> deleteNews(@RequestParam("news_id") String newsId) {
	    NewsManager nm = new NewsManager();
	    News news = nm.getNewsByID(newsId);
	    
	    boolean isDeleted = nm.deleteNews(news);
	    
	    if (isDeleted) {
	        System.out.println("Delete news: " + isDeleted);
	        return ResponseEntity.ok("ลบข่าวสำเร็จ");
	    } else {
	        System.out.println("Delete news: " + isDeleted);
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("ไม่สามารถลบข่าวได้");
	    }
	}
	
//	Search News
	@RequestMapping(value="/searchNews", method=RequestMethod.POST) 
	public ModelAndView searchNews(HttpServletRequest request) {
		String searchtext = request.getParameter("searchtext");
		
		ModelAndView mav = new ModelAndView("news");
		NewsManager nm = new NewsManager();
		List<News> news = nm.getSearchNews(searchtext);
		mav.addObject("ListNews", news);
		return mav;
	}
	

}
