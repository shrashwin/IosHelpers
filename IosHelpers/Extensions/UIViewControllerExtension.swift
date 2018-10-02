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
    
    func presentAsModal() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .custom
    }
    
    func showAlertWithOkHandler(message: String = "Something went wrong.\nPlease try again later.", okHandler: @escaping () -> ()) {
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: AppConstants.appName, message: message, preferredStyle: .alert)
            
            let okAction =  UIAlertAction(title: "OK", style: .default){
                handler in
                okHandler()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func showAlertOnMainThread(message: String = "Something went wrong.\nPlease try again later.") {
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: AppConstants.appName, message: message, preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}
