package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.ViolationType;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface ViolationTypeService {

    ViolationType getViolationTypeById (String violation_id);

    ViolationType addViolationType (Map<String,String> map) throws ParseException;

    ViolationType updateViolationType (ViolationType violationType);

    List<ViolationType> getListViolationType();

    void deleteViolationType(String violation_id);;
}
