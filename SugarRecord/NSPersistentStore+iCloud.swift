//
//  NSPersistentStore+iCloud.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 29/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

extension NSPersistentStore {
    /**
     Return the NSURL for ubiquitious container

     :param: bucketName Bucket cloud container

     :returns: NSURL with the address
     */
    class func cloudURLForUbiquitiousContainer(bucketName: String) -> NSURL {
        return NSFileManager().URLForUbiquityContainerIdentifier(bucketName)!
    }
}