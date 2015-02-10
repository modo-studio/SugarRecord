//
//  RealmTableViewController.swift
//  SugarRecordExample
//
//  Created by Pedro Piñera Buendía on 25/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import Foundation
import Realm

class RealmTableViewController: StackTableViewController
{
    //MARK: - Attributes
    
    var data: SugarRecordResults?

    
    //MARK: - Viewcontroller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Realm"
        self.stack = DefaultREALMStack(stackName: "Realm", stackDescription: "")
        SugarRecord.addStack(self.stack!)
    }
    
    
    //MARK: - Actions
    
    @IBAction override func add(sender: AnyObject?) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d yyyy - HH:mm:ss"
        let model = RealmModel.create() as! RealmModel
        model.name = formatter.stringFromDate(NSDate())
        model.save()
        self.fetchData()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
    }
    
    
    //MARK: - Data Source
    
    override func fetchData() {
        self.data = RealmModel.all().sorted(by: "date", ascending: false).find()
    }
    
    override func dataCount() -> Int {
        if (data == nil) { return 0 }
        else { return data!.count }
    }
    
    
    //MARK: - Cell
    
    override func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d yyyy - HH:mm:ss"
        let model = self.data![indexPath.row] as! RealmModel
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = formatter.stringFromDate(model.date)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let model = self.data![indexPath.row] as! RealmModel
            model.beginWriting().delete().endWriting()
            self.fetchData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func cellIdentifier() -> String {
        return "ModelCell"
    }
}