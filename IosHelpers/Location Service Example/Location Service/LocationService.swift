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
    
    var isLocationOnlyWhenInUse = true
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    var listeners = [LocationListener]()
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    
    }
    
    func requestAuthorization() {
        if isLocationOnlyWhenInUse {
            locationManager?.requestWhenInUseAuthorization()
        }
        else {
            locationManager?.requestAlwaysAuthorization()
        }
    }
    
    @discardableResult
    func isLocationEnabled(withAuthorizationWhenInUse: Bool) -> (Bool,String?) {
        isLocationOnlyWhenInUse = withAuthorizationWhenInUse
        if CLLocationManager.locationServicesEnabled() {
            
            switch getAuthorizationStatus() {
            
            case .restricted:
                return (false, "Location ussage has been restricted. Please enable it in your settings")
            case .denied:
                return (false, "Location ussage has been denied. Please enable it in your settings")
            case .notDetermined:
                requestAuthorization()
                return (true,nil)
            case .authorizedWhenInUse, .authorizedAlways:
                return (true,nil)
                
            }
        }
        return (false,"Location service could not be enabled")
    }
    
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        // Sending message to each of the delegates
        for listener in listeners {
            listener.locationDidChange(location: currentLocation!)
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "errorLocation"),object: nil)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "authorizationStatusChanged"), object: nil)
    }
    
    
    /// Adds a new listener to the listeners array
    ///
    /// - parameter delegate: a new listener
    func addListener(listener: LocationListener){
        listeners.append(listener)
    }
    
    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    func removeListener(listener: LocationListener){
        listeners = listeners.filter{ $0 !== listener}
    }
    
}

