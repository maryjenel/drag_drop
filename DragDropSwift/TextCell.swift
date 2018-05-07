//
//  TextCell.swift
//  RegCollectionViewDrag
//
//  Created by Jenel Myers on 5/2/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import UIKit

class TextCell: UICollectionViewCell {
  var titleLabel: UILabel = {
    return UILabel.init(frame: CGRect.zero)
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.lightGray
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.numberOfLines = 0
    self.addSubview(titleLabel)
    
    let views: [String: Any] = [
        "titleLabel" : titleLabel,
    ]
    let hConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|", options:[], metrics: nil, views: views)
    let vConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-|", options:[], metrics: nil, views: views)
    NSLayoutConstraint.activate(hConstraint)
    NSLayoutConstraint.activate(vConstraint)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureForText(_ text: String) {
    self.titleLabel.text = text
  }
  
}
