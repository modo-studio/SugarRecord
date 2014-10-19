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
    
    /**
    *  It contains all the attributes for the mapper
    */
    internal lazy var attributes: [SugarRecordMappingAttribute] = [SugarRecordMappingAttribute]()
    
    
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
    
    
    mutating func isAttributeAlreadyAdded(attribute: SugarRecordMappingAttribute) -> Bool
    {
        return attributes.filter({attr in
            retu
        }).count != 0
    }
    
}