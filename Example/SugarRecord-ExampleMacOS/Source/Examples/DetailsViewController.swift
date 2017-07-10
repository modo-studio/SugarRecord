//
//  DetailsViewController.swift
//  SugarRecord_Example
//
//  Created by Jorge Martín Espinosa on 10/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Cocoa

class DetailsViewController: NSViewController {
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var datePicker: NSDatePicker!
    
    var selectedItem: BasicObject? {
        didSet {
            if self.selectedItem != nil {
                nameTextField.stringValue = self.selectedItem!.name!
                nameTextField.isEnabled = true
                
                datePicker.dateValue = self.selectedItem!.date!
                datePicker.isEnabled = true
            } else {
                nameTextField.stringValue = ""
                nameTextField.isEnabled = false
                
                datePicker.isEnabled = false
            }
        }
    }
    
    @IBAction func nameChanged(sender: Any?) {
        try! db.operation({ (context, save) in
            if let item = try! context.request(BasicObject.self)
                .filtered(with: "name", equalTo: self.selectedItem!.name ?? "").fetch().first {
                item.name = self.nameTextField!.stringValue
                save()
            }
        })
    }
    
    @IBAction func dateChanged(sender: Any?) {
        try! db.operation({ (context, save) in
            if let item = try! context.request(BasicObject.self)
                .filtered(with: "name", equalTo: self.selectedItem!.name ?? "").fetch().first {
                item.date = self.datePicker!.dateValue
                save()
            }
        })
    }
}
