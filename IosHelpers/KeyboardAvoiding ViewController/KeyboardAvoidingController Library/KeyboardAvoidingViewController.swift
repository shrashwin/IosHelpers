//
//  KeyboardAvoidingViewController.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit

class KeyboardAvoidingViewController: UIViewController {

    @IBOutlet var accessoryBar: AccessoryBar!
    
    weak var kaScrollView: UIScrollView?
    var formFields: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Bundle.main.loadNibNamed("AccessoryBar", owner: self, options: nil)
        accessoryBar.barDelegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardNotifications()
        
        if formFields.count <= 0 {
            getFormFields(formView: kaScrollView!)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }

}

extension KeyboardAvoidingViewController: AccessoryDelegate {
    
    func previousButtonTapped(Sender: UIButton) {
        
        let firstResponder = self.findFirstResponder()
        if let prevResponder = getPreviousResponderForView(view: firstResponder!) {
            prevResponder.becomeFirstResponder()
        }
        
    }
    
    func nextButtonTapped(Sender: UIButton) {
    
        let firstResponder = self.findFirstResponder()
        if let nextResponder = getNextResponderForView(view: firstResponder!) {
            nextResponder.becomeFirstResponder()
        }
    }
    
    func doneButtonTapped(Sender: UIButton) {
        
        let firstResponder = self.findFirstResponder()
        firstResponder?.resignFirstResponder()
    
    }
  
}

extension KeyboardAvoidingViewController {
    
    // MARK: - Keyboard Notifications
    
    func addKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func removeKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let firstResponder = findFirstResponder() 
        guard firstResponder != nil else { return }
        let firstResponderPosition = firstResponder?.convert((firstResponder?.bounds)!, to: self.view)
        
        let gapScroll: CGFloat = 25.0;
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve((UIViewAnimationCurve)(rawValue: ((notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as AnyObject).integerValue)!)!)
        UIView.setAnimationDuration(((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue)!)
        
        let minY = firstResponderPosition!.minY
        let maxY = firstResponderPosition!.maxY
        
        let difference = (((maxY-minY) > 100) ? minY+100 : maxY) - (keyboardFrame?.origin.y)!
        
        if difference > 0 {
            var contentOffset = kaScrollView!.contentOffset
            contentOffset.y += difference + gapScroll
            kaScrollView!.contentOffset = contentOffset
        }
        
        var contentInset = kaScrollView!.contentInset
        //contentInset.bottom = (keyboardFrame?.size.height)!
        contentInset.bottom =  ((kaScrollView?.frame.origin.y)! + (kaScrollView?.frame.size.height)!) - (keyboardFrame?.origin.y)!
        kaScrollView!.contentInset = contentInset
        
        UIView.commitAnimations()
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        //let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve((UIViewAnimationCurve)(rawValue: ((notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as AnyObject).integerValue)!)!)
        UIView.setAnimationDuration(((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue)!)
        
        var contentInset = kaScrollView!.contentInset
        contentInset.bottom = 0
        kaScrollView!.contentInset = contentInset
        
        UIView.commitAnimations()
        
    }
    
    func findFirstResponderInView(formView: UIView) -> UIView? {
        
        for view in formView.subviews {
            
            if (view is UITextField || view is UITextView) && view.isFirstResponder {
                
                return view
                
            }
            
            let inrView = findFirstResponderInView(formView: view)
            
            if inrView != nil {
                
                return inrView
                
            }
            
        }
        
        return nil
    }
    
    func getFormFields(formView: UIView) {
        
        for view in formView.subviews {
            
            if (view is UITextField || view is UITextView) && view.isUserInteractionEnabled {
                formFields.add(view)
            }
            
            getFormFields(formView: view)
            
        }
        
    }
    
    func updateFormFields() {
        
        formFields.removeAllObjects()
        getFormFields(formView: kaScrollView!)
        
    }
    
    func findFirstResponder() -> UIView? {
        
        for view in formFields {
            if (view is UITextField || view is UITextView ) && (view as AnyObject).isFirstResponder {
                return view as? UIView
            }
        }
        
        return nil
    }
    
    
    func getNextResponderForView(view: UIView) -> UIView? {
        
        let frIndex = formFields.index(of: view)
        
        if (frIndex+1) < formFields.count {
            return formFields.object(at: frIndex+1) as? UIView
        }
        
        return nil
    }
    
    func getPreviousResponderForView(view: UIView) -> UIView? {
        
        let frIndex = formFields.index(of: view)
        
        if (frIndex-1) >= 0 {
            return formFields.object(at: frIndex-1) as? UIView
        }
        
        return nil
    }
    
}

extension KeyboardAvoidingViewController: UITextFieldDelegate {
    
    //MARK: - Textfield Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1000 {
            textField.inputAccessoryView = nil
            textField.reloadInputViews()
        }
        else {
            accessoryBar.previousBtn.isEnabled = (self.getPreviousResponderForView(view: textField) != nil) ? true : false
            accessoryBar.nextBtn.isEnabled = (self.getNextResponderForView(view: textField) != nil) ? true : false
            textField.inputAccessoryView = accessoryBar
            textField.reloadInputViews()
        }
        
        
        return true
    }
    
}

extension KeyboardAvoidingViewController: UITextViewDelegate {
    
    //MARK: - TextView Delegate Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.tag == 1000 {
            
            textView.inputAccessoryView = nil
            textView.reloadInputViews()
            
        }
        else {
            
            accessoryBar.previousBtn.isEnabled = (self.getPreviousResponderForView(view: textView) != nil) ? true : false
            accessoryBar.nextBtn.isEnabled = (self.getNextResponderForView(view: textView) != nil) ? true : false
            textView.inputAccessoryView = accessoryBar
            textView.reloadInputViews()
            
        }
        
        
        return true
    }
    
}
