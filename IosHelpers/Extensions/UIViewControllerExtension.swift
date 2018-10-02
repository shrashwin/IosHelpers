//
//  UIViewControllerExtension.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Get the storyboard identifier of the view controller
    class var storyboardID: String {
        return "\(self)"
    }
    
    /// get the instance of a viewcontroller
    ///
    /// - Parameter appStoryBoard: storyboard where the viewcontroller is added
    /// - Returns: instance of the viewcontroller
    static func instantiateFrom(appStoryBoard: StoryboardType) -> Self {
        return appStoryBoard.viewController(viewControllerClass: self)
    }
    
}
