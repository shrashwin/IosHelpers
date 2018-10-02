//
//  KeyBoardAvoidingExampleViewController.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit

class KeyBoardAvoidingExampleViewController: KeyboardAvoidingViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fieldOne: UITextField!
    @IBOutlet weak var fieldTwo: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // assign the scrollview to kaScrollView of KeyboardAvoidingViewController
        kaScrollView = scrollView
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnClick(_ sender: UIButton) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
}
