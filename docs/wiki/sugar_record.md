## SugarRecord
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

**Stared by [@pepibumur](http://www.twitter.com/pepibumur)**

## Features

- Support for Realm and CoreData using the same syntax
- Multiple stacks (for Realm, CoreData, CoreData+iCloud)
- Sugar syntax, forget about complicated lines of code to fetch your last 20 users!
- Written 100% in Swift and compatible with Swift projects (in case of Objective-C a wrapper is needed)
- Compatible with OSX and iOS
- Fully documented with a playground tutorial and an updated Wiki page
- Fully tested (all components are tested using XCTest)
- Actively supported, issues covered in less than a week.
- More powerful features to discover!

## Components

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

## Versions

### Version 1.0.2 Beta - Features
- Updated the project structure to package the libary in bundles
- Added `cancelWriting()` feature
- Filled the Wiki page of the project
- Added autoSaving property for CoreData stacks

### Version 1.0.1 Beta - Features
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

### Version 1.0 Beta - Features

- 100% **Unit Test** Coverage
- Complete **Documentation** in CocoaDocs and tutorials made with Playgrounds
- Fully redesigned structure based on stacks 
- **REALM support**
- Fully detailed steps to **integrate all components in your project** (*while waiting the integration of CocoaPods*)

*Note: It's going to suppose a big step to SugarRecord because it's going to make it more flexible for all kind of developers. You can use the current initial version of SugarRecord 0.2 (master branch).*