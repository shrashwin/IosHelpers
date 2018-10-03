//
//  LocationServiceExampleViewController.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit
import CoreLocation

class LocationServiceExampleViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the location service first
        let locationResponse = LocationService.shared.isLocationEnabled(withAuthorizationWhenInUse: false)
        
        if let errorMsg = locationResponse.1 {
            print(errorMsg)
        }
        else {
            LocationService.shared.startUpdatingLocation()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //add listener of the reachability status change
        LocationService.shared.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //remove listener of the reachability status change
        LocationService.shared.removeListener(listener: self)
    }
    
}

// MARK: - Button Click Events
extension LocationServiceExampleViewController {
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension LocationServiceExampleViewController: LocationListener {
    
    func locationDidChange(location: CLLocation) {
        locationLabel.text = "Latitude: \(location.coordinate.latitude) \n Longitude: \(location.coordinate.longitude)"
    }
    
}
