//
//  RestKitTableViewController.swift
//  SugarRecordExample
//
//  Created by Robert Dougan on 11/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import UIKit

class RestKitTableViewController: StackTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "RestKit"
        
        self.stack = DefaultCDStack(databaseName: "RestKit.sqlite", model: self.model, automigrating: true)
        SugarRecord.addStack(self.stack!)
        
        self.entityClass = RestKitModel.self
    }
    
    // MARK: - StackTableViewController
    
    @IBAction override func add(sender: AnyObject?) {
        let names = ["Sweet", "Chocolate", "Cookie", "Fudge", "Caramel"]
        let randomIndex = Int(arc4random_uniform(UInt32(names.count)))
        
        let model = self.entityClass.create() as RestKitModel
        model.date = NSDate()
        model.name = names[randomIndex]
        model.save()
        
        self.fetchData()
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
    }
    
    override func fetchData() {
        self.data = self.entityClass.all().sorted(by: "date", ascending: false).find()! as? [NSManagedObject]
    }
    
    override func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d yyyy - HH:mm:ss"
        
        let model = self.data![indexPath.row] as RestKitModel
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = formatter.stringFromDate(model.date)
    }
    
    override func cellIdentifier() -> String {
        return "RestKitModelCell"
    }
    
}
