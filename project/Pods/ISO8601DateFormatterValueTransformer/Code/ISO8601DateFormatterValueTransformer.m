//
//  ISO8601DateFormatterValueTransformer.m
//  RestKit
//
//  Created by Blake Watters on 9/11/13.
//  Copyright (c) 2013 RestKit. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "ISO8601DateFormatterValueTransformer.h"

@implementation RKISO8601DateFormatter (RKValueTransformers)

+ (instancetype)defaultISO8601DateFormatter
{
    RKISO8601DateFormatter *iso8601DateFormatter = [RKISO8601DateFormatter new];
    iso8601DateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    iso8601DateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    iso8601DateFormatter.includeTime = YES;
    iso8601DateFormatter.parsesStrictly = YES;
    return iso8601DateFormatter;
}

- (BOOL)validateTransformationFromClass:(Class)inputValueClass toClass:(Class)outputValueClass
{
    return (([inputValueClass isSubclassOfClass:[NSDate class]] && [outputValueClass isSubclassOfClass:[NSString class]]) ||
            ([inputValueClass isSubclassOfClass:[NSString class]] && [outputValueClass isSubclassOfClass:[NSDate class]]));
}

- (BOOL)transformValue:(id)inputValue toValue:(id *)outputValue ofClass:(Class)outputValueClass error:(NSError **)error
{
    RKValueTransformerTestInputValueIsKindOfClass(inputValue, (@[ [NSString class], [NSDate class] ]), error);
    RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputValueClass, (@[ [NSString class], [NSDate class] ]), error);
    if ([inputValue isKindOfClass:[NSString class]]) {
        NSString *errorDescription = nil;
        BOOL success = [self getObjectValue:outputValue forString:inputValue errorDescription:&errorDescription];
        RKValueTransformerTestTransformation(success, error, @"%@", errorDescription);
    } else if ([inputValue isKindOfClass:[NSDate class]]) {
        *outputValue = [self stringFromDate:inputValue];
    }
    return YES;
}

@end
