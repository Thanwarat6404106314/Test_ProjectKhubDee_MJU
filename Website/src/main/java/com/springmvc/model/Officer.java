package com.springmvc.model;

import javax.persistence.*;

@Entity
@Table(name = "officer")
public class Officer {

	@Id
	@Column(name = "officer_id", length = 10)
	private String officer_id;

	@Column(name = "firstname", length = 50, nullable = false)
	private String firstname;

	@Column(name = "lastname", length = 50, nullable = false)
	private String lastname;

	@Column(name = "position", length = 30, nullable = false)
	private String position;

	@Column(name = "signature", length = 255, nullable = false)
	private String signature;

	@Column(name = "img_officer")
	private String img_officer;

	@Column(name = "email", length = 50, nullable = false)
	private String email;

	@Column(name = "password", length = 20, nullable = false)
	private String password;

	public Officer() {
	}

	public Officer(String officer_id, String firstname, String lastname, String position, String signature,
			String img_officer, String email, String password) {
		super();
		this.officer_id = officer_id;
		this.firstname = firstname;
		this.lastname = lastname;
		this.position = position;
		this.signature = signature;
		this.img_officer = img_officer;
		this.email = email;
		this.password = password;
	}

	public String getOfficer_id() {
		return officer_id;
	}

	public void setOfficer_id(String officer_id) {
		this.officer_id = officer_id;
	}

	public String getFirstname() {
		return firstname;
	}

	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}

	public String getLastname() {
		return lastname;
	}

	public void setLastname(String lastname) {
		this.lastname = lastname;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getSignature() {
		return signature;
	}

	public void setSignature(String signature) {
		this.signature = signature;
	}

	public String getImg_officer() {
		return img_officer;
	}

	public void setImg_officer(String img_officer) {
		this.img_officer = img_officer;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

}