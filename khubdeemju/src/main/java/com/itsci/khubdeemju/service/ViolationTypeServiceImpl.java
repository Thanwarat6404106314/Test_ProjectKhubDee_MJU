package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.ViolationType;
import com.itsci.khubdeemju.repository.ViolationTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.*;

@Service
public class ViolationTypeServiceImpl implements ViolationTypeService {

    @Autowired
    private ViolationTypeRepository violationTypeRepository;

    public ViolationTypeServiceImpl(ViolationTypeRepository violationTypeRepository) {
        this.violationTypeRepository = violationTypeRepository;
    }

    @Override
    public ViolationType getViolationTypeById(String violation_id) {
        return violationTypeRepository.getReferenceById(violation_id);
    }

    @Override
    public ViolationType addViolationType(Map<String, String> map) throws ParseException {
        String violation_id = map.get("violation_id");
        String violation_name = map.get("violation_name");
        int deduct_score = Integer.parseInt(map.get("deduct_score"));


        ViolationType violationType = new ViolationType(violation_id, violation_name, deduct_score);
        return violationTypeRepository.save(violationType);
    }

    @Override
    public ViolationType updateViolationType(ViolationType violationType) {
        return violationTypeRepository.save(violationType);
    }

    @Override
    public void deleteViolationType(String violation_id) {
        ViolationType violationType = violationTypeRepository.getReferenceById(violation_id);
        violationTypeRepository.delete(violationType);
    }

    @Override
    public List<ViolationType> getListViolationType() {
        return violationTypeRepository.findAll();
    }

}
