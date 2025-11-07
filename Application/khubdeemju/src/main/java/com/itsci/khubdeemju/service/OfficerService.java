package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.Officer;

import java.text.ParseException;
import java.util.*;

public interface OfficerService {

    Officer getOfficerByEmail (String email);

    Officer getOfficerById(String officer_id);

    Officer addOfficer(Map<String, String> map) throws ParseException;

    Officer updateOfficer(Officer officer);

    Officer doLoginOfficer(Map<String, String> map);

    void deleteOfficer(String officer_id);
}
