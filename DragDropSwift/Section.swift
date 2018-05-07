//
//  Section.swift
//  RegCollectionViewDrag
//
//  Created by Jenel Myers on 5/2/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

import UIKit

class Section: NSObject {
  var title: String
  var textItems: [String]
  
  init(_ title: String, textItems: [String]) {
    self.title = title
    self.textItems = textItems
  }
}
