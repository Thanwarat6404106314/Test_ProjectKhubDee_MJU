package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.News;
import com.itsci.khubdeemju.model.Officer;
import com.itsci.khubdeemju.repository.NewsRepository;
import com.itsci.khubdeemju.repository.OfficerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class NewsServiceImpl implements NewsService {

    @Autowired
    private NewsRepository newsRepository;

    @Autowired
    private OfficerRepository officerRepository;

    public NewsServiceImpl(NewsRepository newsRepository) {
        this.newsRepository = newsRepository;
    }

    @Override
    public News getNewsById(String new_id) {
        return newsRepository.getReferenceById(new_id);
    }

    @Override
    public Officer getOfficerById(String officer_id) {
        return officerRepository.getReferenceById(officer_id);
    }

    @Override
    public News addNews(Map<String, String> map) throws ParseException{
//        String news_id = map.get("news_id");
        String title = map.get("title");
        String description = map.get("description");
        String image = map.get("image");
//      รูปแบบวันที่
        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
        Date post_date;
        try {
            post_date = format.parse(map.get("post_date"));
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
//      ดึงรหัสเจ้าหน้าที่
        String officer_id = map.get("officer");
        Officer officer = getOfficerById(officer_id);

        News news = new News(null, title, description, image, post_date, officer);
        return newsRepository.save(news);
    }

    @Override
    public List<News> getListNews() {
        return newsRepository.findAll();
    }

    @Override
    public News updateNews(News news) {
        return newsRepository.save(news);
    }

    @Override
    public void deleteNews(String news_id) {
        News news = newsRepository.getReferenceById(news_id);
        newsRepository.delete(news);
    }

    @Override
    public List<News> getSearchNews(String searchtext) {
        return newsRepository.findByTitle(searchtext);
    }

}
