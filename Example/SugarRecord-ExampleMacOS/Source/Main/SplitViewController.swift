//
//  SplitViewController.swift
//  SugarRecord_Example
//
//  Created by Jorge Martín Espinosa on 10/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Cocoa

class SplitViewController: NSSplitViewController {
    
    var detailsViewController: DetailsViewController? {
        return splitViewItems[1].viewController as? DetailsViewController
    }
    
    func onSelectionChanged(item: BasicObject?) {
        detailsViewController?.selectedItem = item
    }
    
}
