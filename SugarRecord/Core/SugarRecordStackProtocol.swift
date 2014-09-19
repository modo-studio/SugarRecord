//
//  SugarRecordStackProtocol.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

public protocol SugarRecordStackProtocol
{
    var name: String { get }
    var stackDescription: String { get }
    func initialize()
    func removeDatabase()
    func cleanup()
    func applicationWillResignActive()
    func applicationWillTerminate()
    func applicationWillEnterForeground()
    func backgroundContext() -> SugarRecordContext // Ensure synchronized access
    func mainThreadContext() -> SugarRecordContext
}