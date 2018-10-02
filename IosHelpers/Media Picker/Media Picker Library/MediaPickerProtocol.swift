//
//  MediaPickerProtocol.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit

protocol ImagePickerProtocol : class {
    func didPick(image: UIImage)
    func didPickVideo(withPath : URL)
}

extension ImagePickerProtocol {
    func didPick(image: UIImage) {}
    func didPickVideo(withPath : URL) {}
}
