//
//  MediaPickerViewController.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit

class MediaPickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
}

// MARK: - Button Click Events
extension MediaPickerViewController {
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickMediaBtnClick(_ sender: UIButton) {
        
    }
    
}
