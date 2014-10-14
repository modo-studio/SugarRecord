//
//  DefaultREALMStack.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 15/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm


public class DefaultREALMStack: SugarRecordStackProtocol
{
    public var name: String
    public var stackDescription: String
    public var stackType: SugarRecordStackType = SugarRecordStackType.SugarRecordStackTypeRealm
    lazy public var migrations: [RLMObjectMigration<RLMObject>] = [RLMObjectMigration<RLMObject>]()
    
    //MARK: - Constructors
    
    /**
    Default initializer
    
    :param: stackName        String with the stack name
    :param: stackDescription String with the stack description
    
    :returns: Created stack with the properties set
    */
    required public init(stackName:String, stackDescription: String) {
        self.name = stackName
        self.stackDescription = stackDescription
    }
    
    /**
    Initializer with support for migrations
    
    :param: stackName        String with the stack name
    :param: stackDescription String with the stack description
    :param: migrations       Array with the migrations
    
    :returns: Created stack with the migrations and properties set
    */
    convenience public init(stackName:String, stackDescription: String, migrations: [RLMObjectMigration<RLMObject>]) {
        self.init(stackName: stackName, stackDescription: stackDescription)
        self.name = stackName
        self.stackDescription = stackDescription
        self.migrations = migrations
    }
    
    /**
    Initializes the stack to start using it
    */
    public func initialize()
    {
        migrateIfNeeded()
    }
    
    /**
    Cleans upt the stack
    */
    public func cleanup()
    {
        // Nothing to do here
    }
    
    /**
    Called when the application will resign active
    */
    public func applicationWillResignActive()
    {
        // Nothing to do here
    }
    
    /**
    Called when the application will terminate
    */
    public func applicationWillTerminate()
    {
        // Nothing to do here
    }
    
    /**
    Called when the application will enter foreground
    */
    public func applicationWillEnterForeground()
    {
        // Nothing to do here
    }
    
    /**
    Returns a background context to execute the background operations there
    
    :returns: Created SugarRecord background context
    */
    public func backgroundContext() -> SugarRecordContext?
    {
        return SugarRecordRLMContext(realmContext: RLMRealm.defaultRealm())
    }
    
    /**
    Returns a context to execute the main operations there
    
    :returns: Created SugarRecord context
    */
    public func mainThreadContext() -> SugarRecordContext?
    {
        return SugarRecordRLMContext(realmContext: RLMRealm.defaultRealm())
    }
    
    /**
    Removes the local databse
    */
    public func removeDatabase()
    {
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let databaseName: String = documentsPath.stringByAppendingPathComponent("default.realm")
        var error: NSError?
        NSFileManager.defaultManager().removeItemAtPath(databaseName, error: &error)
        if error != nil {
            let exception: NSException = NSException(name: "Database operations", reason: "Couldn't delete the database \(databaseName)", userInfo: ["error": error!])
            SugarRecord.handle(exception)
        }
        else {
            SugarRecordLogger.logLevelInfo.log("Database \(databaseName) removed")
        }
    }
    
    /**
    Executes migrations if there are migrations in the array
    */
    func migrateIfNeeded()
    {
        if self.migrations.isEmpty { return }
        RLMRealm.migrateDefaultRealmWithBlock({ (realmMigration: RLMMigration!, oldSchema: UInt) -> UInt in
            let sortedMigrations: [RLMObjectMigration<RLMObject>] = DefaultREALMStack.sorted(migrations: self.migrations, fromOldSchema: Int(oldSchema))
            var lastSchema: Int = sortedMigrations.last!.toSchema
            sortedMigrations.map({ (migration: RLMObjectMigration<RLMObject>) -> RLMObjectMigration<RLMObject> in
                migration.migrate(realmMigration)
                return migration
            })
            return UInt(lastSchema);
        })
    }
    
    internal class func sorted(#migrations: [RLMObjectMigration<RLMObject>], fromOldSchema oldSchema: Int) -> [RLMObjectMigration<RLMObject>]
    {
        var sortedMigrations: [RLMObjectMigration<RLMObject>] = migrations.filter({ (migration: RLMObjectMigration<RLMObject>) -> Bool in return migration.toSchema > Int(oldSchema)})
        sortedMigrations.sort({ (first: RLMObjectMigration<RLMObject>, second: RLMObjectMigration<RLMObject>) -> Bool in return first.toSchema <= second.toSchema})
        return sortedMigrations
    }
}