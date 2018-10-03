//
//  OverlapFlowLayout.swift
//  Crunch Time
//
//  Created by Insight Workshop on 1/12/18.
//  Copyright © 2018 Ashwin Shrestha. All rights reserved.
//

import UIKit
enum FlowDirection {
    case horizontal
    case vertical
}

class OverlapFlowLayout: UICollectionViewLayout {

    var preferredSize = CGSize(width: 70.0, height: 170.0)
    var centerDiff: CGFloat = 40
    var flowDirection: FlowDirection  = .vertical
    var newOverLapOld = false // new item operlaps old
    var widthDifference: CGFloat = 20.0 // for vertical flow
    
    private var numberOfItems = 0
    
    // for vertical flow max number of item to show in stack
    var maxStackItemToShow = 3
    
    private var updateItems = [UICollectionViewUpdateItem]()
    
    override func prepare() {
        super.prepare()
        numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        self.updateItems = updateItems
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        
        if let collectionView = collectionView {
            switch flowDirection {
                
            case .horizontal:
                
                let width = max(collectionView.bounds.width + 1, preferredSize.width + CGFloat((numberOfItems - 1)) * centerDiff)
                let height = collectionView.bounds.height - 1
                
                return CGSize(width: width, height: height)
                
            case .vertical:
                let height = max(collectionView.bounds.height + 1, preferredSize.height + CGFloat(numberOfItems > (maxStackItemToShow - 1) ? (maxStackItemToShow - 1) : numberOfItems) * centerDiff)
                let width = collectionView.bounds.width - 1
                
                return CGSize(width: width, height: height)
            }
        }
        return CGSize.zero
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for index in 0 ..< numberOfItems {
            let indexPath = IndexPath(item: index, section: 0)
            allAttributes.append(layoutAttributesForItem(at: indexPath)!)
        }
        return allAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        var width = preferredSize.width
        var centerX:CGFloat = 0
        var centerY:CGFloat = 0
        
        switch flowDirection {
            
        case .horizontal:
            
            attributes.size = preferredSize
            centerX = preferredSize.width / 2.0 + CGFloat(indexPath.item) * centerDiff
            centerY = preferredSize.height / 2.0
            
            
        case .vertical:
            width = preferredSize.width - CGFloat(indexPath.item) * widthDifference
            attributes.size = CGSize(width: width, height: preferredSize.height)
            
            centerX = collectionView!.bounds.width / 2.0
            centerY = preferredSize.height / 2.0 + CGFloat(indexPath.item > (maxStackItemToShow - 1) ? (maxStackItemToShow - 1) : indexPath.item ) * centerDiff
        }
        
        attributes.center = CGPoint(x: centerX, y: centerY)
        attributes.zIndex = self.numberOfItems - (newOverLapOld ? -1 : 1) * indexPath.item
        
        return attributes
        
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = layoutAttributesForItem(at: itemIndexPath)
        
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .insert:
                if updateItem.indexPathAfterUpdate == itemIndexPath {
                    let translation = collectionView!.bounds.height
                    attributes?.transform = CGAffineTransform(translationX: 0, y: translation)
                    break
                }
            default:
                break
            }
        }
        
        return attributes
    }
    
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .delete:
                if updateItem.indexPathBeforeUpdate == itemIndexPath {
                    let attributes = layoutAttributesForItem(at: itemIndexPath)
                    let translation = -collectionView!.bounds.width
                    attributes?.transform = CGAffineTransform(translationX: translation, y: 0)
                    return attributes
                }
            case .move:
                if updateItem.indexPathBeforeUpdate == itemIndexPath {
                    return layoutAttributesForItem(at: updateItem.indexPathAfterUpdate!)
                }
            default:
                break
            }
        }
        let finalIndex = finalIndexForIndexPath(indexPath: itemIndexPath)
        let shiftedIndexPath = IndexPath(item: finalIndex, section: itemIndexPath.section)
        
        return layoutAttributesForItem(at: shiftedIndexPath)
        
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        updateItems.removeAll(keepingCapacity: true)
    }
    
    private func finalIndexForIndexPath(indexPath: IndexPath) -> Int {
        var newIndex = indexPath.item
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .insert:
                if updateItem.indexPathAfterUpdate!.item <= newIndex {
                    newIndex += 1
                }
            case .delete:
                if updateItem.indexPathBeforeUpdate!.item < newIndex {
                    newIndex -= 1
                }
            case .move:
                if updateItem.indexPathBeforeUpdate!.item < newIndex {
                    newIndex -= 1
                }
                if updateItem.indexPathAfterUpdate!.item <= newIndex {
                    newIndex += 1
                }
            default:
                break
            }
        }
        return newIndex
    }
    
    
}
