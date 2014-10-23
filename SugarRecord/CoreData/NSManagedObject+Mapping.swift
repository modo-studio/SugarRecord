////
////  NSManagedObject+Mapping.swift
////  SugarRecord
////
////  Created by Pedro Piñera Buendía on 22/10/14.
////  Copyright (c) 2014 SugarRecord. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//extension NSManagedObject: SugarRecordMappingProtocol {
//   
//    public typealias MappingObjectType = NSManagedObject
//    
//    public class func defaultMapper() -> SugarRecordMapper {
//        // Abstract method, each object should implement its own
//        return SugarRecordMapper(inferMapping: true, attributeNotFound: nil)
//    }
//    
//    public class func map(#objects: [[String: NSObject]], completion: (() -> ())?)
//    {
//        SugarRecord.operation(inBackground: true, stackType: SugarRecordStackType.SugarRecordStackTypeCoreData) { (context) -> () in
//            context.beginWriting()
//            _ =  NSManagedObject.map(objects: objects, inContext: context)
//            context.endWriting()
//            if completion != nil {
//                completion!()
//            }
//        }
//    }
//    
//    public class func map(#objects: [[String: NSObject]], inContext context: SugarRecordContext) -> [MappingObjectType]
//    {
//        return NSManagedObject.map(objects: objects, inContext: context, withMapper: self.defaultMapper())
//    }
//    
//    public class func map(#objects: [[String: NSObject]], inContext context: SugarRecordContext, withMapper mapper: SugarRecordMapper) -> [MappingObjectType]
//    {
//        var createdObjects: [MappingObjectType] = [MappingObjectType]()
//        for objectDictionary in objects {
//            let object: MappingObjectType = self.map(object: objectDictionary, inContext: context, withMapper: mapper)
//            createdObjects.append(object)
//        }
//        return createdObjects
//    }
//    
//    public class func map(#object: [String: NSObject], completion: (() -> ())?)
//    {
//        SugarRecord.operation(inBackground: true, stackType: SugarRecordStackType.SugarRecordStackTypeCoreData) { (context) -> () in
//            context.beginWriting()
//            _ = self.map(object: object, inContext: context)
//            context.endWriting()
//            if completion != nil {
//                completion!()
//            }
//        }
//    }
//    
//    public class func map(#object: [String: NSObject], inContext context: SugarRecordContext) -> MappingObjectType
//
//    {
//        return self.map(object: object, inContext: context, withMapper: self.defaultMapper())
//    }
//    
//    public class func map(#object: [String: NSObject], inContext context: SugarRecordContext, withMapper mapper: SugarRecordMapper) -> MappingObjectType
//    {
//        let outputObject: MappingObjectType = self.create(inContext: context) as MappingObjectType
//        
//        let classAttributes: [String] = [String]()
//        
//        
//        
//        return outputObject
//    }
//    
//    public func map(#attribute: SugarRecordMappingAttribute, object: [String: NSObject])
//    {
//        
//    }
//}
//
