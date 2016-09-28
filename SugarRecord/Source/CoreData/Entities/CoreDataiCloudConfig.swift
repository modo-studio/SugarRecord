import Foundation

public struct CoreDataiCloudConfig {
    
    // MARK: - Attributes
    
    internal let ubiquitousContentName: String
    internal let ubiquitousContentURL: String
    internal let ubiquitousContainerIdentifier: String
    internal let ubiquitousPeerTokenOption: String?
    internal let removeUbiquitousMetadataOption: Bool?
    internal let rebuildFromUbiquitousContentOption: Bool?
    
    
    // MARK: - Init
    
    public init(ubiquitousContentName: String,
        ubiquitousContentURL: String,
        ubiquitousContainerIdentifier: String,
        ubiquitousPeerTokenOption: String? = nil,
        removeUbiquitousMetadataOption: Bool? = nil,
        rebuildFromUbiquitousContentOption: Bool? = nil) {
            self.ubiquitousContentName = ubiquitousContentName
            self.ubiquitousContentURL = ubiquitousContentURL
            self.ubiquitousPeerTokenOption = ubiquitousPeerTokenOption
            self.removeUbiquitousMetadataOption = removeUbiquitousMetadataOption
            self.ubiquitousContainerIdentifier = ubiquitousContainerIdentifier
            self.rebuildFromUbiquitousContentOption = rebuildFromUbiquitousContentOption
    }
}
