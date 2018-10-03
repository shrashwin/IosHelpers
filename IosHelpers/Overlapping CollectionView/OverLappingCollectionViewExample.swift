//
//  OverLappingCollectionViewExample.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/3/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit

class OverLappingCollectionViewExample: UIViewController {

    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var verticalCollectionView: UICollectionView!
    
    var color = [UIColor.red, UIColor.green]
    var horizontalLayout: OverlapFlowLayout?
    var verticalLayout: OverlapFlowLayout?
    var count = 10
    var cellheight:CGFloat = 170.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: ExampleCollectionViewCell.cellIdentifier, bundle: nil)
        horizontalCollectionView.register(cellNib, forCellWithReuseIdentifier: ExampleCollectionViewCell.cellIdentifier)
        verticalCollectionView.register(cellNib, forCellWithReuseIdentifier: ExampleCollectionViewCell.cellIdentifier)
        
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        verticalCollectionView.dataSource = self
        verticalCollectionView.delegate = self
        
        initializeFlowLayout()
        
    }
    
    func initializeFlowLayout() {
        
        //for horizontal flow
        horizontalLayout = OverlapFlowLayout()
        horizontalLayout?.newOverLapOld = false
        horizontalLayout?.flowDirection = .horizontal  // horizontal or vertical
        horizontalLayout?.centerDiff = cellheight/2.0  //difference from the previous cell
        horizontalLayout?.preferredSize = CGSize(width: cellheight, height: cellheight)
        horizontalCollectionView.setCollectionViewLayout(horizontalLayout!, animated: false)
        
        //for vertical flow
        verticalLayout = OverlapFlowLayout()
        verticalLayout?.newOverLapOld = false
        verticalLayout?.flowDirection = .vertical  // horizontal or vertical
        verticalLayout?.centerDiff = 10.0  //difference from the previous cell
        verticalLayout?.preferredSize = CGSize(width: verticalCollectionView.frame.size.width, height: cellheight)
        verticalCollectionView.setCollectionViewLayout(verticalLayout!, animated: false)
        
        
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension OverLappingCollectionViewExample : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExampleCollectionViewCell.cellIdentifier , for: indexPath) as! ExampleCollectionViewCell
        cell.contentWrapper.backgroundColor = color[indexPath.item%2]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        // return the width and height of the cell
        
        if collectionView == horizontalCollectionView {
            return CGSize(width: cellheight, height: cellheight)
        }
        return CGSize(width: collectionView.frame.size.width, height: cellheight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
   
}

