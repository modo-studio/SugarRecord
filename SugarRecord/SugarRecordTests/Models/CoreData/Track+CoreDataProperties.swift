//
//  Track+CoreDataProperties.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 12/11/15.
//  Copyright © 2015 GitDo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Track {

    @NSManaged var name: String?
    @NSManaged var artist: String?

}
