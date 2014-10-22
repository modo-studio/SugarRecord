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
    
    /**
    Closure used by the mapper if any attribute hasn't been found.
    
    :param: notFoundAttribute Not found attribute
    
    :returns: Alternative attribute to try
    */
    public typealias AttributeNotFound = (notFoundAttribute: SugarRecordMappingAttribute) -> (SugarRecordMappingAttribute)
    
    /// Excuted when any of the attributes hasn't been found
    var attributeNotFoundClosure: AttributeNotFound?
    
    /**
    Constructors
    */
    
    /**
    Initializes the Mapper passing the infer mapping property and the closure to be executed in case of attribute not found
    
    :param: inferMapping      Bool indicating if the mapping has to be inferred if the attribute is not found
    :param: attributeNotFound Closure to execute in case of an attribute hasn't been found
    
    :returns: Initialized mapper
    */
    public init(inferMapping: Bool, attributeNotFound: AttributeNotFound?)
    {
        self.inferMappingAttributes = inferMapping
        self.attributeNotFoundClosure = attributeNotFound
    }
    
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
    Returns the attribute associated to the remote key
    Note: If the attribute is not found, it'll be inferred if it's set in the mapper
    
    :param: key String with the remote key
    
    :returns: Mapping attribute
    */
    mutating func attribute(forRemoteKey key: String) -> SugarRecordMappingAttribute?
    {
        let fileteredAttributes: [SugarRecordMappingAttribute] = attributes.filter({attr in
            return attr.remoteKey() == key
        })
        if fileteredAttributes.count != 0 {
            return fileteredAttributes.first!
        }
        else if self.inferMappingAttributes {
            return SugarRecordMappingAttribute.SimpleAttribute(localKey: key, remoteKey: key)
        }
        return nil
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