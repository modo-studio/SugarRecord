//
//  SugarRecordMappableProtocol.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public protocol SugarRecordMappableProtocol
{
    /**
    *  Returns the default object mapper
    */
    class func defaultMapper() -> SugarRecordMapper
}