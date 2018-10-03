//
//  HelperItems.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import Foundation


enum HelperItems {
    
    case Reachability
    case KeyboardAvoidingViewController
    case LocationService

    static let items = [Reachability, KeyboardAvoidingViewController, LocationService]
    
    var descriptionTxt: String {
        switch self {
        
        case .Reachability: return "Reachability"
        case .KeyboardAvoidingViewController: return "KeyboardAvoiding View Controller"
        case .LocationService: return "Location Service"
        
        }
    }

}
