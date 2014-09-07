//
//  NSManagedObject+SugarRecordTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Quick
import SugarRecord
import Nimble
import CoreData

class NSManagedObjectSugarRecordTests: QuickSpec {
    override func spec() {
        beforeSuite {}
        afterSuite {}
        
        // PENDING TO BE TESTED BUT...
        // - If you add the extension to the target the compilation fails
        // - You cannot make the protocol public to be seen by other targets
        // Solution is pending... Will Apple change it?
    }
}
