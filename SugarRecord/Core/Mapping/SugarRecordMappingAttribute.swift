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
    
    
    public func ==(lhs: Self, rhs: Self) -> Bool
    {
        return true
    }
}