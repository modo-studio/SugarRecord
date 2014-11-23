//
//  TKState.h
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

@class TKStateMachine;

/**
 The `TKState` class defines a particular state with a state machine. Each state must have a unique name within the state machine in which it is used.
 */
@interface TKState : NSObject <NSCoding, NSCopying>

///-----------------------
/// @name Creating a State
///-----------------------

/**
 Creates and returns a new state object with the specified name.
 
 @param name The name of the state. Cannot be blank.
 @return A newly created state object with the specified name.
 */
+ (instancetype)stateWithName:(NSString *)name;

///------------------------------------
/// @name Accessing the Name of a State
///------------------------------------

/**
 The name of the receiver. Cannot be `nil` and must be unique within the state machine that the receiver is added to.
 */
@property (nonatomic, copy, readonly) NSString *name;

///----------------------------------
/// @name Configuring Block Callbacks
///----------------------------------

/**
 Sets a block to be executed before the state machine transitions into the state modeled by the receiver.
 
 @param block The block to executed before a state machine enters the receiver's state. The block has no return value and takes two arguments: the state object and the state machine that will transition into the receiver's state.
 */
- (void)setWillEnterStateBlock:(void (^)(TKState *state, TKStateMachine *stateMachine))block;

/**
 Sets a block to be executed after the state machine has transitioned into the state modeled by the receiver.
 
 @param block The block to executed after a state machine enters the receiver's state. The block has no return value and takes two arguments: the state object and the state machine that transitioned into the receiver's state.
 */
- (void)setDidEnterStateBlock:(void (^)(TKState *state, TKStateMachine *stateMachine))block;

/**
 Sets a block to be executed before the state machine transitions out of the state modeled by the receiver.
 
 @param block The block to executed before a state machine exits the receiver's state. The block has no return value and takes two arguments: the state object and the state machine that will transition out of the receiver's state.
 */
- (void)setWillExitStateBlock:(void (^)(TKState *state, TKStateMachine *stateMachine))block;

/**
 Sets a block to be executed after the state machine has transitioned out of the state modeled by the receiver.
 
 @param block The block to executed after a state machine exit the receiver's state. The block has no return value and takes two arguments: the state object and the state machine that transitioned out of the receiver's state.
 */
- (void)setDidExitStateBlock:(void (^)(TKState *state, TKStateMachine *stateMachine))block;

@end
