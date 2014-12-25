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

    //MARK: - Attributes
    var stack: SugarRecordStackProtocol?
    
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add:")
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(animated: Bool) {
        //SugarRecord.removeAllStacks()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
        self.tableView.reloadData()
    }
    
    
    // MARK: - Actions
    
    @IBAction func add(sender: AnyObject?) {
        println("Abstract method, should be overriden")
    }
    
    func fetchData() {
        println("Abstract method, should be overriden")
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        println("Abstract method, should be overriden")
    }
    
    func cellIdentifier() -> String {
        return "ModelCell"
    }
    
    
    
    // MARK: - Data Source
    
    func dataCount() -> Int
    {
        println("Abstract method, should be overriden")
        return 0
    }
    

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier(), forIndexPath: indexPath) as UITableViewCell
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
