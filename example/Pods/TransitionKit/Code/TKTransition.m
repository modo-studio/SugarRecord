//
//  TKTransition.m
//  TransitionKit
//
//  Created by Blake Watters on 10/11/13.
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

#import "TKTransition.h"
#import "TKEvent.h"

@interface TKTransition ()

@property (nonatomic, strong, readwrite) TKEvent *event;
@property (nonatomic, strong, readwrite) TKState *sourceState;
@property (nonatomic, strong, readwrite) TKStateMachine *stateMachine;
@property (nonatomic, copy, readwrite) NSDictionary *userInfo;
@end

@implementation TKTransition

+ (instancetype)transitionForEvent:(TKEvent *)event fromState:(TKState *)sourceState inStateMachine:(TKStateMachine *)stateMachine userInfo:(NSDictionary *)userInfo
{
    TKTransition *transition = [self new];
    transition.event = event;
    transition.sourceState = sourceState;
    transition.stateMachine = stateMachine;
    transition.userInfo = userInfo;
    return transition;
}

- (TKState *)destinationState
{
    return self.event.destinationState;
}

@end
