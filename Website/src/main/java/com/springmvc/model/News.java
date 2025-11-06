package com.springmvc.model;

import javax.persistence.*;
import java.util.Date;
import java.util.concurrent.ThreadLocalRandom;

@Entity
@Table(name = "news")
public class News {

	@Id
	@Column(name = "news_id", length = 6)
	private String news_id;

	@Column(name = "title", length = 100, nullable = false)
	private String title;

	@Column(name = "description", columnDefinition = "TEXT", nullable = false)
	private String description;

	@Column(name = "image", columnDefinition = "TEXT", nullable = false)
	private String image;

	@Column(name = "post_date", nullable = false)
	private Date post_date;

	@ManyToOne
	@JoinColumn(name = "officer_id", nullable = false)
	private Officer officer;

	public News() {
	}

	public News(String news_id, String title, String description, String image, Date post_date, Officer officer) {
		super();
		this.news_id = news_id;
		this.title = title;
		this.description = description;
		this.image = image;
		this.post_date = post_date;
		this.officer = officer;
	}

	public String getNews_id() {
		return news_id;
	}

	public void setNews_id(String news_id) {
		this.news_id = news_id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public Date getPost_date() {
		return post_date;
	}

	public void setPost_date(Date post_date) {
		this.post_date = post_date;
	}

	public Officer getOfficer() {
		return officer;
	}

	public void setOfficer(Officer officer) {
		this.officer = officer;
	}

	@PrePersist
	public void generateRecordId() {
		if (this.news_id == null) {
			this.news_id = generateCustomId();
		}
	}

	private String generateCustomId() {
		int randomNum = ThreadLocalRandom.current().nextInt(0001, 9999);
		return String.format("NW%04d", randomNum);
	}
}
