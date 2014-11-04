//
//  SugarRecordMappingAttribute.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 19/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public enum SugarRecordMappingAttribute: Equatable
{
    case SimpleAttribute(localKey: String, remoteKey: String)
    case OneToOneRelationship(localKey: String, remoteKey: String, isIDRelation: Bool)
    case OneToManyRelationship(localKey: String, remoteKey: String, isIDRelation: Bool)
    case IdentifierAttribute(localKey: String, remoteKey: String)
    
    public func remoteKey() -> String
    {
        var key: String
        switch(self) {
        case .SimpleAttribute(let localKey, let remoteKey):
            key = remoteKey
        case .OneToOneRelationship(let localKey, let remoteKey, let isIDRelation):
            key = remoteKey
        case .OneToManyRelationship(let localKey, let remoteKey, let isIDRelation):
            key = remoteKey
        case .IdentifierAttribute(let localKey, let remoteKey):
            key = remoteKey
        }
        return key
    }
    
    public func localKey() -> String
    {
        var key: String
        switch(self) {
        case .SimpleAttribute(let localKey, let remoteKey):
            key = localKey
        case .OneToOneRelationship(let localKey, let remoteKey, let isIDRelation):
            key = localKey
        case .OneToManyRelationship(let localKey, let remoteKey, let isIDRelation):
            key = localKey
        case .IdentifierAttribute(let localKey, let remoteKey):
            key = localKey
        }
        return key
    }
}

public func ==(lhs: SugarRecordMappingAttribute, rhs: SugarRecordMappingAttribute) -> Bool
{
    var leftLocalKey: String = lhs.localKey()
    var leftRemoteKey: String = lhs.remoteKey()
    var rightLocalKey: String = rhs.localKey()
    var rightRemoteKey: String = rhs.remoteKey()
    return (rightLocalKey == leftLocalKey) || (rightRemoteKey == leftRemoteKey)
}