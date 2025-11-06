package com.springmvc.model;

import javax.persistence.*;

@Entity
@Table(name = "location")
public class Location {

	@Id
	@Column(name = "location_id", length = 4)
	private String location_id;

	@Column(name = "location_name", length = 50, nullable = false)
	private String location_name;

	public Location() {
	}

	public Location(String location_id, String location_name) {
		super();
		this.location_id = location_id;
		this.location_name = location_name;
	}

	public String getLocation_id() {
		return location_id;
	}

	public void setLocation_id(String location_id) {
		this.location_id = location_id;
	}

	public String getLocation_name() {
		return location_name;
	}

	public void setLocation_name(String location_name) {
		this.location_name = location_name;
	}

}