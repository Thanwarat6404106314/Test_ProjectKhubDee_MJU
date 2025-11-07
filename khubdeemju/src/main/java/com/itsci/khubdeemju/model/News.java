package com.itsci.khubdeemju.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "news")
@JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
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

    // สำหรับ Generate ID อัตโนมัติ
    @PrePersist
    public void generateRecordId() {
        if (this.news_id == null) {
            this.news_id = generateCustomId();
        }
    }

    private String generateCustomId() {
        int randomNum = ThreadLocalRandom.current().nextInt(1000, 9999); // สุ่มเลข 4 หลัก (0000 - 9999)
        return String.format("NW" + randomNum);
    }

}
