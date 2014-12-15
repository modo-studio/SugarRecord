//
//  CoreDataTableViewController.swift
//  SugarRecordExample
//
//  Created by Robert Dougan on 10/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import UIKit

class CoreDataTableViewController: StackTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Core Data"
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier())
        
        self.stack = DefaultCDStack(databaseName: "CoreData.sqlite", model: self.model, automigrating: true)
        SugarRecord.addStack(self.stack!)
        
        self.entityClass = CoreDataModel.self
    }
    
    // MARK: - StackTableViewController
    
    @IBAction override func add(sender: AnyObject?) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d yyyy - HH:mm:ss"
        
        let model = self.entityClass.create() as CoreDataModel
        model.text = formatter.stringFromDate(NSDate())
        model.save()
        
        self.fetchData()
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
    }
    
    override func fetchData() {
        self.data = self.entityClass.all().sorted(by: "text", ascending: false).find()! as? [NSManagedObject]
    }
    
    override func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let model = self.data![indexPath.row] as CoreDataModel
        cell.textLabel?.text = model.text
    }
}
