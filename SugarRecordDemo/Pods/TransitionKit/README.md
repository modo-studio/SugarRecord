TransitionKit
=============

[![Build Status](https://travis-ci.org/blakewatters/TransitionKit.png?branch=master,development)](https://travis-ci.org/blakewatters/TransitionKit)

**A simple, elegantly designed block based API for implementing State Machines in Objective-C**

TransitionKit is a small Cocoa library that provides an API for implementing a state machine in Objective C. It is full-featured, completely documented, and very thoroughly unit tested. State machines are a great way to manage complexity in your application and TransitionKit provides you with a great way to take advantage of a state machine in your next iOS or Mac OS X application.

### Features

* Supports an arbitrary number of States and Events.
* States and Events support a thorough set of block based callbacks for responding to state transitions.
* States, Events, and State Machines are NSCopying and NSCoding compliant, enabling easy integration with archiving and copying in your custom classes.
* Strongly enforced. The state machine includes numerous runtime checks for misconfigurations, making it easy to debug and trust your state machines.
* Completely Documented. The entire library is marked up with Appledoc.
* Thorougly unit tested. You know it works and can make changes with confidence.
* Lightweight. TransitionKit has no dependencies beyond the Foundation library and works on iOS and Mac OS X.

## Installation via CocoaPods

The recommended approach for installing TransitionKit is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation. For best results, it is recommended that you install via CocoaPods **>= 0.16.0** using Git **>= 1.8.0** installed via Homebrew.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project, and Create and Edit your Podfile and add TransitionKit:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
platform :ios, '5.0' 
# Or platform :osx, '10.7'
pod 'TransitionKit', '~> 1.0.0'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

## Examples

#### Simple Example

The following example is a simple state machine that models the state of a Message in an Inbox.

```objc
TKStateMachine *inboxStateMachine = [TKStateMachine new];

TKState *unread = [TKState stateWithName:@"Unread"];
[unread setDidEnterStateBlock:^(TKState *state, TKStateMachine *stateMachine) {
    [self incrementUnreadCount];
}];
TKState *read = [TKState stateWithName:@"Read"];
[read setDidExitStateBlock:^(TKState *state, TKStateMachine *stateMachine) {
    [self decrementUnreadCount];
}];
TKState *deleted = [TKState stateWithName:@"Deleted"];
[deleted setDidEnterStateBlock:^(TKState *state, TKStateMachine *stateMachine) {
    [self moveMessageToTrash];
}];

[inboxStateMachine addStatesFromArry:@[ unread, read, deleted ]];
inboxStateMachine.initialState = unread;

TKEvent *viewMessage = [TKEvent eventWithName:@"View Message" transitioningFromStates:@[ unread ] toState:read];
TKEvent *deleteMessage = [TKEvent eventWithName:@"Delete Message" transitioningFromStates:@[ read, unread ] toState:deleted];
TKEvent *markAsUnread = [TKEvent eventWithName:@"Mark as Unread" transitioningFromStates:@[ read, deleted ] toState:unread];

[inboxStateMachine addEventsFromArray:@[ viewMessage, deleteMessage, markAsUnread ]];

// Activate the state machine
[inboxStateMachine activate];

[inboxStateMachine isInState:@"Unread"]; // YES, the initial state

// Fire some events
NSError *error = nil;
BOOL success = [inboxStateMachine fireEvent:@"View Message" error:&error]; // YES
success = [inboxStateMachine fireEvent:@"Delete Message" error:&error]; // YES
success = [inboxStateMachine fireEvent:@"Mark as Unread" error:&error]; // YES

success = [inboxStateMachine canFireEvent:@"Mark as Unread"]; // NO

// Error. Cannot mark an Unread message as Unread
success = [inboxStateMachine fireEvent:@"Mark as Unread" error:&error]; // NO

// error is an TKInvalidTransitionError with a descriptive error message and failure reason
```

## Unit Tests

TransitionKit is tested using the [Kiwi](https://github.com/allending/Kiwi) BDD library. In order to run the tests, you must do the following:

1. Install the dependencies via CocoaPods: `pod install`
1. Open the workspace: `open TransitionKit.xcworkspace`
1. Run the specs via the **Product** menu > **Test**

## Contact

Blake Watters

- http://github.com/blakewatters
- http://twitter.com/blakewatters
- blakewatters@gmail.com

## License

TransitionKit is available under the Apache 2 License. See the LICENSE file for more info.
