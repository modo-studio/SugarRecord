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
        
    }
    
    func fetchData() {
        
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
    }
    
    func cellIdentifier() -> String {
        return "ModelCell"
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.data == nil) ? 0 : self.data!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier(), forIndexPath: indexPath) as UITableViewCell

        self.configureCell(cell, indexPath: indexPath)

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
