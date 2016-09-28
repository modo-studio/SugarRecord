import Foundation
import UIKit
import SugarRecord
import RealmSwift

class NewsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Attributes
    lazy var db: RealmDefaultStorage = {
        var configuration = Realm.Configuration()
        configuration.fileURL = URL(fileURLWithPath: databasePath("realm-news"))
        let _storage = RealmDefaultStorage(configuration: configuration)
        return _storage
    }()
    lazy var service: NewsService = {
        return NewsService(storage: self.db)
    }()
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "default-cell")
        return _tableView
    }()
    var entities: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "News"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.service.sync()
        let request = FetchRequest<RealmNew>()
        self.db.observable(request).observe { [weak self] (change) in
            switch change {
            case .initial(let values):
                self?.entities = values.map({$0.title})
            case .update(_, _, _):
                do {
                    self?.entities = try self?.db.fetch(request).map({$0.title}) ?? []
                } catch {}
            default: break
            }
        }
    }
    
    
    // MARK: - Private
    
    fileprivate func setup() {
        setupView()
        setupTableView()
    }
    
    fileprivate func setupView() {
        self.view.backgroundColor = UIColor.white
    }
    
    fileprivate func setupTableView() {
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    
    // MARK: - UITableViewDataSource / UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "default-cell")!
        cell.textLabel?.text = "\(entities[(indexPath as NSIndexPath).row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
