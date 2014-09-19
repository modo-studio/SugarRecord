//
//  SugarRecord+Operations.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

extension SugarRecord {
    
    public class func operation(closure: (context: SugarRecordContext) -> ())
    {
        SugarRecord.operation(inBackground: false, closure: closure)
    }
    
    public class func operation(inBackground background: Bool, closure: (context: SugarRecordContext) -> ())
    {
        if background {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                closure(context: SugarRecord.stack().backgroundContext())
            })
        }
        else {
            closure(context: SugarRecord.stack().mainThreadContext())
        }
    }
}