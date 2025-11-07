package com.itsci.khubdeemju.controller;

import com.itsci.khubdeemju.model.ViolationType;
import com.itsci.khubdeemju.service.ViolationTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/violationtype")
public class ViolationTypeController {

    @Autowired
    private ViolationTypeService violationTypeService;

    @GetMapping("/getbyid/{violation_id}")
    public ResponseEntity getViolationTypeById(@PathVariable("violation_id") String violation_id) throws IllegalStateException{
        try{
            ViolationType violationType = violationTypeService.getViolationTypeById(violation_id);
            return new ResponseEntity<>(violationType, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("รหัสการกระทำผิดไม่ถูกต้อง!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/add")
    public ResponseEntity addViolationType(@RequestBody Map<String,String> map){
        try{
            ViolationType violationType = violationTypeService.addViolationType(map);
            return new ResponseEntity<>(violationType, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/update")
    public ResponseEntity updateViolationType(@RequestBody ViolationType violationType){
        try {
            ViolationType updateViolationType = violationTypeService.updateViolationType(violationType);
            return  new  ResponseEntity<>(updateViolationType, HttpStatus.OK);

        }catch (Exception e){
            e.printStackTrace();
            return  new ResponseEntity<>("Failed to update Member data!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/delete/{violation_id}")
    public ResponseEntity deleteViolationType(@PathVariable("violation_id") String violation_id) {
        try {
            violationTypeService.deleteViolationType(violation_id);
            return new ResponseEntity<>("violation ID " + violation_id + " was deleted!", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Failed to delete!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/list")
    public ResponseEntity getListViolationType(){
        try{
            List<ViolationType> violationType =  violationTypeService.getListViolationType();
            return new ResponseEntity<>(violationType, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("ไม่พบข้อมูลรายการละเมิดกฎจราจร", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }




}
