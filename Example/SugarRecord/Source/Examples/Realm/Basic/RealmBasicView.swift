import Foundation
import UIKit
import SugarRecord
import RealmSwift

class RealmBasicView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Attributes
    lazy var db: RealmDefaultStorage = {
        var configuration = Realm.Configuration()
        configuration.fileURL = NSURL(fileURLWithPath: databasePath("realm-basic"))
        let _storage = RealmDefaultStorage(configuration: configuration)
        return _storage
    }()
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "default-cell")
        return _tableView
    }()
    var entities: [RealmBasicEntity] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Realm Basic"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("🚀🚀🚀 Deallocating \(self) 🚀🚀🚀")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateData()
    }
    
    
    // MARK: - Private
    
    private func setup() {
        setupView()
        setupNavigationItem()
        setupTableView()
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    private func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(RealmBasicView.userDidSelectAdd(_:)))
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    
    // MARK: - UITableViewDataSource / UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("default-cell")!
        cell.textLabel?.text = "\(entities[indexPath.row].name) - \(entities[indexPath.row].dateString)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let name = entities[indexPath.row].name
            try! db.operation({ (context, save) -> Void in
                guard let obj = try! context.request(RealmBasicObject.self).filteredWith("name", equalTo: name).fetch().first else { return }
                _ = try? context.remove(obj)
                save()
            })
            updateData()
        }
    }
    
    
    // MARK: - Actions
    
    func userDidSelectAdd(sender: AnyObject!) {
        try! db.operation { (context, save) -> Void in
            let _object: RealmBasicObject = try! context.new()
            _object.date = NSDate()
            _object.name = randomStringWithLength(10) as String
            try! context.insert(_object)
            save()
        }
        updateData()
    }
    
    
    // MARK: - Private
    
    private func updateData() {
        self.entities = try! db.fetch(Request<RealmBasicObject>()).map(RealmBasicEntity.init)
    }
}