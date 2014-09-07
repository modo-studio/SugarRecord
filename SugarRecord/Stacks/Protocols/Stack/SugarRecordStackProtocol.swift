//
//  SugarRecordStackProtocol.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

protocol SugarRecordStackProtocol
{
    var name: String { get }
    var stackDescription: String { get }
    init(stackName:String)
}