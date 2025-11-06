package com.springmvc.manager;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.springmvc.model.*;

public class OfficerManager {
//	ID
	public Officer getOfficerByID(String officer_id) {
	    Officer officer = null;
	    Session session = null;

	    try {
	        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
	        session = sessionfactory.openSession();
	        session.beginTransaction();

	        @SuppressWarnings("unchecked")
	        List<Officer> list = session.createQuery("FROM Officer WHERE officer_id = :officerId").setParameter("officerId", officer_id).list();

	        if (!list.isEmpty()) {
	            officer = list.get(0);
	        } else {
	            System.out.println("No officer found with ID: " + officer_id);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (session != null) {
	            session.close();
	        }
	    }

	    return officer;
	}
	
//	Email
	public Officer getOfficerByEmail(String email) {
	    Officer o = null;
	    try {
	        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
	        Session session = sessionfactory.openSession();
	        session.beginTransaction();

	        @SuppressWarnings("unchecked")
	        List<Officer> list = session.createQuery("FROM Officer WHERE email = :email")
	                                     .setParameter("email", email)
	                                     .list();
	        
	        if (!list.isEmpty()) {
	            o = list.get(0);
	        }

	        session.getTransaction().commit(); // commit the transaction
	        session.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return o;
	}

	
	@SuppressWarnings("unchecked")
	public List<Officer> getListOfficer() {
		List<Officer> list = new ArrayList<>();
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();

			list = session.createQuery("FROM Officer ORDER BY officer_id OR email").list();

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

}
