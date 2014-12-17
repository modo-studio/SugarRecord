//
//  RLMObject+SugarRecordObjectImportProtocol.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 15/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

extension RLMObject: SugarRecordObjectImportProtocol
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