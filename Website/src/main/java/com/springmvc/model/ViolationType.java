package com.springmvc.model;

import javax.persistence.*;

@Entity
@Table(name = "violationtype")
public class ViolationType {

	@Id
	@Column(name = "violation_id", length = 4)
	private String violation_id;

	@Column(name = "violation_name", length = 50, nullable = false)
	private String violation_name;

	@Column(name = "deduct_score", nullable = false)
	private int deduct_score;

	public ViolationType() {
	}

	public ViolationType(String violation_id, String violation_name, int deduct_score) {
		super();
		this.violation_id = violation_id;
		this.violation_name = violation_name;
		this.deduct_score = deduct_score;
	}

	public String getViolation_id() {
		return violation_id;
	}

	public void setViolation_id(String violation_id) {
		this.violation_id = violation_id;
	}

	public String getViolation_name() {
		return violation_name;
	}

	public void setViolation_name(String violation_name) {
		this.violation_name = violation_name;
	}

	public int getDeduct_score() {
		return deduct_score;
	}

	public void setDeduct_score(int deduct_score) {
		this.deduct_score = deduct_score;
	}

}