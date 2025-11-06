package com.springmvc.manager;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.springmvc.model.*;

public class NotificationManager {
		
	public Notification getNotificationByID(String notification_id) {
		Notification notification = null;
	    Session session = null;

	    try {
	        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
	        session = sessionfactory.openSession();
	        session.beginTransaction();

	        @SuppressWarnings("unchecked")
	        List<Notification> list = session.createQuery("FROM Notification WHERE notification_id = :notification_id")
	        								.setParameter("notification_id", notification_id).list();

	        if (!list.isEmpty()) {
	            notification = list.get(0);
	        } else {
	            System.out.println("No officer found with ID: " + notification_id);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (session != null) {
	            session.close();
	        }
	    }
	    return notification;
	}
	
	public boolean addNotification(Notification notification) {
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
			session.save(notification);
			session.getTransaction().commit();
			session.close();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
