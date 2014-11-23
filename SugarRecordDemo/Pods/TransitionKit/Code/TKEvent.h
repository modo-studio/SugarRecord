//
//  TKEvent.h
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

#import <Foundation/Foundation.h>

@class TKState, TKStateMachine;

/**
 The `TKEvent` class describes an event within a state machine that causes a transition between states. Each event has a descriptive name and specifies the state that the machine will transition into after the event has been fired. Events can optionally be constrained to a set of source states that the machine must be in for the event to fire.
 */
@interface TKEvent : NSObject <NSCoding, NSCopying>

///------------------------
/// @name Creating an Event
///------------------------

/**
 Creates and returns a new event object with the given name, source states, and destination state.
 
 @param name The name for the event.
 @param sourceStates An array of `TKState` objects specifying the source states that the machine must be in for the event to be permitted to fire.
 @param destinationState The state that the state machine will transition into after the event has fired.
 @return A newly created event object.
 */
+ (instancetype)eventWithName:(NSString *)name transitioningFromStates:(NSArray *)sourceStates toState:(TKState *)destinationState;

///------------------------------
/// @name Accessing Event Details
///------------------------------

@property (nonatomic, copy, readonly) NSString *name;

/**
 An optional array of states that the state machine must be in before the event is allowed to fire.
 
 If `nil`, then the event can be fired when the state machine is in any state.
 */
@property (nonatomic, copy, readonly) NSArray *sourceStates;

/**
 The state that the state machine will transition into after the event has fired.
 
 Cannot be `nil`.
 */
@property (nonatomic, strong, readonly) TKState *destinationState;

///------------------------------
/// @name Setting Callback Blocks
///------------------------------

/**
 Sets a block to be executed in order to determines if an event should be fired. If the block returns `YES`, then the event will be permitted to fire.
 
 @param block The block to be executed to determine if the event can be fired. The block has a Boolean return value and accepts two arguments: the event that is being evaluated to determine if it can be fired and the state machine that the event belongs to. If the block returns `YES`, then the event can be fired.
 */
- (void)setShouldFireEventBlock:(BOOL (^)(TKEvent *event, TKStateMachine *stateMachine))block;

/**
 Sets a block to be executed before an event is fired, while the state machine is still in the source state.
 
 @param block The block to be executed. The block has no return value and accepts two arguments: the event that is about to be fired and the state machine that the event belongs to.
 */
- (void)setWillFireEventBlock:(void (^)(TKEvent *event, TKStateMachine *stateMachine))block;

/**
 Sets a block to be executed after an event is fired, when the state machine has transitioned into the destination state.
 
 @param block The block to be executed. The block has no return value and accepts two arguments: the event that has just been fired and the state machine that the event belongs to.
 */
- (void)setDidFireEventBlock:(void (^)(TKEvent *event, TKStateMachine *stateMachine))block;

@end
