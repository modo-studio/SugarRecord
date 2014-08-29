//
//  NSPersistentStore+iCloud.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 29/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSPersistentStore {
    
    class func cloudURLForUbiquitiousContainer(bucketName: String) -> NSURL {
        let fileManager: NSFileManager = NSFileManager()
        var cloudURL: NSURL?
        cloudURL = fileManager.URLForUbiquityContainerIdentifier(bucketName)
        return cloudURL!
    }
}