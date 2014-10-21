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
}

public func ==(lhs: SugarRecordMappingAttribute, rhs: SugarRecordMappingAttribute) -> Bool
{
    var leftLocalKey: String
    var leftRemoteKey: String
    var rightLocalKey: String
    var rightRemoteKey: String
    
    switch(lhs) {
    case .SimpleAttribute(let localKey, let remoteKey):
        leftLocalKey = localKey
        leftRemoteKey = remoteKey
    case .OneToOneRelationship(let localKey, let remoteKey, let isIDRelation):
        leftLocalKey = localKey
        leftRemoteKey = remoteKey
    case .OneToManyRelationship(let localKey, let remoteKey, let isIDRelation):
        leftLocalKey = localKey
        leftRemoteKey = remoteKey
    case .IdentifierAttribute(let localKey, let remoteKey):
        leftLocalKey = localKey
        leftRemoteKey = remoteKey
    }
    switch(rhs) {
    case .SimpleAttribute(let localKey, let remoteKey):
        rightLocalKey = localKey
        rightRemoteKey = remoteKey
    case .OneToOneRelationship(let localKey, let remoteKey, let isIDRelation):
        rightLocalKey = localKey
        rightRemoteKey = remoteKey
    case .OneToManyRelationship(let localKey, let remoteKey, let isIDRelation):
        rightLocalKey = localKey
        rightRemoteKey = remoteKey
    case .IdentifierAttribute(let localKey, let remoteKey):
        rightLocalKey = localKey
        rightRemoteKey = remoteKey
    }
    
    return (rightLocalKey == leftLocalKey) || (rightRemoteKey == leftRemoteKey)
}