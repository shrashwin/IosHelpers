//
//  AccessoryBar.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit

protocol AccessoryDelegate: class {
    func previousButtonTapped (Sender: UIButton)
    func nextButtonTapped (Sender: UIButton)
    func doneButtonTapped (Sender: UIButton)
}

class AccessoryBar: UIView {

    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    weak var barDelegate: AccessoryDelegate?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func previousButtonTapped(sender: UIButton) {
        
        barDelegate?.previousButtonTapped(Sender: sender)
        
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        barDelegate?.nextButtonTapped(Sender: sender)
        
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        
     barDelegate?.doneButtonTapped(Sender: sender)
        
    }
    
}
