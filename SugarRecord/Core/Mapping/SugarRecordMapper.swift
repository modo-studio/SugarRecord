//
//  SugarRecordMapper.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 19/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public struct SugarRecordMapper
{
    //MARK: - Properties
    
    /// Contains the attributes that the mapper should use
    internal lazy var attributes: [SugarRecordMappingAttribute] = [SugarRecordMappingAttribute]()
    
    /// Bool that indicates if the attributes that are not recognized should be inferred automatically
    public var inferMappingAttributes: Bool = false
    
    
    typealias AttributeNotFound = (attribue: SugarRecordMappingAttribute)
    
    
    //MARK: - Attributes
    
    /**
    Add an attribute to the attributes list
    
    :param: attribute Attribute to be added
    
    :returns: If the attribute has been successfuly added
    */
    mutating func addAttribute(attribute: SugarRecordMappingAttribute) -> Bool
    {
        let alreadyAdded: Bool = isAttributeAlreadyAdded(attribute)
        if (alreadyAdded) { return false }
        self.attributes.append(attribute)
        return true
    }
    
    /**
    Returns if the attribute has already been added to the list
    
    :param: attribute Attribute to be checked
    
    :returns: Bool indicating if the attribute is already in the list
    */
    mutating func isAttributeAlreadyAdded(attribute: SugarRecordMappingAttribute) -> Bool
    {
        return attributes.filter({attr in
            return attribute == attr
        }).count != 0
    }
    
}