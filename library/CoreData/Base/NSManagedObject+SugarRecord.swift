//
//  NSManagedObject+SugarRecord.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject
{
    typealias SugarRecordObjectType = NSManagedObject

    //MARK: - Custom Getter
    
    /**
    Returns the context where this object is alive
    
    :returns: SugarRecord context 
    */
    public func context() -> SugarRecordContext
    {
        return SugarRecordCDContext(context: self.managedObjectContext!)
    }
    
    
    /**
    Returns the class entity name
    
    :returns: String with the entity name
    */
    public class func modelName() -> String
    {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    /**
    Returns the stack type compatible with this object
    
    :returns: SugarRecordEngine with the type
    */
    public class func stackType() -> SugarRecordEngine
    {
        return SugarRecordEngine.SugarRecordEngineCoreData
    }
    
    //MARK: - Filtering
    
    /**
    Returns a SugarRecord  finder with the predicate set
    
    :param: predicate NSPredicate to be set to the finder
    
    :returns: SugarRecord finder with the predicate set
    */
    public class func by(predicate: NSPredicate) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder(predicate: predicate)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    /**
    Returns a SugarRecord finder with the predicate set
    
    :param: predicateString Predicate in String format
    
    :returns: SugarRecord finder with the predicate set
    */
    public class func by(predicateString: NSString) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.setPredicate(predicateString as! String)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    /**
    Returns a SugarRecord finder with the predicate set
    
    :param: key   Key of the predicate to be filtered
    :param: value Value of the predicate to be filtered
    
    :returns: SugarRecord finder with the predicate set
    */
    public class func by<T: StringLiteralConvertible, R: StringLiteralConvertible>(key: T, equalTo value: R) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.setPredicate(byKey: "\(key)", andValue: "\(value)")
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    
    //MARK: - Sorting
    
    /**
    Returns a SugarRecord finder with the sort descriptor set
    
    :param: sortingKey Sorting key
    :param: ascending  Sorting ascending value
    
    :returns: SugarRecord finder with the predicate set
    */
    public class func sorted<T: StringLiteralConvertible>(by sortingKey: T, ascending: Bool) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.addSortDescriptor(byKey: "\(sortingKey)", ascending: ascending)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    /**
    Returns a SugarRecord finder with the sort descriptor set
    
    :param: sortDescriptor NSSortDescriptor to be set to the SugarRecord finder
    
    :returns: SugarRecord finder with the predicate set
    */
    public class func sorted(by sortDescriptor: NSSortDescriptor) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.addSortDescriptor(sortDescriptor)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    /**
    Returns a SugarRecord finder with the sort descriptor set
    
    :param: sortDescriptors Array with NSSortDescriptors
    
    :returns: SugarRecord finder with the predicate set
    */
    public class func sorted(by sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.setSortDescriptors(sortDescriptors)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    
    //MARK: - All
    
    /**
    Returns a SugarRecord finder with .all elements enabled
    
    :returns: SugarRecord finder
    */
    public class func all() -> SugarRecordFinder
    {
        var finder: SugarRecordFinder = SugarRecordFinder()
        finder.all()
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    

    //MARK: - Count
    
    /**
    Returns a the count of elements of this type
    
    :returns: Int
    */
    public class func count() -> Int
    {
        return all().count()
    }
    
    //MARK: - Deletion
    
    /**
    *  Deletes the object
    */
    public func delete() -> SugarRecordContext
    {
        SugarRecordLogger.logLevelVerbose.log("Object \(self) deleted in its context")
        return self.context().deleteObject(self)
    }
    
    
    //MARK: - Creation
    
    /**
    Creates a new object without inserting it in the context
    
    :returns: Created database object
    */
    public class func create() -> AnyObject
    {
        SugarRecordLogger.logLevelVerbose.log("Object created")
        var object: AnyObject?
        SugarRecord.operation(NSManagedObject.stackType(), closure: { (context) -> () in
            object = context.createObject(self)
        })
        return object!
    }
    
    /**
    Create a new object without inserting it in the passed context
    
    :param: context Context where the object is going to be created
    
    :returns: Created database object
    */
    public class func create(inContext context: SugarRecordContext) -> AnyObject
    {
        SugarRecordLogger.logLevelVerbose.log("Object created")
        return context.createObject(self)!
    }
    
    //MARK: - Saving
    
    /**
    Saves the object in the object context
    
    :returns: Bool indicating if the object has been properly saved
    */
    public func save () -> Bool
    {
        SugarRecordLogger.logLevelVerbose.log("Object saved in context")
        var saved: Bool = false
        self.save(false, completion: { (error) -> () in
            saved = error == nil
        })
        return saved
    }
    
    /**
    Saves the object in the object context asynchronously (or not) passing a completion closure
    
    :param: asynchronously Bool indicating if the saving process is asynchronous or not
    :param: completion     Closure called when the saving operation has been completed
    */
    public func save (asynchronously: Bool, completion: CompletionClosure)
    {
        SugarRecordLogger.logLevelVerbose.log("Saving \(self) in context")
        let context: SugarRecordContext = self.context()
        if asynchronously {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                context.endWriting()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(error: nil)
                })
            })
        }
        else {
            context.endWriting()
            completion(error: nil)
        }
    }
    
    
    //MARK: - beginWriting
    
    /**
    Needed to be called when the object is going to be edited
    
    :returns: returns the current object
    */
    public func beginWriting() -> NSManagedObject
    {
        SugarRecordLogger.logLevelVerbose.log("Object did begin writing")
        self.context().beginWriting()
        return self
    }
    
    /**
    Needed to be called when the edition/deletion has finished
    */
    public func endWriting()
    {
        SugarRecordLogger.logLevelVerbose.log("Object did end writing")
        self.context().endWriting()
    }
    
    /**
    * Asks the context for writing cancellation
    */
    public func cancelWriting()
    {
        SugarRecordLogger.logLevelVerbose.log("Object did end writing")
        self.context().cancelWriting()
    }
}