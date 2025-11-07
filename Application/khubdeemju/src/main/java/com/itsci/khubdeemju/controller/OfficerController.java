package com.itsci.khubdeemju.controller;

import com.itsci.khubdeemju.model.Officer;
import com.itsci.khubdeemju.service.OfficerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/officer")
public class OfficerController {

    @Autowired
    private OfficerService offcierService;

    @GetMapping("/getbyemail/{email}")
    public ResponseEntity getOfficetByEmail(@PathVariable("email") String email) throws IllegalStateException{
        try{
            Officer officer = offcierService.getOfficerByEmail(email);
            return new ResponseEntity<>(officer, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("ชื่อผู้ใช้หรืออีเมลไม่ถูกต้อง!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/getbyid/{officer_id}")
    public ResponseEntity getOfficerById(@PathVariable("officer_id") String officer_id) throws IllegalStateException{
        try{
            Officer officer = offcierService.getOfficerById(officer_id);
            return new ResponseEntity<>(officer, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("Failed to get By Id Officer data!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/add")
    public ResponseEntity addOfficer(@RequestBody Map<String,String> map){
        try{
            Officer officer = offcierService.addOfficer(map);
            return new ResponseEntity<>(officer, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/update")
    public ResponseEntity updateOfficer(@RequestBody Officer officer){
        try {
            Officer updateOfficer = offcierService.updateOfficer(officer);
            return  new  ResponseEntity<>(updateOfficer, HttpStatus.OK);

        }catch (Exception e){
            e.printStackTrace();
            return  new ResponseEntity<>("Failed to update Officer data!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping("/loginofficer")
    public ResponseEntity LoginOfficer(@RequestBody Map<String,String> map) throws IllegalStateException{
        try{
            Officer officer = offcierService.doLoginOfficer(map);
            if(officer != null){
                return new ResponseEntity<>(officer,HttpStatus.OK);
            }else{
                return new ResponseEntity<>("This email wasn't found in the database",HttpStatus.FORBIDDEN);
            }
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("Login Failed!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/delete/{officer_id}")
    public ResponseEntity deleteOfficer(@PathVariable("officer_id") String officer_id) {
        try {
            offcierService.deleteOfficer(officer_id);
            return new ResponseEntity<>("officer ID " + officer_id + " was deleted!", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Failed to delete!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
