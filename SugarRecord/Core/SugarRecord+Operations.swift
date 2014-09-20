//
//  SugarRecord+Operations.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation

extension SugarRecord {
    
    /**
    Executes an operation closure in the main thread
    
    :param: closure Closure with operations to be executed
    */
    public class func operation(closure: (context: SugarRecordContext) -> ())
    {
        SugarRecord.operation(inBackground: false, closure: closure)
    }
    
    /**
    Executes an operation closure passing it the context to perform operations
    
    :param: background Bool indicating if the operation is in background or not
    :param: closure    Closure with actions to be executed
    */
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