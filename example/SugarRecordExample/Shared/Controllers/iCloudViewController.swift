//
//  iCloudViewController.swift
//  SugarRecordExample
//
//  Created by David Chavez on 2/19/15.
//  Copyright (c) 2015 David Chavez. All rights reserved.
//

import UIKit
import CoreData

class iCloudViewController: StackTableViewController {
    
    //MARK: - Attributes
    
    var data: SugarRecordResults?
    internal let model: NSManagedObjectModel = {
        let modelPath: NSString = NSBundle.mainBundle().pathForResource("Models", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath)!)!
        return model
        }()

    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iCloud"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier())
        
        let data = iCloudData(iCloudAppID: "com.sugarrecord.example.SugarRecordExample", iCloudDataDirectoryName: "data.nosync", iCloudLogsDirectory: "")
        self.stack = iCloudCDStack(databaseName: "iCloud.sqlite", model: self.model, icloudData: data)
        (self.stack as iCloudCDStack).autoSaving = true
        SugarRecord.addStack(self.stack!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "icloudInitialized", name: "iCloudStackInitialized", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        // Stop StackTableViewController's fetchData from happening
    }
    
    
    //MARK: - Actions
    
    @IBAction override func add(sender: AnyObject?) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM d yyyy - HH:mm:ss"
        let model = ICloudModel.create() as ICloudModel
        model.text = formatter.stringFromDate(NSDate())
        model.save()
        self.fetchData()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
    }
    
    //MARK: - Listeners
    
    func icloudInitialized() {
        dispatch_async(dispatch_get_main_queue(), {
            self.fetchData()
            self.tableView.reloadData()
        })
    }
    
    
    //MARK: - Data Source
    
    override func fetchData() {
        self.data = ICloudModel.all().sorted(by: "text", ascending: false).find()
    }
    
    override func dataCount() -> Int {
        if (data == nil) { return 0 }
        else { return data!.count }
    }
    
    
    //MARK: - Cell
    
    override func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let model = self.data![indexPath.row] as ICloudModel
        cell.textLabel?.text = model.text
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let model = self.data![indexPath.row] as ICloudModel
            model.beginWriting().delete().endWriting()
            self.fetchData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

}
