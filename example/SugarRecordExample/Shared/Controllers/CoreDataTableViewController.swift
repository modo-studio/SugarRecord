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

    //MARK: - Attributes
    
    var data: SugarRecordResults?
    internal let model: NSManagedObjectModel = {
        let modelPath: NSString = NSBundle.mainBundle().pathForResource("Models", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath as! String)!)!
        return model
        }()
    
    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Core Data"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier())
        self.stack = DefaultCDStack(databaseName: "CoreData.sqlite", model: self.model, automigrating: true)
        (self.stack as! DefaultCDStack).autoSaving = true
        SugarRecord.addStack(self.stack!)
    }
    
    
    //MARK: - Actions
    
    @IBAction override func add(sender: AnyObject?) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d yyyy - HH:mm:ss"
        let model = CoreDataModel.create() as! CoreDataModel
        model.text = formatter.stringFromDate(NSDate())
        model.save()
        self.fetchData()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
    }
    
    
    //MARK: - Data Source
    
    override func fetchData() {
        self.data = CoreDataModel.all().sorted(by: "text", ascending: false).find()
    }
    
    override func dataCount() -> Int {
        if (data == nil) { return 0 }
        else { return data!.count }
    }
    
    
    //MARK: - Cell
    
    override func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let model = self.data![indexPath.row] as! CoreDataModel
        cell.textLabel?.text = model.text
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let model = self.data![indexPath.row] as! CoreDataModel
            model.beginWriting().delete().endWriting()
            self.fetchData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}
