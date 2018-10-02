//
//  BaseViewController.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/2/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit

/// In this controller we list the items we are going to make helper classes of.
// On item click, navigation to the helper is done.

class BaseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: HelperItemsTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: HelperItemsTableViewCell.cellIdentifier)
    }
    
   

}

extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HelperItemsTableViewCell.cellIdentifier) as? HelperItemsTableViewCell
        cell?.helperItemLabel.text = HelperItems.items[indexPath.row].descriptionTxt
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return HelperItems.items.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch HelperItems.items[indexPath.row] {
        
            case .Reachability:
                let reachabilityVC =  ReachabilityViewController.instantiateFrom(appStoryBoard: .Reachability)
                navigationController?.pushViewController(reachabilityVC, animated: true)
            
        case .KeyboardAvoidingViewController:
            let keyboardAvoidingVC = KeyBoardAvoidingExampleViewController.instantiateFrom(appStoryBoard: .KeyboardAvoiding)
            navigationController?.pushViewController(keyboardAvoidingVC, animated: true)
       
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
