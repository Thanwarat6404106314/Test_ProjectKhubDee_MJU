package com.springmvc.manager;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.springmvc.model.*;

public class NewsManager {
	
	public boolean addNews(News news) {
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
			session.save(news);
			session.getTransaction().commit();
			session.close();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean updateNews(News news) {
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
			session.update(news);
			session.getTransaction().commit();
			session.close();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean deleteNews(News news) {
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
			session.delete(news);
			session.getTransaction().commit();
			session.close();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<News> getListNews() {
		List<News> list = new ArrayList<>();
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();

			list = session.createQuery("FROM News ORDER BY post_date DESC").list();

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public News getNewsByID(String news_id) {
		News news = null;
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();

			@SuppressWarnings("unchecked")
			List<News> list = session.createQuery("FROM News WHERE news_id = '" + news_id + "'").list();
			news = list.get(0);

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return news;
	}
	
	public List<News> getSearchNews(String searchtext) {
		List<News> list = new ArrayList<>();
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
			list = session.createQuery("FROM News WHERE title like '%" + searchtext + "%'").list();

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}
