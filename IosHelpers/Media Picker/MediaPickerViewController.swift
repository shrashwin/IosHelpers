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
        
        let imagePicker = MediaPickerHelperViewController.MediaPicker() // returns uinavigation controller and media picker view controller
        
        imagePicker.1.delegate = self
        imagePicker.1.pickerMode = .all
        imagePicker.1.pickerType = .video
        
        // use if pickerType is photo
        imagePicker.1.croppingEnabled = true      // Croping when enabled, uses custom library downloaded to crop the image
        
        // use if cropping enabled
        imagePicker.1.croppingStyle = .circular
        imagePicker.1.aspectRatioPreset = .presetSquare
        imagePicker.1.aspectRatioLockEnabled = true
        imagePicker.1.resetAspectRatioEnabled = false
        imagePicker.1.rotateButtonsHidden = true
        imagePicker.0.presentAsModal()
        imagePicker.1.hasVideoSizeLimit = true
        imagePicker.1.videoSizeLimit = 0.5
        self.present(imagePicker.0, animated: false, completion: nil)
        
    }
    
}

// MARK: - Implemented optional Delegate methods for MediaPicker
extension MediaPickerViewController : MediaPickerProtocol {
    
    func didPick(image: UIImage) {
        
    }
    
    func didPickVideo(withPath: URL) {
        
    }
}
