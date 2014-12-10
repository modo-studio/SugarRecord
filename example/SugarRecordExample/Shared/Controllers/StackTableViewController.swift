//
//  StackTableViewController.swift
//  SugarRecordExample
//
//  Created by Robert Dougan on 10/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import UIKit
import CoreData

class StackTableViewController: UITableViewController {
    
    var stack: SugarRecordStackProtocol?
    var data: [NSManagedObject]?
    
    let model: NSManagedObjectModel = {
        let modelPath: NSString = NSBundle.mainBundle().pathForResource("Models", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath)!)!
        return model
    }()
    
    var entityClass: NSManagedObject.Type = NSManagedObject.self
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ModelCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add:")
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData()
        self.tableView.reloadData()
    }
    
    // MARK: - StackTableViewController
    
    @IBAction func add(sender: AnyObject?) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d yyyy - HH:mm:ss"
        
        let model = self.entityClass.create() as CoreDataModel
        model.text = formatter.stringFromDate(NSDate())
        model.save()
        
        self.fetchData()
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
    }
    
    func fetchData() {
        self.data = self.entityClass.all().sorted(by: "text", ascending: false).find()! as? [NSManagedObject]
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.data == nil) ? 0 : self.data!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ModelCell", forIndexPath: indexPath) as UITableViewCell

        let model = self.data![indexPath.row] as CoreDataModel
        cell.textLabel?.text = model.text

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let model = self.data![indexPath.row] as CoreDataModel
            model.beginWriting().delete().endWriting()
            
            self.fetchData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
}
