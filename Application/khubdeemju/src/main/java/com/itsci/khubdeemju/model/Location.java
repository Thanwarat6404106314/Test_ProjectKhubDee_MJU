package com.itsci.khubdeemju.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "Location")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Location {

    @Id
    @Column(name = "location_id", length = 4)
    private String location_id;
    @Column(name = "location_name", length = 50, nullable = false)
    private String location_name;

    
    
}
