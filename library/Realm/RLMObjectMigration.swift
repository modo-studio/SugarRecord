//
//  RLMObjectMigration.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 04/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

public struct RLMObjectMigration<T: RLMObject> {
    
    /// Version of the schema after the migration
    internal var toSchema: Int
    
    /// Migration closure to be executed
    internal var migrationClosure: (oldObject: RLMObject, newObject: RLMObject) -> ()
    
    /**
    Migrationinitializer
    
    - parameter fromSchema:       Version of the schema before the migration
    - parameter toSchema:         Version of the schema after the migration
    - parameter migrationClosure: Migration closure to be executed
    
    - returns: Initialized migration struct
    */
    init(toSchema: Int, migrationClosure: (oldObject: RLMObject, newObject: RLMObject) -> ()) {
        self.toSchema = toSchema
        self.migrationClosure = migrationClosure
    }
    
    /**
    Executes the migration using the Realm migration object
    
    - parameter realmMigration: Realm migration object
    */
    public func migrate(realmMigration: RLMMigration) {
        let modelName: String = T.modelName()
        realmMigration.enumerateObjects(modelName, block: { (oldObject: RLMObject!, newObject: RLMObject!) -> Void in
            self.migrationClosure(oldObject: oldObject, newObject: newObject)
        })
    }
}
