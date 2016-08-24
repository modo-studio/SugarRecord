import Foundation
import UIKit
import SugarRecord
import CoreData
import RxSwift

class CoreDataObservableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Attributes
    lazy var db: CoreDataDefaultStorage = {
        let store = CoreData.Store.Named("cd_basic")
        let bundle = NSBundle(forClass: CoreDataBasicView.classForCoder())
        let model = CoreData.ObjectModel.Merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }()
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "default-cell")
        return _tableView
    }()
    var disposeBag: DisposeBag = DisposeBag()
    var entities: [CoreDataBasicEntity] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "CoreData Observable"
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
    }
    
    
    // MARK: - Private
    
    private func setup() {
        setupView()
        setupNavigationItem()
        setupTableView()
        setupObservable()
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    private func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(CoreDataBasicView.userDidSelectAdd(_:)))
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    private func setupObservable() {
        db.observable(Request<BasicObject>().sortedWith("date", ascending: true))
            .rx_observe()
            .subscribeNext { [weak self] (change) in
                switch change {
                case .Initial(let entities):
                    self?.entities = entities.map(CoreDataBasicEntity.init)
                    break
                case .Update(let deletions, let insertions, let modifications):
                    modifications.forEach { [weak self] in self?.entities[$0.0] = CoreDataBasicEntity(object: $0.1) }
                    insertions.forEach { [weak self] in self?.entities.insert(CoreDataBasicEntity(object: $0.1), atIndex: $0.0) }
                    deletions.forEach({ [weak self] in self?.entities.removeAtIndex($0) })
                    break
                default:
                    break
                }
            }
            .addDisposableTo(self.disposeBag)
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
                guard let obj = try! context.request(BasicObject.self).filteredWith("name", equalTo: name).fetch().first else { return }
                _ = try? context.remove(obj)
                save()
            })
        }
    }
    
    
    // MARK: - Actions
    
    func userDidSelectAdd(sender: AnyObject!) {
        try! db.operation { (context, save) -> Void in
            let _object: BasicObject = try! context.new()
            _object.date = NSDate()
            _object.name = randomStringWithLength(10) as String
            try! context.insert(_object)
            save()
        }
    }
    
}