import Foundation

internal class VersionProvider: NSObject {
    
    // MARK: - Constants
    
    internal static let apiReleasesUrl: String = "http://api.github.com/repos/pepibumur/sugarrecord/releases"

    
    // MARK: - Internal
    
    internal func framework() -> String! {
        if let version = Bundle(for: VersionProvider.classForCoder()).objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
            return version
        }
        return nil
    }
    
    internal func github(completion: (String) -> Void) {
        
        
        let request: URLRequest = URLRequest(url: URL(string: VersionProvider.apiReleasesUrl)!)
        URLSession(configuration: URLSessionConfiguration.default()).dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                let json: AnyObject? = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                if let array = json as? [[String: AnyObject]], lastVersion = array.first, versionTag: String = lastVersion["tag_name"] as? String {
                    completion(versionTag)
                }
            }
        }).resume()
    }
    
}
