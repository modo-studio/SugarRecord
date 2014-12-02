//
//  TKStateMachine.h
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

@class TKEvent, TKState;

/**
 The `TKStateMachine` class provides an interface for modeling a state machine. The state machine supports the registration of an arbitrary number of states and events that trigger transitions between the states.
 
 ## Callback Sequence
 
 When a state machine is activated, the following callbacks are invoked:
 
 1. Initial State: willEnterState - The block set with `setWillEnterStateBlock:` on the `initialState` is invoked.
 1. The `currentState` changes from `nil` to `initialState`
 1. Initial State: didEnterState - The block set with `setDidEnterStateBlock:` on the `initialState` is invoked.
 
 Each time an event is fired, the following callbacks are invoked:
 
 1. Event: shouldFireEvent - The block set with `setShouldFireEventBlock:` on the event being fired is consulted to determine if the event can be fired. If `NO` is returned then the event is declined and no further callbacks are invoked
 1. Event: willFireEvent - The block set with `setWillFireEventBlock:` on the event being fired is invoked.
 1. Old State: willExitState - The block set with `setWillExitStateBlock:` on the outgoing state is invoked.
 1. New State: willEnterState - The block set with `setWillEnterStateBlock:` on the incoming state is invoked.
 1. The `currentState` changes from the old state to the new state.
 1. Old State: didExitState - The block set with `setDidExitStateBlock:` on the old state is invoked.
 1. New State: didEnterState - The block set with `setDidEnterStateBlock:` on the new current state is invoked.
 1. Event: didFireEvent - The block set with `setDidFireEventBlock:` on the event being fired is invoked.
 1. Notification: After the event has completed and all block callbacks 
 
 ## Copying and Serialization Support
 
 The `TKStateMachine` class is both `NSCoding` and `NSCopying` compliant. When copied, a new inactive state machine instance is created with the same states, events, and initial state. All blocks associated with the events and states are copied. When archived, the current state, initial state, states, events and activation state is preserved. All block callbacks associated with the states and events become `nil`.
 */
@interface TKStateMachine : NSObject <NSCoding, NSCopying>

///----------------------
/// @name Managing States
///----------------------

/**
 The set of states that have been added to the receiver. Each instance of the set is a `TKState` object.
 */
@property (nonatomic, readonly) NSSet *states;

/**
 The initial state of the receiver.
 
 When the machine is activated, it transitions into the initial state.
 */
@property (nonatomic, strong) TKState *initialState;

/**
 The current state of the receiver.
 
 When the machine is activated, the current state transitions from `nil` to the `initialState`. Subsequent state transitions are trigger by the firing of events.
 
 @see `fireEvent:error:`
 */
@property (nonatomic, strong, readonly) TKState *currentState;

/**
 Adds a state to the receiver.
 
 Before a state can be used in an event, it must be registered with the state machine.
 
 @param state The state to be added.
 @raises TKStateMachineIsImmutableException Raised if an attempt is made to modify the state machine after it has been activated.
 */
- (void)addState:(TKState *)state;

/**
 Adds an array of state objects to the receiver.
 
 This is a convenience method whose implementation is equivalent to the following example code:
 
    for (TKState *state in arrayOfStates) {
        [self addState:state];
    }
 
 @param arrayOfStates An array of `TKState` objects to be added to the receiver.
 */
- (void)addStates:(NSArray *)arrayOfStates;

/**
 Retrieves the state with the given name from the receiver.
 
 @param name The name of the state to retrieve.
 @returns The state object with the given name or `nil` if it could not be found.
 */
- (TKState *)stateNamed:(NSString *)name;

/**
 Returns a Boolean value that indicates if the receiver is in the specified state.
 
 This is a convenience method whose functionality is equivalent to comparing the given state with the `currentState`.
 
 @param stateOrStateName A `TKState` object or an `NSString` object that identifies a state by name. The specified state is compared with the value of the `currentState` property.
 @returns `YES` if the receiver is in the specified state, else `NO`.
 @raises NSInvalidArgumentException Raised if an invalid object is given.
 @raises NSInvalidArgumentException Raised if a string value is given that does not identify a registered state.
 */
- (BOOL)isInState:(id)stateOrStateName;

///----------------------
/// @name Managing Events
///----------------------

/**
 The set of events that have been added to the receiver. Each instance of the set is a `TKEvent` object.
 */
@property (nonatomic, readonly) NSSet *events;

/**
 Adds an event to the receiver.
 
 The state objects references by the event must be registered with the receiver.
 
 @param event The event to be added.
 @raises TKStateMachineIsImmutableException Raised if an attempt is made to modify the state machine after it has been activated.
 @raises NSInternalInconsistencyException Raised if the given event references a `TKState` that has not been registered with the receiver.
 */
- (void)addEvent:(TKEvent *)event;

/**
 Adds an array of event objects to the receiver.
 
 This is a convenience method whose implementation is equivalent to the following example code:
 
    for (TKEvent *event in arrayOfEvents) {
        [self addEvent:event];
    }
 
 @param arrayOfEvents An array of `TKEvent` objects to be added to the receiver.
 */
- (void)addEvents:(NSArray *)arrayOfEvents;

/**
 Retrieves the event with the given name from the receiver.
 
 @param name The name of the event to retrieve.
 @returns The event object with the given name or `nil` if it could not be found.
 */
- (TKEvent *)eventNamed:(NSString *)name;

///-----------------------------------
/// @name Activating the State Machine
///-----------------------------------

/**
 Activates the receiver by making it immutable and transitioning into the initial state.
 
 Once the state machine has been activated no further changes can be made to the registered events and states. Note that although callbacks will be dispatched for transition into the initial state upon activation, they will have a `nil` transition argument as no event has been fired.
 */
- (void)activate;

/**
 Returns a Boolean value that indicates if the receiver has been activated.
 */
- (BOOL)isActive;

///--------------------
/// @name Firing Events
///--------------------

/**
 Returns a Boolean value that indicates if the specified event can be fired.
 
 @param eventOrEventName A `TKEvent` object or an `NSString` object that identifies an event by name. The source states of the specified event is compared with the current state of the receiver. If the `sourceStates` of the event is `nil`, then the event can be fired from any state. If the `sourcesStates` is not `nil`, then the event can only be fired if it includes the `currentState` of the receiver.
 @return `YES` if the event can be fired, else `NO`.
 */
- (BOOL)canFireEvent:(id)eventOrEventName;

/**
 Fires an event to transition the state of the receiver. If the event fails to fire, then `NO` is returned and an error is set.
 
 If the receiver has not yet been activated, then the first event fired will activate it. If the specified transition is not permitted, then `NO` will be returned and an `TKInvalidTransitionError` will be created. If the `shouldFireEventBlock` of the specified event returns `NO`, then the event is declined, `NO` will be returned, and an `TKTransitionDeclinedError` will be created.
 
 @param eventOrEventName A `TKEvent` object or an `NSString` object that identifies an event by name.
 @param userInfo An optional dictionary of user info to be delivered as part of the state transition.
 @param error A pointer to an `NSError` object that will be set if the event fails to fire.
 @return `YES` if the event is fired, else `NO`.
 */
- (BOOL)fireEvent:(id)eventOrEventName userInfo:(NSDictionary *)userInfo error:(NSError **)error;

@end

///----------------
/// @name Constants
///----------------

/**
 The domain for errors raised by TransitionKit.
 */
extern NSString *const TKErrorDomain;

/**
 A Notification posted when the `currentState` of a `TKStateMachine` object changes to a new value.
 */
extern NSString *const TKStateMachineDidChangeStateNotification;

/**
 A key in the `userInfo` dictionary of a `TKStateMachineDidChangeStateNotification` notification specifying the state of the machine before the transition occured.
 */
extern NSString *const TKStateMachineDidChangeStateOldStateUserInfoKey;

/**
 A key in the `userInfo` dictionary of a `TKStateMachineDidChangeStateNotification` notification specifying the state of the machine after the transition occured.
 */
extern NSString *const TKStateMachineDidChangeStateNewStateUserInfoKey;

/**
 A key in the `userInfo` dictionary of a `TKStateMachineDidChangeStateNotification` notification specifying the event that triggered the transition between states.
 */
extern NSString *const TKStateMachineDidChangeStateEventUserInfoKey;

/**
 An exception raised when an attempt is made to mutate an immutable `TKStateMachine` object.
 */
extern NSString *const TKStateMachineIsImmutableException;

/**
 Error Codes
 */
typedef enum {
    TKInvalidTransitionError    =   1000,   // An invalid transition was attempted.
    TKTransitionDeclinedError   =   1001,   // The transition was declined by the `shouldFireEvent` guard block.
} TKErrorCode;
