//
//  ListViewController.swift
//  RegCollectionViewDrag
//
//  Created by Jenel Myers on 5/2/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import UIKit
@objc(ListView)

class ListViewController: UIViewController {
    var collectionView: UICollectionView!
    var sections: [Section]!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.frame.size.width - 50, height:  self.view.frame.size.height)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SectionCell.self, forCellWithReuseIdentifier: "SectionCell")
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        let backLog = Section.init("Backlog", textItems: ["allow users to upload files to a story from their device", "Explore using redux-pack to simplify API middleware", "Add ability to upload files as attachment", "Add ability to upload camera roll and camera photos as attachments", "show story history on story detail screen" ])
        let readyForDev  = Section.init("Ready For Dev", textItems: ["When a user has not created a project, Add story crashes the app", "Add relationships to story view", "Add ability to create tasks when creating a story", "Add ability to add labels when creating stories"])
        let readyForReview = Section.init("Ready For Review", textItems: ["Add Github/git metadata to the stories view"])
        let readyForDeploy = Section.init("Ready for Deploy", textItems: ["Add ability to add labels to stories"])
        self.sections = [backLog, readyForDev, readyForReview, readyForDeploy]
        self.collectionView.reloadData()
    
    }
   
}

extension ListViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionCell
        let section = self.sections[indexPath.row]
        cell.configureForSection(section)
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension ListViewController : UICollectionViewDragDelegate, UICollectionViewDropDelegate, DragCellDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.sections[indexPath.row]
        let itemProvider = NSItemProvider(object: item.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if session.localDragSession != nil
        {
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        }
        else
        {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        let destinationIP: IndexPath
        let destinationSection = self.sections[destinationIndexPath.row]
        coordinator.items.forEach({ item in
            if let model = item.dragItem.localObject as? String {
            destinationSection.textItems.append(model)
            
            }
        })

        
        switch coordinator.proposal.operation
        {
        case .move:
            let sectionCell = self.collectionView.cellForItem(at: destinationIndexPath)
            if let indexPath = coordinator.destinationIndexPath {
                destinationIP = indexPath
            } else {
                // Get last index path of collection view.
                let section = collectionView.numberOfSections - 1
                let row = collectionView.numberOfItems(inSection: section)
                destinationIP = IndexPath(row: row, section: section)
                sectionCell?.reloadInputViews()
            }
//            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIP, collectionView: collectionView)
            break
            
        case .copy:
            break
            
        default:
            return
        }
    }
    func reorderItems(_ coordinator: UICollectionViewDropCoordinator, destinationIndexPath:IndexPath, collectionView: UICollectionView) {
        let sectionCell = self.collectionView.cellForItem(at: destinationIndexPath)
        let destinationIP: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIP = indexPath
        } else {
            // Get last index path of collection view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIP = IndexPath(row: row, section: section)
            sectionCell?.reloadInputViews()
        }
        //            self.reorder
    }
//    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
//    {
//        let items = coordinator.items
//        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
//        {
//            var dIndexPath = destinationIndexPath
//            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
//            {
//                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
//            }
//            collectionView.performBatchUpdates({
////                if collectionView === self.collectionView2
////                {
//                    self.items.remove(at: sourceIndexPath.row)
//                    self.items2.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
//                }
////                else
////                {
////                    self.items1.remove(at: sourceIndexPath.row)
////                    self.items1.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
////                }
//                collectionView.deleteItems(at: [sourceIndexPath])
//                collectionView.insertItems(at: [dIndexPath])
//            })
//            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
//        }

    
}

