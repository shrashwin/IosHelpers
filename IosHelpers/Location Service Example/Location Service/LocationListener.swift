//
//  LocationListener.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/3/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import Foundation
import CoreLocation

/// Protocol for listenig network status change
public protocol LocationListener : class {
    func locationDidChange(location: CLLocation)
}
