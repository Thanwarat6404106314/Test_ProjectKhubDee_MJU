package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.Location;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface LocationService {
    Location getLocationById (String location_id);

    Location addLocation (Map<String,String> map) throws ParseException;

    Location updateLocation (Location location);

    List<Location> getListLocation();

    void deleteLocation (String location_id);
}
