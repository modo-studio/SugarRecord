//
//  NSManagedObject+Import.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject: SugarRecordObjectImportProtocol
{
    class func mapAttributes(#remoteObject: JSON, localObject: SugarRecordObjectProtocol, mappingModel: MappingModel)
    {
        
    }
    
    class func mapRelationships(#remoteObject: JSON, localObject: SugarRecordObjectProtocol, mappingModel: MappingModel, cache: [String: [String: AnyObject]])
    {
        
    }
    
    class func importFrom(object: JSON, inContext context: SugarRecordContext, scheme: MappingScheme?) -> SugarRecordObjectProtocol?
    {
        return nil
    }
    
    class func importFrom(array: JSON, inContext context: SugarRecordContext, scheme: MappingScheme?) -> [SugarRecordObjectProtocol]
    {
        return []
    }
}



class TestModel : NSManagedObject, SugarRecordObjectMappingProtocol {
    
    var name: String = "hola"
    var user: String = "user"
    
    class func mappingModel() -> MappingModel {
        
        let myClass2 = String.self
        var mapModel = MappingModel()
            .add("name", objectType: self)
            .add("user", objectType: self)
        
        
        return mapModel
    }
}

