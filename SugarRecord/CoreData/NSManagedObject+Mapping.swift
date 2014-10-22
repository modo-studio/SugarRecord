//
//  NSManagedObject+Mapping.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 22/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import UIKit

extension NSManagedObject: SugarRecordMappingProtocol {
   
    public typealias MappingObjectType = NSManagedObject
    
    public class func defaultMapper() -> SugarRecordMapper {
        // Abstract method, each object should implement its own
        return SugarRecordMapper(inferMapping: true, attributeNotFound: nil)
    }
    
    public class func map(#objects: [[String: NSObject]])
    {
        SugarRecord.operation(inBackground: true, stackType: SugarRecordStackType.SugarRecordStackTypeCoreData) { (context) -> () in
           _ =  NSManagedObject.map(objects: objects, inContext: context)
        }
    }
    
    public class func map(#objects: [[String: NSObject]], inContext context: SugarRecordContext) -> [MappingObjectType]
    {
        return NSManagedObject.map(objects: objects, inContext: context, withMapper: self.defaultMapper())
    }
    
    public class func map(#objects: [[String: NSObject]], inContext context: SugarRecordContext, withMapper mapper: SugarRecordMapper) -> [MappingObjectType]
    {
        var objects: [MappingObjectType] = [MappingObjectType]()
        for objectDictionary in objects {
            objects.append(self.map(object: objectDictionary, inContext: context, withMapper: mapper))
        }
        return objects
    }
    
    public class func map(#object: [String: NSObject], inContext context: SugarRecordContext, withMapper mapper: SugarRecordMapper) -> MappingObjectType
    {
        
    }
    
    public func map(#attribute: SugarRecordMappingAttribute, attributes: [String: NSObject])
    {
        
    }
}
