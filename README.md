# <center>![xcres](/Resources/Slogan.png)</center>
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/SugarRecord/SugarRecord?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


[![Twitter: @pepibumur](https://img.shields.io/badge/contact-@pepibumur-blue.svg?style=flat)](https://twitter.com/pepibumur)
[![Language: Swift](https://img.shields.io/badge/lang-Swift-yellow.svg?style=flat)](https://developer.apple.com/swift/)
[![Build Status](https://travis-ci.org/SugarRecord/SugarRecord.svg?branch=develop)](https://travis-ci.org/SugarRecord/SugarRecord)
[![Language: Swift](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://opensource.org/licenses/MIT)

## What is SugarRecord?
SugarRecord is a management library to make it easier work with **CoreData and REALM**. Thanks to SugarRecord you'll be able to start working with **CoreData/REALM** with just a few lines of code:

1. Choose your preferred stack among the available ones (*You can even propose your own!*)
2. Enjoy with your database operations

The library is completetly written in Swift and fully tested to ensure the behaviour is the expected one.

**There's a Google Group where you can leave your topics, question, doubts, suggestions and stuff besides issues https://groups.google.com/forum/#!forum/sugarrecord .**

**Moreover we have a blog to talk about the library, check it here: [http://www.sugarrecord.com/](http://www.sugarrecord.com)**

**Powered by [@pepibumur](http://www.twitter.com/pepibumur)**

![image](https://raw.githubusercontent.com/SugarRecord/SugarRecord/develop/Resources/scheme.png)
The scheme above shows the structure of SugarRecord. It's formed by:
- **Database Models Extensions**: To add the sugar syntax that links these models with SugarRecord and the database.
- **Finder**: SugarRecord custom element to abstract the querying components from the type of storage (Realm or CoreData)
- **Core**: Main component of the library that translates Save/Delete/Find calls into internal operations using the stacks set.
- **SugarRecord contexts**: Altough Realm doesn't have contexts as we have in CoreData, we have created abstracted contexts that surround the user operations with models independently if you are using CoreData or Realm. Yeah!
- **Stack**: The storage stack is another key piece in SugarRecord because it knows how and when persist/fetch/delete your objects into the database. You can tell SugarRecord which stack it should use.

## Mailing list

If you want to stay updated we have a mailing list. We'll send emails with new updates, features, important bugs fixed, ...

[![image](https://cdn0.iconfinder.com/data/icons/flat-designed-circle-icon/128/mail.png)](http://eepurl.com/57tqX)

## Updates

| **Date**               | **Done**                     |
|-------------------------------|------------------------------------------------|
| 16th-October-2014 | Finished stack for iCloud [PR](https://github.com/SugarRecord/SugarRecord/pull/45) |
| 6th-October-2014 | Added FetchedResultsController support [PR](https://github.com/SugarRecord/SugarRecord/pull/40) |
| 5th-October-2014 | Writen a post about custom operators, [POST](http://sugarrecord.com/swift/features/2014/10/05/bringing-custom-operators-onboard.html) |
| 5th-October-2014 | Added custom operators |
| 5th-October-2014 | Created playground tutorial |
| 5th-October-2014 | Added count methods [PR](https://github.com/SugarRecord/SugarRecord/pull/38) |
| 4th-October-2014 | Added migrations support [Pull Request](https://github.com/SugarRecord/SugarRecord/pull/36) |
| 30th-September-2014 | Added first post to the new blog [SugarRecord](http://sugarrecord.com/) |



## Index
- [Advantages of SugarRecord](#advantages-of-sugarrecord)
- [Version 1.0.1 Beta - Features](#version-1.0.1-beta---features)
- [Version 1.0 Beta - Features](#version-1.0-beta---features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Communication flow](#communication-flow)
- [How to use SugarRecord](#how-to-use-sugarrecord)
  - [Initialize SugarRecord with a stack](#initialize-sugarrecord-with-a-stack)
  - [Setup the log level](#setup-the-log-level)
  - [Objects creation](#objects-creation)
  - [Objects edition](#objects-edition)
  - [Objects deletion](#objects-deletion)
  - [Objects querying](#objects-querying)
  - [Advanced options](#advanced-options)
  - [SugarRecord stacks](#sugarrecord-stacks)
    - [Contribute](#contribute)
- [Keep in mind](#keep-in-mind)
- [Contribution tips](#contribution-tips)
  - [Documentation](#documentation)
  - [Setup the project locally](#setup-the-project-locally)
  - [Take into account for your PR proposals](#take-into-account-for-your-pr-proposals)
- [Useful Swift Resources](#useful-swift-resources)
- [License](#license)
- [Who uses SugarRecord?](#who-uses-sugarrecord?)
- [Contribute](#contribute)

## Advantages of SugarRecord

- For beginners and advanced users
- **Fully customizable**. Implement your own stack and set it as your SugarRecord stack to work with.
- **Friendly syntax**. Forget about NSPredicates and NSSortDescriptors
- You can change between different stacks without affecting to the rest of your app.
- In case of a transition from CoreData to Realm or viceversa you've only to ensure the objecs have the same property names, and nothing more.
- Background operations are automatically managed by Sugar Record

## Version 1.0.2 Beta - Features
- Updated the project structure to package the libary in bundles


## Version 1.0.1 Beta - Features
- Playground tutorial to learn how to use SugaRecord
- **Migrations** support
- **Count** methods
```swift
CoreDataObject.all().count()
```
- Swift custom **operators**
```swift
var person = context <- Person.self // Object creation in a given context
var person = Person.self++ // Object creation in the default context
Person.self += person // Object saving
Person.self -= person // Object deletion
```
- **FetchedResultsController** support
```swift
CoreDataObject.all().fetchedResultsController("name")
```
- Stack for **iCloud**

## Version 1.0 Beta - Features

- 100% **Unit Test** Coverage
- Complete **Documentation** in CocoaDocs and tutorials made with Playgrounds
- Fully redesigned structure based on stacks 
- **REALM support**
- Fully detailed steps to **integrate all components in your project** (*while waiting the integration of CocoaPods*)

*Note: It's going to suppose a big step to SugarRecord because it's going to make it more flexible for all kind of developers. You can use the current initial version of SugarRecord 0.2 (master branch).*

## Coming features
- Abstract FetchedResultsController to use with Realm and CoreData
- Integration with iCloud
- Support to migrations
- High-Performance data import

## Requirements

- Xcode 6
- iOS 7.0+ / Mac OS X 10.9+
- If you have troubles with the compilation try to clean the DerivedData Xcode directory: `rm -rf ~/Library/Developer/Xcode/DerivedData/`

## Installation

Cocoapods doesn't support support Swift libraries yet so the instalation process has to be manual. To import SugarRecord into your project:

1. Download the project into your project's libraries folder. You can use git submodules too `git submodule add https://github.com/sugarrecord/sugarrecord myproject/libraries`
2. Once you have the


*Note: As soon as CocoaPod supports it the library will have a pod to make this process easier for everybody*

## Communication flow

If you want to communicate any issue, suggestion or even make a contribution, you have to keep in mind the flow bellow:

- If you **need help**, ask your doubt in Stack Overflow using the tag 'sugarrecord'
- If you want to ask something in general, use Stack Overflow too.
- **Open an issue** either when you have an error to report or a feature request.
- If you want to **contribute**, submit a pull request, and remember the rules to follow related with the code style, testing, ...

## How to use SugarRecord
If you want to learn how to setup SugarRecord with the stack and stack working with it, the library comes with an useful Playground HTML file with steps and some examples to follow. Take a look to the playground [**HERE**](https://github.com/SugarRecord/SugarRecord/docs/tutorial.playground).

Otherwise if you want to have a quick idea of how working with SugarRecord is, take a look to the examples below.

### Initialize SugarRecord with a stack
SugarRecord needs you to pass the stack you are going to work with. There are some stacks availables to use directly but you can implement your own regarding your needs. Keep in mind that it's important to set it because otherwise SugarRecord won't have a way communicate your models with the database. Take a look how it would be using the default stack of Realm and CoreData:

```Swift
// Example initializing SugarRecord with the default Realm 
SugarRecord.addStack(DefaultREALMStack(stackName: "MyDatabase", stackDescription: "My database using the lovely library SugarRecord"))

// Example initializing SugarRecord with the default CoreData stack
let stack: DefaultCDStack = DefaultCDStack(databaseName: "Database.sqlite", automigrating: true)
SugarRecord.addStack(stack)
```
Once you have the stack set, a connection between SugarRecord and your app's lifecycle is required in order to execute cleaning and saving internal tasks. Ensure you have the following calls in your app delegate:

```swift
func applicationWillResignActive(application: UIApplication!) {
  SugarRecord.applicationWillResignActive()
}

func applicationWillEnterForeground(application: UIApplication!) {
  SugarRecord.applicationWillEnterForeground()
}

func applicationWillTerminate(application: UIApplication!) {
  SugarRecord.applicationWillTerminate()
}
```

### Setup the log level

By default the log level of the library is `Info`. If you want to change it you can do it with:
```swift
SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelVerbose
```

### Objects creation

ManagedObjects and RLMObjects have extensions to make the creation easier. Methods included there are connected with SugarRecord and the stacks you previously setup. The example below shows the creation of an user without mattering if it's a RLMObject OR A CoreData object
```swift
var user: User = User.create() as User
user.name = "Testy"
user.age = 21
let saved: Bool = user.save()
```
### Objects edition

To edit your objects you have to notify SugarRecord that you are going to start/end an edition. If you are going to edit only one object you can do it quickly with the methods `beginWriting()` and `endWriting() `. It's very important to tell SugarRecord about any edition or you app might crash. Take a look to the example below

```swift
user.beginWriting()
user.name ="Pepito"
user.endWriting()
```
If you are editing different objects that are in the same Sugar Record context it's recommended to call `beginWriting()` before starting editing any of them. Once you've finished the edition call `endWriting()`.

### Objects deletion

If you want to delete an object that you have in a SugarRecord context you can do it easily using the method `delete()`. **It's very important** to call `beginWriting()` and `endWriting()` here too to notify the library about the changes you are making. Take a look to the examples below:

```swift
// 3-Lines syntax
user.beginWriting()
user.delete()
user.endWriting()

// 1-Line syntax
user.beginWriting().delete().endWriting()
```

### Objects querying

Fetching elements had never been so easy as it's now with SugarRecord. Take a look to the examples below because they are self-explaining:

```swift
let users: [User]? = User.sorted(by:"name", ascending: true).firsts(10).find()?
users: User? = User().find()?.first as Person
users: [User]? = User("age", equalTo: "10").sorted(by:"name", ascending: true).find()?
users: [User]? = User.all().find()?
```
The example above is valid for **Realm** and **Objective-C**

### Advanced options

Although we've tried to offer an easy API interface for beginners we have advanced options too to go further into lower layers of the library. SugarRecord offers operations closures connected with your stacks to work directly with these context and decide then when and how saving them.

```swift
SugarRecord.operation(SugarRecordStackType.SugarRecordStackTypeRealm, closure: { (context) -> () in
  users: [User]? = User.all().find(inContext: context)?
  context.beginWriting() // <- Notifying we're starting the edition
  for user in users {
    user.age++
  }
  context.endWriting() // <- Notifying that we've finished the edition
})
```

### SugarRecord stacks

One of the main advantages of using SugarRecord is its big flexibility to choose the storage architecture you want for your app. SugarRecord comes with some default stacks for Realm and CoreData but you can implement your own ensuring it conforms the needed protocols (*take a look to the existing ones*). The available stacks are:

- **Default Core Data Stack**: This stack has a private context with the unique persistent store coordinator as parent. There is a main context under it to execute low load operations and a private one at the same level as the main one to execute high load operations. Changes  performed in that private context are brought to the main context using KVO.
- **Default REALM Stack**: This  stack provides a setup for REALM which is much easier than Core Data, no context, thread safe...
- **Default Core Data Stack + iCloud**: With the stack of iCloud you'll be able to persist your users' data in iCloud easily. Initialize the stack and leave SugarRecord do the rest.
- **Default Core Data Stack + Restkit**: It connects thd default CoreData stack with RestKit to enjoy the powerful features of that library.

#### Contribute
If you have any other idea of stack that could be useful for SugarRecord users feel free to make your proposal. Ensure:

1. That it conforms the protocol `SugarRecordStackProtocol`
2. That it's **fully tested** and **docummented**

## Keep in mind
- Be careful **working with objects between contexts**. In case of **CoreData** remember that a ManagedObject belongs to a given context. Once the context dies the object disappears and trying to access to it will bring you into a trouble. SugarRecord has defensive code to ensure that if you are saving objecs from one context in other one one they are automatically brought to the new context to be saved there.

- **Not referencing objects**. Try to use their remote or local identifiers instead. Strong references is something dangerous because you can break the normal behaviour of CoreData/REALM. In CoreData for example it might cause **fault relationship** crashes although your propagation rules are properly defined.


## Contribution tips
### Documentation
- The best way to follow the docummentation patterns is using the plugin for XCode VVDocumenter.
- SugarRecord uses [**Swift-playground-builder**](https://github.com/jas/swift-playground-builder) to generate a playground tutorial from a markdonw file, . If you have done any important change that deserves an explanation in the tutorial add it!. To do it:
```bash
# Install Node.js
npm install -g swift-playground-builder
playground docs/tutorial.md -d docs/ -p ios
```
- Library documentation is generated by CocoaDocs automatically based on the code comments. If you want to preview it locally:

```bash
# Clone the repo
git clone https://github.com/CocoaPods/cocoadocs.org
# Run in the repo directory
bundle install
# Preview the library with
bundle exec ./cocoadocs.rb preview SugarRecord
```


### Setup the project locally
1. Clone the repo with `git clone https://github.com/SugarRecord/SugarRecord.git`
2. Update the git submodules with `git submodule update --init`

### Take into account for your PR proposals

- Changes in the library should be properly documented and tested, **changes without documentation comments and tests won't be accepted**
- The code should follow this style guideline: https://github.com/SugarRecord/swift-style-guide



## Useful Swift Resources
- **Tests with Swift (Matt)**: http://nshipster.com/xctestcase/
- **Quick**, a library for testing written in swift https://github.com/modocache/personal-fork-of-Quick
- **CoreData and threads with GCD**: http://www.cimgf.com/2011/05/04/core-data-and-threads-without-the-headache/
- **Alamofire**, the swift AFNetworking: https://github.com/Alamofire/Alamofire
- **Jazzy**, a library to generate documentation: https://github.com/realm/jazzy
- How to **document your project**: http://www.raywenderlich.com/66395/documenting-in-xcode-with-headerdoc-tutorial
- Tests interesting articles: http://www.objc.io/issue-15/
- **iCloud + CoreData** (objc.io): http://www.objc.io/issue-10/icloud-core-data.html
- **Appledoc**, documentation generator: https://github.com/tomaz/appledoc 
- **AlecrimCoreData**: https://github.com/Alecrim/AlecrimCoreData

## License
The MIT License (MIT)

Copyright (c) <2014> <Pedro Piñera>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Who uses SugarRecord?
If you are currently using SugarRecord in your app, let me know and I'll add it to the list.
