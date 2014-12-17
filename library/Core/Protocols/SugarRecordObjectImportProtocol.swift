//
//  SugarRecordObjectImportProtocol.swift
//  SugarRecord
//
//  Created by Isaac Roldán Armengol on 11/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation


protocol SugarRecordObjectImportProtocol
{
	class func mapAttributes(#remoteObject: JSON, localObject: SugarRecordObjectProtocol, mappingModel: MappingModel)
	class func mapRelationships(#remoteObject: JSON, localObject: SugarRecordObjectProtocol, mappingModel: MappingModel, cache: [String: [String: AnyObject]])
	class func importFrom(object: JSON, inContext context: SugarRecordContext, scheme: MappingScheme?) -> SugarRecordObjectProtocol?
	class func importFrom(array: JSON, inContext context: SugarRecordContext, scheme: MappingScheme?) -> [SugarRecordObjectProtocol]
}

protocol SugarRecordObjectMappingProtocol
{
	//class func mappingModel(scheme: MappingScheme?) -> MappingModel
    class func mappingModel() -> MappingModel
}

enum MappingScheme
{
	case scheme(name: String)
}

enum MappingAttributeType
{
	case simpleAttribute, identiferAttribute
	case relationshipAttribute(Bool, Any) // Check if dest conforms SugarRecordObjectProtocol
}

struct MappingAttribute
{
	let localKey: String?
	let remoteKey: String?
	let type: MappingAttributeType?
	let attributeClass: Any?
}

class MappingModel
{
	var mappingAttributes: [MappingAttribute] = []

    func prefetchRelationships() -> ([MappingAttribute])
    {
        return []
    }
    
    func simpleRelationships() -> ([MappingAttribute])
    {
        return []
    }
    
    func attributes() -> ([MappingAttribute])
    {
        return []
    }
    
    func relationships() -> ([MappingAttribute])
    {
        return []
    }

    func add(attribute: String, objectType: AnyClass) -> MappingModel
    {
        let newAttribute = MappingAttribute(localKey: attribute, remoteKey: attribute, type: MappingAttributeType.simpleAttribute, attributeClass: objectType)
		mappingAttributes.append(newAttribute)
        return self
	}
    
    func add(attribute: String, remoteKey: String, objectType: AnyClass) -> MappingModel
    {
        let newAttribute = MappingAttribute(localKey: attribute, remoteKey: remoteKey, type: MappingAttributeType.simpleAttribute, attributeClass: objectType)
        mappingAttributes.append(newAttribute)
        return self
    }
    
    func add(relationship: String, prefetch: Bool, objectType: AnyClass, destinationType: AnyClass) -> MappingModel
    {
        let newAttribute = MappingAttribute(localKey: relationship, remoteKey: relationship, type: MappingAttributeType.relationshipAttribute(prefetch, destinationType), attributeClass: objectType)
        mappingAttributes.append(newAttribute)
        return self
    }
    
    func add(relationship: String, remoteKey: String, prefetch:Bool, objectType: AnyClass, destinationType: AnyClass) -> MappingModel
    {
        let newAttribute = MappingAttribute(localKey: relationship, remoteKey: remoteKey, type: MappingAttributeType.relationshipAttribute(prefetch, destinationType), attributeClass: objectType)
        mappingAttributes.append(newAttribute)
        return self
    }
}



// Project.by(NSPredicate(...)).find() as [Project]


// return MappingModel.builder().
// add("name").
// add("project", )


// Cache : [RemoteKey: [String: Anyobject]]


// Caching steps
// 1) Import array
// 2) Create cache
// 	2.1) Find prefetch attributes
//	2.2) Find common objects in the JSON file
//	2.3) Fetch common objects
// 3) Map attributes
// 4) Map relationships (with cache)

// Pass mappingModel in method
