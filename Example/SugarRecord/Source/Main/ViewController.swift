import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Attributes
    
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "default-cell")
        return _tableView
    }()
    
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "SugarRecord Examples"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        setupView()
        setupTableView()
    }

    private func setupView() {
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    
    // MARK: - UITableViewDataSource / UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("default-cell")!
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "CoreData Basic"
        case 1:
            cell.textLabel?.text = "Realm Basic"
        case 2:
            cell.textLabel?.text = "CoreData Observable"
        case 3:
            cell.textLabel?.text = "Realm Observable"
        default:
            cell.textLabel?.text = ""
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(CoreDataBasicView(), animated: true)
        case 1:
            self.navigationController?.pushViewController(RealmBasicView(), animated: true)
        case 2:
            self.navigationController?.pushViewController(CoreDataObservableView(), animated: true)
        case 3:
            self.navigationController?.pushViewController(RealmObservableView(), animated: true)
        default:
            break
        }
    }
}

