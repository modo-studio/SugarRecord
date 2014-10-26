//
//  NSManagedObject+Mapping.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 22/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject: SugarRecordMappingProtocol {
   
    public typealias MappingObjectType = NSManagedObject
    
    public class func defaultMapper() -> SugarRecordMapper {
        // Abstract method, each object should implement its own
        return SugarRecordMapper(inferMapping: true, attributeNotFound: nil)
    }
    
    public class func map(#objects: [[String: NSObject]], completion: (() -> ())?)
    {
        SugarRecord.operation(inBackground: true, stackType: SugarRecordStackType.SugarRecordStackTypeCoreData) { (context) -> () in
            context.beginWriting()
            _ =  NSManagedObject.map(objects: objects, inContext: context)
            context.endWriting()
            if completion != nil {
                completion!()
            }
        }
    }
    
    public class func map(#objects: [[String: NSObject]], inContext context: SugarRecordContext) -> [MappingObjectType]
    {
        return NSManagedObject.map(objects: objects, inContext: context, withMapper: self.defaultMapper())
    }
    
    public class func map(#objects: [[String: NSObject]], inContext context: SugarRecordContext, withMapper mapper: SugarRecordMapper) -> [MappingObjectType]
    {
        SugarRecordLogger.logLevelVerbose.log("Mapping \(objects.count) objects")
        var createdObjects: [MappingObjectType] = [MappingObjectType]()
        for objectDictionary in objects {
            let object: MappingObjectType? = self.map(object: objectDictionary, inContext: context, withMapper: mapper)
            if object == nil { continue }
            createdObjects.append(object!)
        }
        return createdObjects
    }
    
    public class func map(#object: [String: NSObject], completion: (() -> ())?)
    {
        SugarRecord.operation(inBackground: true, stackType: SugarRecordStackType.SugarRecordStackTypeCoreData) { (context) -> () in
            context.beginWriting()
            _ = self.map(object: object, inContext: context)
            context.endWriting()
            if completion != nil {
                completion!()
            }
        }
    }
    
    public class func map(#object: [String: NSObject], inContext context: SugarRecordContext) -> MappingObjectType?

    {
        return self.map(object: object, inContext: context, withMapper: self.defaultMapper())
    }
    
    public class func map(#object: [String: NSObject], inContext context: SugarRecordContext, withMapper mapper: SugarRecordMapper) -> MappingObjectType?
    {
        let outputObject: MappingObjectType = self.create(inContext: context) as MappingObjectType
        let entityDescription: NSEntityDescription? = NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: (context as SugarRecordCDContext).contextCD)
        if entityDescription == nil  {
            SugarRecordLogger.logLevelError.log("Entity with name \(self.entityName()) not found during import")
            return nil
        }
        for key: String in object.keys {
            outputObject.map(key: key, object: object, withMapper: mapper, entityDescription: entityDescription!)
        }
        return outputObject
    }
    
    
    //MARK: - Helper Methods
    
    internal func attribute(byName name:String, entityDescription: NSEntityDescription) -> NSAttributeDescription?
    {
        let attributes: [NSObject: NSAttributeDescription] = entityDescription.attributesByName as [NSObject: NSAttributeDescription]
        return attributes[name]
    }
    
    internal func relationship(byName name: String, entityDescription: NSEntityDescription) -> NSRelationshipDescription?
    {
        let relationships: [NSObject: NSRelationshipDescription] = entityDescription.relationshipsByName as [NSObject: NSRelationshipDescription]
        return relationships[name]
    }
    
    internal func map(#key: String, object: [String: NSObject], var withMapper mapper: SugarRecordMapper, entityDescription: NSEntityDescription)
    {
        // Getting the MapingAttribute
        let mappingAttribute: SugarRecordMappingAttribute? = mapper.attribute(forRemoteKey: key)
        if mappingAttribute == nil { return }
        
        // Getting the Local Attribute/Relationship
        let attributeDescription: NSAttributeDescription? = attribute(byName: mappingAttribute!.localKey(), entityDescription: entityDescription)
        let relationshipDescription: NSRelationshipDescription? = relationship(byName: mappingAttribute!.localKey(), entityDescription: entityDescription)
        if ( attributeDescription == nil && relationshipDescription == nil) { return }
        
        if attributeDescription != nil {
            self.map(attribute: attributeDescription!, mappingAttribute: mappingAttribute!, object: object, withMapper: mapper)
        }
        else {
            self.map(relationship: relationshipDescription!, mappingAttribute: mappingAttribute!, object: object, withMapper: mapper)
        }
    }
    
    internal func map(#attribute: NSAttributeDescription, mappingAttribute: SugarRecordMappingAttribute, object: [String: NSObject], var withMapper mapper: SugarRecordMapper)
    {
        let value: NSObject = object[mappingAttribute.remoteKey()]!
        
        switch (attribute.attributeType) {
        case .Integer16AttributeType, .Integer32AttributeType, .Integer64AttributeType:
            // Value as NSNumber
            if (value as? NSNumber != nil) {
                
            }
        case .DecimalAttributeType:
            // Value as NSNumber
            if (value as? NSNumber != nil) {
                
            }
        case .DoubleAttributeType:
            // Value as NSNumber
            if (value as? NSNumber != nil) {
                
            }
        case .FloatAttributeType:
            // Value as NSNumber
            if (value as? NSNumber != nil) {
                self.setValue((value as? NSNumber)!.floatValue, forKey: mappingAttribute.localKey())
            }
        case .StringAttributeType:
            // Value as String
            if (value as? String != nil) {
                self.setValue((value as? String)!, forKey: mappingAttribute.localKey())
            }
            // Value as NSString
            else if (value as? NSString != nil) {
                self.setValue((value as? NSString)!, forKey: mappingAttribute.localKey())
            }
        case .BooleanAttributeType:
            // Value as NSNumber
            if (value as? NSNumber != nil) {
                self.setValue((value as? NSNumber)!.boolValue, forKey: mappingAttribute.localKey())
            }
        case .DateAttributeType:
            // Value as a NSDate
            if (value as? NSDate != nil) {
                self.setValue(value as? NSDate, forKey: mappingAttribute.localKey())
            }
            // Value as Timestamp
            else if (value as? NSNumber != nil) {
                let timeStamp: Int = (value as? NSNumber)!.longValue
                self.setValue(NSDate(timeIntervalSince1970: NSTimeInterval(timeStamp)), forKey: mappingAttribute.localKey())
            }
        case .UndefinedAttributeType, .BinaryDataAttributeType, .TransformableAttributeType, .ObjectIDAttributeType:
            return
        }
        /*
        * Steps
        * 1) Read mappingAttribute property of the attribute (
        attributeValueClassName too)
        * 2) Check that the mapping attribute is single value
        * 3) Set the value with set property
        */
        
        /*
enum NSAttributeType : UInt {
case UndefinedAttributeType
case Integer16AttributeType
case Integer32AttributeType
case Integer64AttributeType
case DecimalAttributeType
case DoubleAttributeType
case FloatAttributeType
case StringAttributeType
case BooleanAttributeType
case DateAttributeType
case BinaryDataAttributeType
case TransformableAttributeType
case ObjectIDAttributeType
}*/
    }

    internal func map(#relationship: NSRelationshipDescription, mappingAttribute: SugarRecordMappingAttribute, object: [String: NSObject], var withMapper mapper: SugarRecordMapper)
    {
        //TODO
        /*
        Interesting properties of NSRelationshipDescription
        - destinationEntity: Returns NSEntityDescription of the receiver destination
        - minCount: Returns the minimum count
        - maxCount: Returns the maximum count
        - toMany: Bool that indicates if the relation is to many
        */
    }
}

