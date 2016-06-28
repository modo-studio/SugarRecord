import Foundation

internal class VersionProvider: NSObject {
    
    // MARK: - Constants
    
    internal static let apiReleasesUrl: String = "http://api.github.com/repos/pepibumur/sugarrecord/releases"

    
    // MARK: - Internal
    
    internal func framework() -> String! {
        if let version = NSBundle(forClass: VersionProvider.classForCoder()).objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
            return version
        }
        return nil
    }
    
    internal func github(completion: String -> Void) {
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: VersionProvider.apiReleasesUrl)!)
        NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration()).dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if let data = data {
                let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                if let array = json as? [[String: AnyObject]], lastVersion = array.first, versionTag: String = lastVersion["tag_name"] as? String {
                    completion(versionTag)
                }
            }
        }).resume()
    }
    
}
