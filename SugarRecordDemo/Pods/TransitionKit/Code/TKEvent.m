//
//  TKEvent.m
//  TransitionKit
//
//  Created by Blake Watters on 3/17/13.
//  Copyright (c) 2013 Blake Watters. All rights reserved.
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

#import "TKEvent.h"
#import "TKState.h"

static NSString *TKDescribeSourceStates(NSArray *states)
{
    if (! [states count]) return @"any state";
    
    NSMutableString *description = [NSMutableString string];
    [states enumerateObjectsUsingBlock:^(TKState *state, NSUInteger idx, BOOL *stop) {
        NSString *separator = @"";
        if (idx < [states count] - 1) separator = (idx == [states count] - 2) ? @" and " : @", ";
        [description appendFormat:@"'%@'%@", state.name, separator];
    }];
    return description;
}


@interface TKEvent ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSArray *sourceStates;
@property (nonatomic, strong, readwrite) TKState *destinationState;
@property (nonatomic, copy) BOOL (^shouldFireEventBlock)(TKEvent *event, TKStateMachine *stateMachine);
@property (nonatomic, copy) void (^willFireEventBlock)(TKEvent *event, TKStateMachine *stateMachine);
@property (nonatomic, copy) void (^didFireEventBlock)(TKEvent *event, TKStateMachine *stateMachine);
@end

@implementation TKEvent

+ (instancetype)eventWithName:(NSString *)name transitioningFromStates:(NSArray *)sourceStates toState:(TKState *)destinationState
{
    if (! [name length]) [NSException raise:NSInvalidArgumentException format:@"The event name cannot be blank."];
    if (!destinationState) [NSException raise:NSInvalidArgumentException format:@"The destination state cannot be nil."];
    TKEvent *event = [self new];
    event.name = name;
    event.sourceStates = sourceStates;
    event.destinationState = destinationState;
    return event;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p '%@' transitions from %@ to '%@'>", NSStringFromClass([self class]), self, self.name, TKDescribeSourceStates(self.sourceStates), self.destinationState.name];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.sourceStates = [aDecoder decodeObjectForKey:@"sourceStates"];
    self.destinationState = [aDecoder decodeObjectForKey:@"destinationState"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sourceStates forKey:@"sourceStates"];
    [aCoder encodeObject:self.destinationState forKey:@"destinationState"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    TKEvent *copiedEvent = [[[self class] allocWithZone:zone] init];
    copiedEvent.name = self.name;
    copiedEvent.sourceStates = self.sourceStates;
    copiedEvent.destinationState = self.destinationState;
    copiedEvent.shouldFireEventBlock = self.shouldFireEventBlock;
    copiedEvent.willFireEventBlock = self.willFireEventBlock;
    copiedEvent.didFireEventBlock = self.didFireEventBlock;
    return copiedEvent;
}

@end
