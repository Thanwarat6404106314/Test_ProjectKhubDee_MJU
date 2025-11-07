package com.itsci.khubdeemju.controller;

import com.itsci.khubdeemju.model.Location;
import com.itsci.khubdeemju.model.Notification;
import com.itsci.khubdeemju.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/location")
public class LocationController {
    
    @Autowired
    private LocationService locationService;

    @GetMapping("/getbyid/{location_id}")
    public ResponseEntity getLocationById(@PathVariable("location_id") String location_id) throws IllegalStateException{
        try{
            Location location = locationService.getLocationById(location_id);
            return new ResponseEntity<>(location, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("Location ID not found!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/add")
    public ResponseEntity addLocation(@RequestBody Map<String,String> map){
        try{
            Location location = locationService.addLocation(map);
            return new ResponseEntity<>(location, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/update")
    public ResponseEntity updatelocation(@RequestBody Location location){
        try {
            Location updateLocation = locationService.updateLocation(location);
            return  new  ResponseEntity<>(updateLocation, HttpStatus.OK);

        }catch (Exception e){
            e.printStackTrace();
            return  new ResponseEntity<>("Failed to update location!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/delete/{location_id}")
    public ResponseEntity deleteLocation(@PathVariable("location_id") String location_id) {
        try {
            locationService.deleteLocation(location_id);
            return new ResponseEntity<>("violation ID " + location_id + " was deleted!", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Failed to delete!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/list")
    public ResponseEntity getListLocation(){
        try{
            List<Location> location =  locationService.getListLocation();
            return new ResponseEntity<>(location, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("ไม่พบข้อมูลรายการสถานที่", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
