package com.springmvc.manager;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.springmvc.model.HibernateConnection;
import com.springmvc.model.Location;

public class LocationManager {
	
	@SuppressWarnings("unchecked")
	public List<Location> getListLocation() {
		List<Location> list = new ArrayList<>();
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();

			list = session.createQuery("FROM Location ORDER BY location_id").list();

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public boolean addLocation(Location location) {
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
			session.save(location);
			session.getTransaction().commit();
			session.close();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean updateNews(Location location) {
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
			session.update(location);
			session.getTransaction().commit();
			session.close();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean deleteLocation(Location location) {
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();
			session.delete(location);
			session.getTransaction().commit();
			session.close();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public Location getLocatonByID(String location_id) {
		Location location = null;
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();

			@SuppressWarnings("unchecked")
			List<Location> list = session.createQuery("FROM Location WHERE location_id = '" + location_id + "'").list();
			location = list.get(0);

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return location;
	}
	
	public Location findLocationById(String location_id) {
	    Location location = null;
	    try {
	        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
	        Session session = sessionfactory.openSession();
	        session.beginTransaction();

	        @SuppressWarnings("unchecked")
	        List<Location> list = session.createQuery("FROM Location WHERE location_id = :location_id")
	                                     .setParameter("location_id", location_id)
	                                     .list();
	        
	        // ตรวจสอบว่า list ว่างหรือไม่
	        if (!list.isEmpty()) {
	            location = list.get(0);
	        }

	        session.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return location;
	}
}
