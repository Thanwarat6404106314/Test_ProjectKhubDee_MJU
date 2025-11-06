package com.springmvc.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionDB {
	String url = "jdbc:mysql://localhost:3306/project496_db?characterEncoding=UTF-8"; 
	String uname = "khubdee";
	String pwd = "1234";

	Connection con;

	public ConnectionDB() {
		// TODO Auto-generated constructor stub
	}

	public Connection getConnection() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection(url, uname, pwd);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return con;
	}

    // เอาไว้เทสว่าเชื่อมกับ MySQL สำเร็จหรือไม่
	public static void main(String args[]) {
		ConnectionDB condb = new ConnectionDB();
		System.out.println(condb.getConnection());
	}
}
