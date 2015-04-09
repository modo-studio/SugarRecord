//
//  SugarRecordFinder.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

/**
Enum that indicates which elements fetch

- first:  The first one
- last:   The last one
- all:    All the elements
- firsts: The firsts x
- lasts:  The lasts x
*/
public enum SugarRecordFinderElements
{
    case first, last, all
    case firsts(Int)
    case lasts(Int)
}

public class SugarRecordFinder
{
    //MARK: - Attributes
    
    /// Filtering NSPredicate
    public var predicate: NSPredicate?
    
    /// Type of stack where the operations are going to executed
    public var stackType: SugarRecordEngine?
    
    /// Class of the object
    public var objectClass: NSObject.Type?
    
    /// Enum that indicates which objects have to be fetched (first/firsts(n)/last/lasts(n)/all)
    public var elements: SugarRecordFinderElements = .all
    
    /// Sort descriptors to sort the fetched results
    public lazy var sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor] ()
    
    
    // MARK - Constructors
    
    /**
    Default initializer
    
    :returns: The initialized SugarRecordFinder
    */
    public init () {}
    
    /**
    Initializer passing a predicate
    
    :param: predicate To be set in the initialized finder
    
    :returns: The initialized SugarRecordFinder
    */
    public init (predicate: NSPredicate)
    {
        self.predicate = predicate
    }
    
    /**
    Initializer passing a sort descriptor
    
    :param: sortDescriptor To be appended in the sort descriptors array
    
    :returns: The initialized SugarRecordFinder
    */
    public init (sortDescriptor: NSSortDescriptor)
    {
        self.sortDescriptors = [sortDescriptor]
    }
    
    
    // MARK - Concatenators
    
    /**
    Add a predicate to the finder
    
    :param: predicate To be set as the finder's predicate
    
    :returns: Current finder
    */
    public func by(predicate: NSPredicate) -> SugarRecordFinder
    {
        if self.predicate != nil {
            SugarRecordLogger.logLevelWarn.log("You are overriding an existing predicate")
        }
        self.predicate = predicate
        return self
    }
    
    /**
    Add a predicate passing it as an String
    
    :param: predicateString To be set as the finder's predicate
    
    :returns: Current finder
    */
    public func by(predicateString: NSString) -> SugarRecordFinder
    {
        if self.predicate != nil {
            SugarRecordLogger.logLevelWarn.log("You are overriding an existing predicate")
        }
        self.setPredicate(predicateString as! String)
        return self
    }
    
    /**
    Add a predicate passing it as a key/value pair
    
    :param: key   Key to be filtered
    :param: value Value of that key
    
    :returns: Current finder
    */
    public func by<T: StringLiteralConvertible, R: StringLiteralConvertible>(key: T, equalTo value: R) -> SugarRecordFinder
    {
        if self.predicate != nil {
            SugarRecordLogger.logLevelWarn.log("You are overriding an existing predicate")
        }
        self.setPredicate(byKey: "\(key)", andValue: "\(value)")
        return self
    }
    
    /**
    Append a sort descriptor passing a sorting key and an ascending value
    
    :param: sortingKey Sorting key
    :param: ascending  Ascending value
    
    :returns: Current finder
    */
    public func sorted<T: StringLiteralConvertible>(by sortingKey: T, ascending: Bool) -> SugarRecordFinder
    {
        self.addSortDescriptor(byKey: "\(sortingKey)", ascending: ascending)
        return self
    }
    
    /**
    Append a sort descriptor passing a NSSortDescriptor directly
    
    :param: sortDescriptor Sort descriptor
    
    :returns: Current finder
    */
    public func sorted(by sortDescriptor: NSSortDescriptor) -> SugarRecordFinder
    {
        self.addSortDescriptor(sortDescriptor)
        return self
    }
    
    /**
    Append a sort descriptor passing an array with NSSortDescriptors
    
    :param: sortDescriptors Array with sort descriptors
    
    :returns: Current finder
    */
    public func sorted(by sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder
    {
        if self.sortDescriptors.count != 0  {
            SugarRecordLogger.logLevelWarn.log("You are overriding the existing sort descriptors")
        }
        self.sortDescriptors = sortDescriptors
        return self
    }
    
    
    //MARK: - Sort Descriptors
    
    /**
    Append a NSSortDescriptor to the finder
    
    :param: sortDescriptor Sort descriptor to be appended
    
    :returns: Current finder
    */
    public func addSortDescriptor(sortDescriptor: NSSortDescriptor) -> SugarRecordFinder
    {
        sortDescriptors.append(sortDescriptor)
        return self
    }
    
    /**
    Append a NSSortDescriptor using a key and an ascending value
    
    :param: key       Sorting Key value
    :param: ascending Sorting value
    
    :returns: Current finder
    */
    public func addSortDescriptor<T: StringLiteralConvertible>(byKey key: T, ascending: Bool) -> SugarRecordFinder
    {
        sortDescriptors.append(NSSortDescriptor(key: "\(key)", ascending: ascending))
        return self
    }
    
    /**
    Append NSSortDescriptors using an array of them
    
    :param: sortDescriptors Array of sort descriptors to be appended
    
    :returns: Current finder
    */
    public func setSortDescriptors(sortDescriptors: [NSSortDescriptor]) -> SugarRecordFinder
    {
        self.sortDescriptors = sortDescriptors
        return self
    }
    
    /**
    Returns the count of sort descriptors in the finder
    
    :returns: Int with the count of sort descriptors
    */
    public func sortDescriptorsCount() -> Int
    {
        return self.sortDescriptors.count
    }
    
    
    //MARK: - Predicates
    
    /**
    Set the finder predicate passing the NSPredicate
    
    :param: predicate Predicate to be set as the finder predicate
    
    :returns: Current finder
    */
    public func setPredicate(predicate: NSPredicate) -> SugarRecordFinder
    {
        self.predicate = predicate
        return self
    }
    
    /**
    Set the finder predicate passing it in String format
    
    :param: predicateString String with the predicate format
    
    :returns: Current finder
    */
    public func setPredicate(predicateString: String) -> SugarRecordFinder
    {
        self.predicate = NSPredicate(format: predicateString)
        return self
    }
    
    /**
    Set the finder predicate passing it in a key/value format
    
    :param: key   Predicate key value
    :param: value Predicate value
    
    :returns: Current finder
    */
    public func setPredicate<T: StringLiteralConvertible, R: StringLiteralConvertible>(byKey key: T, andValue value: R) -> SugarRecordFinder
    {
        self.predicate = NSPredicate(format: "\(key) == '\(value)'")
        return self
    }
    
    
    //MARK: - Elements
    
    /**
    Set the elements as .all
    
    :returns: Current finder
    */
    public func all() -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.all
        return self
    }
    
    /**
    Set the elements as .first
    
    :returns: Current finder
    */
    public func first() -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.first
        return self
    }
    
    /**
    Set the elements as .last
    
    :returns: Current finder
    */
    public func last() -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.last
        return self
    }
    
    /**
    Set the elements as .firsts(n)
    
    :param: number Number of firsts elements
    
    :returns: Current finder
    */
    public func firsts(number: Int) -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.firsts(number)
        return self
    }
    
    /**
    Set the elements as .lasts(n)
    
    :param: number Number of lasts elements
    
    :returns: Current finder
    */
    public func lasts(number: Int) -> SugarRecordFinder
    {
        self.elements = SugarRecordFinderElements.lasts(number)
        return self
    }
    
    
    // MARK - Finder
    
    /**
    Execute the finder request in the SugarRecord stack
    
    :returns: Fetch result
    */
    public func find() -> SugarRecordResults
    {
        var objects: SugarRecordResults!
        SugarRecord.operation(stackType!, closure: { (context) -> () in
            objects = context.find(self)
        })
        return objects
    }
    
    public func find(inContext context:SugarRecordContext) -> SugarRecordResults
    {
        return context.find(self)
    }
    
    // MARK - Deletion
    
    /**
    Deletes the object in the SugarRecord stack
    
    :returns: If the deletion has been successful
    */
    public func delete () -> ()
    {
        delete(true, completion: { () -> () in })
    }
    
    /**
    Deletes the object asynchronously ( or not )
    
    :param: asynchronously Indicates if the deletion has to be asynchronous
    :param: completion     Completion closure with a successful indicator as input parameter
    */
    public func delete (asynchronously: Bool, completion: () -> ())
    {
        SugarRecord.operation(inBackground: asynchronously, stackType: stackType!) { (context) -> () in
            let objects: SugarRecordResults! = context.find(self)
            if objects == nil {
                SugarRecordLogger.logLevelInfo.log("No objects have been deleted")
                return
            }
            context.beginWriting()
            context.deleteObjects(objects!)
            context.endWriting()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion()
            })

        }
    }
    
    //MARK : Count
    
    /**
    Returns the count of items that match the criteria
    
    :returns: Int with the count
    */
    public func count() -> Int
    {
        var count: Int = 0
        SugarRecord.operation(stackType!, closure: { (context) -> () in
            count = self.count(inContext: context)
        })
        return count
    }
    
    /**
    Returns the count of items that match the criteria in the given context
    
    :param: context Context where the count is executed
    
    :returns: Int with the count
    */
    public func count(inContext context:SugarRecordContext) -> Int
    {
        if (stackType == SugarRecordEngine.SugarRecordEngineCoreData) {
            return (context as! SugarRecordCDContext).count(self.objectClass!, predicate: self.predicate)
        }
        else {
            return find().count
        }
    }
}
