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

    static let items = [Reachability, KeyboardAvoidingViewController]
    
    var descriptionTxt: String {
        switch self {
        
        case .Reachability: return "Reachability"
        case .KeyboardAvoidingViewController: return "KeyboardAvoiding View Controller"
        
        }
    }

}
