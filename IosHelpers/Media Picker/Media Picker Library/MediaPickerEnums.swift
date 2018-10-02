//
//  MediaPickerEnums.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import Foundation

enum PickerMode {
    case all,camera, library
}

enum PickerType {
    case video, photo
}

struct MediaPickerConstants {
    
    static let mediaPickerNibName = "MediaPickerHelperViewController"
    
    static let cameraUsageDescription = "NSCameraUsageDescription"
    static let photoLibraryUsageDescription = "NSPhotoLibraryUsageDescription"
    
    static let photoLibraryUsageErrorDescription = "Please add photo library usage description in the info plist file"
    
    static let cameraUsageErrorDescription = "Please add camera usage description in the info plist file"
    
    static let defaultErrorMsg = "Soemthing went wrong."
    static let cameraPermissionErrorMsg = "App needs camera permission to capture picture"
}

