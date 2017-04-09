import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Attributes
    
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "default-cell")
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "default-cell")!
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.textLabel?.text = "CoreData Basic"
        default:
            cell.textLabel?.text = ""
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).row {
        case 0:
            self.navigationController?.pushViewController(CoreDataBasicView(), animated: true)
        default:
            break
        }
    }
}

