//
//  SectionCell.swift
//  RegCollectionViewDrag
//
//  Created by Jenel Myers on 5/2/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import UIKit
protocol DragCellDelegate {
    func reorderItems(_ coordinator: UICollectionViewDropCoordinator, destinationIndexPath:IndexPath, collectionView: UICollectionView)
}
class SectionCell: UICollectionViewCell {
    var titleLabel: UILabel = {
        return UILabel.init(frame: CGRect.zero)
    }()
    var section: Section!
    var collectionView: UICollectionView!
    var delegate : DragCellDelegate?
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.frame.size.width , height:  100)
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        
        let views: [String: Any] = [
            "titleLabel" : titleLabel,
            "collectionView" : collectionView
        ]
        let hConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[titleLabel]-5-[collectionView]|", options:[], metrics: nil, views: views)
        let titleLabelhConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|", options:[], metrics: nil, views: views)
        let collectionViewhConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[collectionView]-|", options:[], metrics: nil, views: views)
        NSLayoutConstraint.activate(collectionViewhConstraint)
        NSLayoutConstraint.activate(titleLabelhConstraint)
        NSLayoutConstraint.activate(hConstraint)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.dropDelegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MARK: Helper
    func configureForSection(_ section: Section) {
        self.titleLabel.text = section.title
        self.section = section
        self.collectionView.reloadData()
    }
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
}

extension SectionCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.textItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCell
        let text = section.textItems[indexPath.row]
        cell.configureForText(text)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.section.textItems[sourceIndexPath.row]
        self.section.textItems.remove(at: sourceIndexPath.row)
        self.section.textItems.insert(item, at: destinationIndexPath.row)
    }
}

extension SectionCell : UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.section.textItems[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession != nil
        {
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
        else
        {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIP: IndexPath
        coordinator.items.forEach({ item in
            
        })
        if let indexPath = coordinator.destinationIndexPath {
            destinationIP = indexPath
        } else {
            // Get last index path of collection view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIP = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
            self.delegate?.reorderItems(coordinator, destinationIndexPath:destinationIP, collectionView: collectionView)
            break
            
        case .copy:
            break
            
        default:
            return
        }
    }
    


}
