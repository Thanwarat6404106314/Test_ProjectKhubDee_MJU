package com.itsci.khubdeemju.controller;

import com.itsci.khubdeemju.model.News;
import com.itsci.khubdeemju.service.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/news")
public class NewsController {

    @Autowired
    private NewsService newsService;

    @GetMapping("/getbyid/{new_id}")
    public ResponseEntity getNewsById(@PathVariable("new_id") String new_id) throws IllegalStateException{
        try{
            News news = newsService.getNewsById(new_id);
            return new ResponseEntity<>(news, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("รหัสข่าวสารไม่ถูกต้อง!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/add")
    public ResponseEntity addNews(@RequestBody Map<String,String> map){
        try{
            News news = newsService.addNews(map);
            return new ResponseEntity<>(news, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("Failed to add News data!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/list")
    public ResponseEntity getListNews(){
        try{
            List<News> news =  newsService.getListNews();
            return new ResponseEntity<>(news, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/update")
    public ResponseEntity updateNews(@RequestBody News news){
        try {
            News updateNews = newsService.updateNews(news);
            return  new  ResponseEntity<>(updateNews, HttpStatus.OK);

        }catch (Exception e){
            e.printStackTrace();
            return  new ResponseEntity<>("Failed to update News data!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/delete/{new_id}")
    public ResponseEntity deleteNews(@PathVariable("new_id") String new_id) {
        try {
            newsService.deleteNews(new_id);
            return new ResponseEntity<>("news ID " + new_id + " was deleted!", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Failed to delete!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/search")
    public ResponseEntity getSearchNews(@RequestParam("searchtext") String searchtext) {
        try {
            List<News> news = newsService.getSearchNews(searchtext);
            return new ResponseEntity<>(news, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("ไม่พบข้อมูลข่าวสาร", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }



}
