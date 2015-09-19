//
//  RLMObject+SugarRecord.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

extension RLMObject
{
    //MARK: - Custom Getter
    
    /**
    Returns the context where this object is alive
    
    - returns: SugarRecord context
    */
    public func context() -> SugarRecordContext
    {
        if self.realm != nil {
            return SugarRecordRLMContext(realmContext: self.realm)
        }
        else {
            return SugarRecordRLMContext(realmContext: RLMRealm.defaultRealm())
        }
    }
    
    /**
    Returns the class entity name
    
    - returns: String with the entity name
    */
    public class func modelName() -> String
    {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    /**
    Returns the stack type compatible with this object
    
    - returns: SugarRecordEngine with the type
    */
    public class func stackType() -> SugarRecordEngine
    {
        return SugarRecordEngine.SugarRecordEngineRealm
    }
    
    //MARK: - Filtering
    
    /**
    Returns a SugarRecord  finder with the predicate set
    
    - parameter predicate: NSPredicate to be set to the finder
    
    - returns: SugarRecord finder with the predicate set
    */
    public class func by(predicate: NSPredicate) -> SugarRecordFinder
    {
        let finder: SugarRecordFinder = SugarRecordFinder(predicate: predicate)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    /**
    Returns a SugarRecord finder with the predicate set
    
    - parameter predicateString: Predicate in String format
    
    - returns: SugarRecord finder with the predicate set
    */
    public class func by(predicateString: NSString) -> SugarRecordFinder
    {
        let finder: SugarRecordFinder = SugarRecordFinder()
        finder.setPredicate(predicateString as String)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    /**
    Returns a SugarRecord finder with the predicate set
    
    - parameter key:   Key of the predicate to be filtered
    - parameter value: Value of the predicate to be filtered
    
    - returns: SugarRecord finder with the predicate set
    */
    public class func by<T: StringLiteralConvertible, R: StringLiteralConvertible>(key: T, equalTo value: R) -> SugarRecordFinder
    {
        let finder: SugarRecordFinder = SugarRecordFinder()
        finder.setPredicate(byKey: "\(key)", andValue: "\(value)")
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    //MARK: - Sorting
    
    /**
    Returns a SugarRecord finder with the sort descriptor set
    
    - parameter sortingKey: Sorting key
    - parameter ascending:  Sorting ascending value
    
    - returns: SugarRecord finder with the predicate set
    */
    public class func sorted<T: StringLiteralConvertible>(by sortingKey: T, ascending: Bool) -> SugarRecordFinder
    {
        let finder: SugarRecordFinder = SugarRecordFinder()
        finder.addSortDescriptor(byKey: "\(sortingKey)", ascending: ascending)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    /**
    Returns a SugarRecord finder with the sort descriptor set
    
    - parameter sortDescriptor: NSSortDescriptor to be set to the SugarRecord finder
    
    - returns: SugarRecord finder with the predicate set
    */
    public class func sorted(by sortDescriptor: NSSortDescriptor) -> SugarRecordFinder
    {
        let finder: SugarRecordFinder = SugarRecordFinder()
        finder.addSortDescriptor(sortDescriptor)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    /**
    Returns a SugarRecord finder with the sort descriptor set
    
    - parameter sortDescriptors: Array with NSSortDescriptors
    
    - returns: SugarRecord finder with the predicate set
    */
    public class func sorted(by sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder
    {
        let finder: SugarRecordFinder = SugarRecordFinder()
        finder.setSortDescriptors(sortDescriptors)
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    
    //MARK: - All
    
    /**
    Returns a SugarRecord finder with .all elements enabled
    
    - returns: SugarRecord finder
    */
    public class func all() -> SugarRecordFinder
    {
        let finder: SugarRecordFinder = SugarRecordFinder()
        finder.all()
        finder.objectClass = self
        finder.stackType = stackType()
        return finder
    }
    
    
    //MARK: - Count
    
    /**
    Returns the count of all existing element
    
    - returns: Int with the count
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
        SugarRecordLogger.logLevelVerbose.log("Object deleted in its context")
        return self.context().deleteObject(self)
    }
    
    
    //MARK: - Creation
    
    /**
    Creates a new object without inserting it in the context
    
    - returns: Created database object
    */
    public class func create() -> AnyObject
    {
        SugarRecordLogger.logLevelVerbose.log("Object created")
        var object: AnyObject?
        SugarRecord.operation(RLMObject.stackType(), closure: { (context) -> () in
            object = context.createObject(self)
        })
        return object!
    }
    
    
    /**
    Create a new object without inserting it in the passed context
    
    - parameter context: Context where the object is going to be created
    
    - returns: Created database object
    */
    public class func create(inContext context: SugarRecordContext) -> AnyObject
    {
        SugarRecordLogger.logLevelVerbose.log("Object created")
        return context.createObject(self)!
    }
    
    
    //MARK: - Saving
    
    /**
    Saves the object in the object context
    
    - returns: Bool indicating if the object has been properly saved
    */
    public func save () -> Bool
    {
        SugarRecordLogger.logLevelVerbose.log("Object saved in its content")
        var saved: Bool = false
        self.save(false, completion: { (error) -> () in
            saved = error == nil
        })
        return saved
    }
    
    
    /**
    Saves the object in the context asynchronously (or not) passing a completion closure
    
    - parameter asynchronously: Bool indicating if the saving process is asynchronous or not
    - parameter completion:     Closure called when the saving operation has been completed
    */
    public func save (asynchronously: Bool, completion: CompletionClosure)
    {
        let context: SugarRecordContext = self.context()
        if asynchronously {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                context.beginWriting()
                context.insertObject(self)
                context.endWriting()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(error: nil)
                })
            })
        }
        else {
            context.beginWriting()
            context.insertObject(self)
            context.endWriting()
            completion(error: nil)
        }
    }
    
    
    //MARK: - beginWriting
    
    /**
    Needed to be called when the object is going to be edited
    
    - returns: returns the current object
    */
    public func beginWriting() -> RLMObject
    {
        SugarRecordLogger.logLevelVerbose.log("Object did begin writing")
        self.context().beginWriting()
        return self
    }
    
    /**
    Needed to be called when the edition has finished
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


