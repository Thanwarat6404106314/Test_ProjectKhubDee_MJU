package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.News;
import com.itsci.khubdeemju.model.Officer;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface NewsService {

    News getNewsById (String news_id);

    Officer getOfficerById(String officer_id);

    News addNews (Map<String,String> map) throws ParseException;

    List<News> getListNews();

    News updateNews (News news);

    void deleteNews(String news_id);

    List<News> getSearchNews(String searchtext);
}
