//
//  StacksTableViewController.swift
//  SugarRecordExample
//
//  Created by Robert Dougan on 10/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import UIKit

class StacksTableViewController: UITableViewController {
    
    var stacks: [String] = [
        "CoreData",
        "RestKit",
        "Realm",
        "iCloud"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stacks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StackCell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = self.stacks[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var viewController: UITableViewController?
        let stack = self.stacks[indexPath.row]
        
        switch (stack) {
        case "CoreData":
            viewController = CoreDataTableViewController()
            
        case "RestKit":
            viewController = RestKitTableViewController()
            
        case "Realm":
            viewController = RealmTableViewController()
            
        case "iCloud":
            viewController = iCloudTableViewController()
            
        default:
            println("View Controller not found for stack: \(stack)")
        }
        
        if (viewController != nil) {
            self.navigationController!.pushViewController(viewController!, animated: true)
        }
    }

}
