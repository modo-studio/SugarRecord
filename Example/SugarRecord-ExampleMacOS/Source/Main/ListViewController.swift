//
//  ViewController.swift
//  SugarRecord-ExampleMacOS
//
//  Created by Jorge Martín Espinosa on 10/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Cocoa
import SugarRecord
import CoreData

class ListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    // MARK: - Attributes
    
    lazy var entitiesObservable: RequestObservable<BasicObject> = {
        let request = FetchRequest<BasicObject>().sorted(with: "date", ascending: false)
        return db.observable(request: request)
    }()
    
    var entities: [BasicObject] = [] {
        didSet {
            updateData()
        }
    }
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        entitiesObservable.observe { changes in
            switch(changes) {
                case .initial(let objects):
                    self.entities = objects
                case .update(let deletions, let insertions, let modifications):
                    deletions.forEach {
                        self.entities.remove(at: $0)
                    }
                    
                    insertions.forEach { (position, item) in
                        self.entities.insert(item, at: position)
                    }
                    
                    print("\(deletions.count) deleted | \(insertions.count) inserted | \(modifications.count) modified")
                case .error(let error):
                    print("Something went wrong: \(error)")
            }
            self.updateData()
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.make(withIdentifier: "simple_cell", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = entities[row].name ?? ""
            return cell
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 && tableView.selectedRow < entities.count {
            let selectedItemValues = entities[tableView.selectedRow]
            let fetchRequest = FetchRequest<BasicObject>().filtered(with: "name", equalTo: selectedItemValues.name ?? "")
            if let item = try? db.fetch(fetchRequest) {
                (parent as? SplitViewController)?.onSelectionChanged(item: item.first)
            }
            deleteButton.isEnabled = true
        } else {
            (parent as? SplitViewController)?.onSelectionChanged(item: nil)
            deleteButton.isEnabled = false
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return entities.count
    }
    
    @IBAction func addEntity(sender: Any?) {
        try! db.operation { (context, save) -> Void in
            let _object: BasicObject = try! context.new()
            _object.date = Date()
            _object.name = randomStringWithLength(10) as String
            try! context.insert(_object)
            save()
        }
    }
    
    @IBAction func deleteEntity(sender: Any?) {
        let _object = self.entities[tableView.selectedRow]
        try! db.operation { (context, save) -> Void in
            if let object = try! context.request(BasicObject.self).filtered(with: "name", equalTo: _object.name ?? "").fetch().first {
                try! context.remove(object)
                save()
            }
        }
    }
    
    func updateData() {
        self.tableView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}

