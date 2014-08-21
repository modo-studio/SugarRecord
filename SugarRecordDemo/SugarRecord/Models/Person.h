//
//  Person.h
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 15/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * age;

@end
