package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.Officer;
import com.itsci.khubdeemju.repository.OfficerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class OfficerServiceImpl implements OfficerService {

    @Autowired
    private OfficerRepository officerRepository;

    public OfficerServiceImpl(OfficerRepository officerRepository) {
        this.officerRepository = officerRepository;
    }

    @Override
    public Officer getOfficerByEmail(String email) {
        return officerRepository.getOfficerByEmail(email);
    }

    @Override
    public Officer getOfficerById(String officer_id) {
        return officerRepository.getReferenceById(officer_id);
    }

    @Override
    public Officer addOfficer(Map<String, String> map) {
        String officer_id = map.get("officer_id");
        String firstname = map.get("firstname");
        String lastname = map.get("lastname");
        String position = map.get("position");
        String signature = map.get("signature");
        String img_officer = map.get("img_officer");
        String email = map.get("email");
        String password = map.get("password");

        Officer officer = new Officer(officer_id,firstname,lastname,position,signature,img_officer,email,password);
        return officerRepository.save(officer);
    }

    @Override
    public Officer updateOfficer(Officer officer) {
        return officerRepository.save(officer);
    }

    @Override
    public Officer doLoginOfficer(Map<String, String> map) {
        String email = map.get("email");
        String password = map.get("password");

        Officer officer = officerRepository.getOfficerByEmail(email);
        if (officer != null && officer.getPassword().equals(password)) {
            return officer;
        }else {
            return null;
        }
    }

    @Override
    public void deleteOfficer(String officer_id) {
        Officer officer = officerRepository.getReferenceById(officer_id);
        officerRepository.delete(officer);
    }
}
