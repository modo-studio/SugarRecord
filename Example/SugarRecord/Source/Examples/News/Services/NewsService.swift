import Foundation
import SugarRecord
import RealmSwift

class NewsService {
    
    // MARK: - Attributes
    
    private let session: URLSession
    private let apiKey: String
    private let storage: Storage
    
    // MARK: - Init
    
    init(session: URLSession, storage: Storage, apiKey: String) {
        self.session = session
        self.storage = storage
        self.apiKey = apiKey
    }
    
    convenience init(storage: Storage) {
        self.init(session: URLSession.shared, storage: storage, apiKey: "c7a6b4e8e221414b88a5883a98bbfbf9")
    }
    
    // MARK: - Sync
    
    internal func sync(completion: ((Swift.Error?) -> Void)? = nil) {
        let url = URL(string: "https://newsapi.org/v1/articles?source=the-next-web&sortBy=latest&apiKey=\(self.apiKey)")!
        self.session.dataTask(with: url) { [weak self] (data, _, error) in
            self?.save(data: data!)
            completion?(error)
        }.resume()
    }
    
    // MARK: - Private
    
    private func save(data: Data) {
        guard let dict = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
        guard let articles = dict["articles"] as? [[String: Any]] else { return }
        DispatchQueue.main.async {
            _ = try? self.storage.operation { (context, save) -> Void in
                let existing = try context.fetch(FetchRequest<RealmNew>())
                try context.remove(existing)
                for article in articles {
                    guard let title = article["title"] as? String else { return }
                    let new: RealmNew = try context.create()
                    new.title = title
                }
                save()
            }
        }
    }
    
}
