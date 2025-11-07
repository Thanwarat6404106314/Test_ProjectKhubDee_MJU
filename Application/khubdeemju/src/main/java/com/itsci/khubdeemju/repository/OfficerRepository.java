package com.itsci.khubdeemju.repository;

import com.itsci.khubdeemju.model.Officer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OfficerRepository extends JpaRepository<Officer, String> {

    Officer getOfficerByEmail(String email);
}
