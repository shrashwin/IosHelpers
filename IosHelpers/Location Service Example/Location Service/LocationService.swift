//
//  LocationService.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared : LocationService = {
        let instance = LocationService()
        return instance
    }()
    
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        
    }
    
    @discardableResult
    func isLocationEnabled() -> Bool {
        
        if CLLocationManager.locationServicesEnabled() {
            
            if getAuthorizationStatus().rawValue < 3  && getAuthorizationStatus().rawValue > 0{
                
                return false
            }
            else if getAuthorizationStatus().rawValue == 0 {
                
                self.locationManager?.requestWhenInUseAuthorization()
            }
            
            return true
            
        }
        return false
    }
    
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func startUpdatingLocation() {
        
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.currentLocation = locations.last
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorLocation"),object: nil)
        
    }
    
    func updateLocation(currentLocation:CLLocation){
        //let lat = currentLocation.coordinate.latitude
        //let lon = currentLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authorizationStatusChanged"), object: nil)
    }
    
}

