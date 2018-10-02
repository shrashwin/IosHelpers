//
//  MediaPickerHelperViewController.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import TOCropViewController

class MediaPickerHelperViewController: UIViewController {
    
    var delegate: MediaPickerProtocol?
    var pickerMode: PickerMode  = .all
    var pickerType : PickerType = .photo
    
    var hasCameraAccess = false
    var hasLibraryAccess = false
    
    var imagePicker = UIImagePickerController()
    
    var imageCropper: TOCropViewController?
    
    var aspectRatioPreset: TOCropViewControllerAspectRatioPreset = .preset4x3
    var aspectRatioLockEnabled: Bool = true
    var resetAspectRatioEnabled: Bool = true
    var rotateButtonsHidden: Bool = true
    var croppingStyle: TOCropViewCroppingStyle = .default
    
    
    var croppingEnabled = false
    
    // for videos
    var hasVideoSizeLimit = false
    var videoSizeLimit:Double = 0.5 // mb
    var hasVideoDurationLimit = false
    var videoDurationLimit = 10 // in seconds
    
    /// get the instance of a media picker controller and the enclosing navigation controller
    ///
    /// - Returns: tuple of media picker instance and uinavigation controller
    class func MediaPicker()-> (UINavigationController,MediaPickerHelperViewController) {
        
        let mediaPicker = MediaPickerHelperViewController(nibName: MediaPickerConstants.mediaPickerNibName, bundle: nil)
        let nav = UINavigationController(rootViewController: mediaPicker)
        nav.setNavigationBarHidden(true, animated: false)
        return (nav,mediaPicker)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let permissionResponse = checkIfPermisionInPlist()
        if !permissionResponse.0 {
            showAlertWithOkHandler(message: permissionResponse.1 ?? MediaPickerConstants.defaultErrorMsg, okHandler: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            
            getCameraLibraryAccess()
            
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            if pickerMode == .all {
                if hasCameraAccess && hasLibraryAccess {
                    showActionSheet()
                }
                else{
                    showFromModeAvailable()
                }
            }
            else{
                showFromSelectMode()
            }
        }
    }
    
    func getCameraLibraryAccess() {
        
        hasCameraAccess = UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        hasLibraryAccess = UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        
    }
    
    
    
    /// Checks if the project's info plist have the necessary camera and photo library usage description
    ///
    /// - Returns: permission flag and error message
    func checkIfPermisionInPlist() -> (Bool,String?) {
        
        var dictRoot: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info" , ofType: "plist") {
            dictRoot = NSDictionary(contentsOfFile: path)
        }
        
        switch pickerMode {
        
        case .all:
            
            if let _ = dictRoot?[MediaPickerConstants.photoLibraryUsageDescription] as? String {
                if let _ = dictRoot?[MediaPickerConstants.cameraUsageDescription] as? String {
                    return (true,nil)
                }
                return (false, MediaPickerConstants.cameraUsageErrorDescription)
            }
            return (false, MediaPickerConstants.photoLibraryUsageErrorDescription)
            
        case .camera:
            
            if let _ = dictRoot?[MediaPickerConstants.cameraUsageErrorDescription] as? String {
                return (true,nil)
            }
            return (false, MediaPickerConstants.cameraUsageErrorDescription)
            
        case .library:
            
            if let _ = dictRoot?[MediaPickerConstants.photoLibraryUsageDescription] as? String  {
                return (true,nil)
            }
            
            return (false, MediaPickerConstants.photoLibraryUsageErrorDescription)
        }
        
    }
    
}

// MARK: - UI based view manipulation
extension MediaPickerHelperViewController {
    
    /// show action sheet with camera and photo library option, to choose from
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: "Choose option", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {
            handler in
            
            self.mediaFromGallery()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            handler in
            
            self.mediaFromCamera()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            cancel in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showFromModeAvailable() {
        
        if hasCameraAccess {
            mediaFromCamera()
        }
        else if hasLibraryAccess {
            mediaFromGallery()
        }
        else{
            showAlertWithOkHandler(message: "No access type available to select \(pickerType == .video ? "video" : "photo")", okHandler: {
                
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func showFromSelectMode () {
        
        if pickerMode == .camera {
            if !hasCameraAccess {
                showAlertWithOkHandler(message: "No camera available.", okHandler: {
                    
                    self.dismiss(animated: true, completion: nil)
                })
                return
            }
            mediaFromCamera()
        }
        else {
            
            if !hasLibraryAccess {
                showAlertWithOkHandler(message: "No \(pickerType == .video ? "video": "photo") library available.", okHandler: {
                    
                    self.dismiss(animated: true, completion: nil)
                })
                return
            }
            mediaFromGallery()
        }
    }
    
    func mediaFromCamera(){
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized
        {
            
            imagePicker.sourceType = .camera
            if pickerType == .video {
                imagePicker.mediaTypes = [kUTTypeVideo as String, kUTTypeMovie as String]
            }
            present(imagePicker, animated: true, completion: nil)
            
        }
        else
        {
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    
                    self.imagePicker.sourceType = .camera
                    if self.pickerType == .video {
                        self.imagePicker.mediaTypes = [kUTTypeVideo as String, kUTTypeMovie as String]
                    }
                    self .present(self.imagePicker, animated: true, completion: nil)
                }
                else
                {
                    self.showAlertOnMainThread(message: MediaPickerConstants.cameraPermissionErrorMsg)
                    
                }
            });
        }
        
    }
    
    func mediaFromGallery(){
        
        imagePicker.sourceType = .savedPhotosAlbum
        
        if pickerType == .video {
            imagePicker.mediaTypes = [kUTTypeVideo as String, kUTTypeMovie as String]
        }
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
}


extension MediaPickerHelperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.dismissView()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if pickerType == .photo {
            
            if let  image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                if croppingEnabled {
                    
                    if let _ = imageCropper {}
                    else {
                        imageCropper = TOCropViewController(croppingStyle: croppingStyle, image: image)
                    }
                    imageCropper?.delegate = self
                    imageCropper?.aspectRatioLockEnabled = aspectRatioLockEnabled
                    imageCropper?.aspectRatioPreset = aspectRatioPreset
                    imageCropper?.resetAspectRatioEnabled = resetAspectRatioEnabled
                    imageCropper?.rotateButtonsHidden = rotateButtonsHidden
                    
                    dismiss(animated: true, completion: {
                        self.present(self.imageCropper!, animated: true, completion: nil)
                    })
                }
                else {
                    delegate?.didPick(image: image)
                    picker.dismiss(animated: true) {
                        self.dismissView()
                    }
                }
                
            }
        }
        else {
            picker.dismiss(animated: true) {
                if let url = info[UIImagePickerControllerMediaURL] as? URL {
                    self.validateVideo(withUrl: url)
                }
            }
            
        }
    }
    
}

// MARK: - Video Files validations
extension MediaPickerHelperViewController {
    
    /// validate the size and duration limit of the video selected
    ///
    /// - Parameter withUrl: url of selected video file
    func validateVideo(withUrl: URL) {
        
        let avAsset = AVURLAsset(url: withUrl)
        
        if hasVideoDurationLimit  && (avAsset.duration.seconds > Double(videoDurationLimit)){
            showAlertWithOkHandler(message: "The selected video's duration is greater than \(videoDurationLimit) seconds") {
                self.dismissView()
            }
            return
        }
        
        if hasVideoSizeLimit{
            let videoSize = avAsset.fileSize
            if videoSize > videoSizeLimit {
                showAlertWithOkHandler(message: "The selected video's size is greater than \(videoSizeLimit) mb") {
                     self.dismissView()
                }
                return
            }
        }
        delegate?.didPickVideo(withPath: withUrl)
        dismissView()
        
    }
    
    func dismissView() {
        dismiss(animated: false, completion: nil)
    }
}

extension MediaPickerHelperViewController: TOCropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropImageToRect cropRect: CGRect, angle: Int) {
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircleImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        dismiss(animated: true) {
            self.delegate?.didPick(image: image)
            self.dismissView()
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        dismiss(animated: true) {
            self.delegate?.didPick(image: image)
            self.dismissView()
        }
    }
    
}

extension AVURLAsset {
    var fileSize: Double {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        
        guard let sizeInByte = resourceValues?.fileSize ?? resourceValues?.totalFileSize else {
            return 0
        }
        return (Double(sizeInByte)/1024.0)/1024.0
    }
}
