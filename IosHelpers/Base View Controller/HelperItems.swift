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
    case MediaPicker

    static let items = [Reachability, MediaPicker]
    
    var descriptionTxt: String {
        switch self {
        
        case .Reachability: return "Reachability"
        case .MediaPicker: return "Media Picker"
        
        }
    }

}
