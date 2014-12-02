//
//  TKTransition.h
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

@class TKEvent, TKState, TKStateMachine;

/**
 The `TKTransition` class models a state change in response to an event firing within a state machine. It encapsulates all details about the change and is yielded as an argument to all block callbacks within TransitionKit. The optional dictionary of `userInfo` can be used to broadcast arbitrary data across callbacks.
 */
@interface TKTransition : NSObject

///----------------------------
/// @name Creating a Transition
///----------------------------

/**
 Creates and returns a new transition object describing a state change occuring within a state machine in response to the firing of an event.

 @param event The event being fired that is causing the transition to occur.
 @param sourceState The state of the machine when the event was fired.
 @param stateMachine The state machine in which the transition is occurirng.
 @param userInfo An optional dictionary of user info supplied with the event when it was fired.
 */
+ (instancetype)transitionForEvent:(TKEvent *)event fromState:(TKState *)sourceState inStateMachine:(TKStateMachine *)stateMachine userInfo:(NSDictionary *)userInfo;

///-----------------------------------
/// @name Accessing Transition Details
///-----------------------------------

/**
 The event that was fired, causing the transition to occur.
 */
@property (nonatomic, strong, readonly) TKEvent *event;

/**
 The state of the state machine when the transition starts.
 */
@property (nonatomic, strong, readonly) TKState *sourceState;

/**
 The state of the state machine after the transition finishes.
 */
@property (nonatomic, strong, readonly) TKState *destinationState;

/**
 The state machine in which the transition is occurring.
 */
@property (nonatomic, strong, readonly) TKStateMachine *stateMachine;

/**
 An optional dictionary of user info supplied with the event when fired.
 */
@property (nonatomic, copy, readonly) NSDictionary *userInfo;

@end
