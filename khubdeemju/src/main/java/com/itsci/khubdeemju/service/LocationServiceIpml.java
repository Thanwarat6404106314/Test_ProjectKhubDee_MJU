package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.Location;
import com.itsci.khubdeemju.repository.LocationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.*;

@Service
public class LocationServiceIpml implements LocationService{

    @Autowired
    private LocationRepository locationRepository;

    public LocationServiceIpml(LocationRepository locationRepository) {
        this.locationRepository = locationRepository;
    }

    @Override
    public Location getLocationById(String location_id) {
        return locationRepository.getReferenceById(location_id);
    }

    @Override
    public Location addLocation(Map<String, String> map) throws ParseException {
        String location_id = map.get("location_id");
        String location_name = map.get("location_name");

        Location location = new Location(location_id, location_name);
        return locationRepository.save(location);
    }

    @Override
    public Location updateLocation(Location location) {
        return locationRepository.save(location);    
    }

    @Override
    public void deleteLocation(String location_id) {
        Location location = locationRepository.getReferenceById(location_id);
        locationRepository.delete(location);    
    }

    @Override
    public List<Location> getListLocation() {
        return locationRepository.findAll();    
    }
    
}
