//
//  CoreDataTableViewController.swift
//  SugarRecordExample
//
//  Created by Robert Dougan on 10/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTableViewController: StackTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Core Data"
        
        self.stack = DefaultCDStack(databaseName: "CoreData.sqlite", model: self.model, automigrating: true)
        SugarRecord.addStack(self.stack!)
        
        self.entityClass = CoreDataModel.self
    }
}
