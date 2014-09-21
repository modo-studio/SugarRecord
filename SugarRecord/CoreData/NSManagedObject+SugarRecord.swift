//
//  NSManagedObject+SugarRecord.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject: SugarRecordObjectProtocol
{
    //MARK - Custom Getter
    
    /**
    Returns the context where this object is alive
    
    :returns: SugarRecord context 
    */
    public func context() -> SugarRecordContext
    {
        return SugarRecordCDContext(context: self.managedObjectContext)
    }
    
    /**
    Returns the class entity name
    
    :returns: String with the entity name
    */
    public class func entityName() -> String
    {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    /**
    Returns the stack type compatible with this object
    
    :returns: SugarRecordStackType with the type
    */
    public class func stackType() -> SugarRecordStackType
    {
        return SugarRecordStackType.SugarRecordStackTypeCoreData
    }
    
    //MARK - Filtering
    
    public class func by(predicate: NSPredicate) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder(predicate: predicate)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    public class func by(predicateString: NSString) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.setPredicate(predicateString)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    public class func by(key: String, equalTo value: String) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.setPredicate(byKey: key, andValue: value)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    //MARK - Sorting
    
    public class func sorted(by sortingKey: String, ascending: Bool) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.addSortDescriptor(byKey: sortingKey, ascending: ascending)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    public class func sorted(by sortDescriptor: NSSortDescriptor) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.addSortDescriptor(sortDescriptor)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    public class func sorted(by sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.setSortDescriptors(sortDescriptors)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    
    //MARK - All
    
    public class func all() -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.all()
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    //MARK - Deletion
    
    public func delete() -> Bool
    {
        var deleted: Bool = false
        SugarRecord.operation(NSManagedObject.stackType(), closure: { (context) -> () in
            context.beginWritting()
            deleted = context.deleteObject(self)
            context.endWritting()
        })
        return deleted
    }
    
    //MARK - Creation
    
    public class func create() -> AnyObject
    {
        var object: AnyObject?
        SugarRecord.operation(NSManagedObject.stackType(), closure: { (context) -> () in
            object = context.createObject(self)
        })
        return object!
    }
    
    public class func create(inContext context: SugarRecordContext) -> AnyObject
    {
        return context.createObject(self)!
    }
    
    //MARK - Saving
    
    public func save () -> Bool
    {
        var saved: Bool = false
        self.save(false, completion: { (error) -> () in
            saved = error == nil
        })
        return saved
    }
    
    public func save (asynchronously: Bool, completion: (error: NSError) -> ())
    {
        let context: SugarRecordContext = self.context()
        if asynchronously {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                context.beginWritting()
                context.insertObject(self)
                context.endWritting()
            })
        }
        else {
            context.endWritting()
        }
    }
    
    
    //MARK - BeginEditing
    
    public func beginEditing()
    {
        // Not needed this in CoreData
    }
    
    public func endEditing()
    {
        // Not needed this in CoreData
    }
}