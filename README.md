![image](https://raw.githubusercontent.com/SugarRecord/SugarRecord/feature/version10/Resources/Slogan.png)

## What is SugarRecord?
SugarRecord is a management library to make it easier work with **CoreData and REALM**. Thanks to SugarRecord you'll be able to start working with **CoreData/REALM** with just a few lines of code:

1. Choose your preferred stack among the available ones (*You can even propose your own!*)
2. Enjoy with your database operations

The library is completetly written in Swift and fully tested to ensure the behaviour is the expected one.

**There's a Google Group where you can leave your topics, question, doubts, suggestions and stuff besides issues https://groups.google.com/forum/#!forum/sugarrecord**

**Powered by [@pepibumur](http://www.twitter.com/pepibumur)**

## Index
- [Advantages of SugarRecord](#advantages-of-sugarrecord)
- [Version 1.0 - Features](#planned-for-1.0-release)
- [Requirements](#requirements)
- [Installation](#installation)
- [How to use SugarRecord](#how-to-use-sugarrecord)
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

## Version 1.0 Beta - Features

- 100% **Unit Test** Coverage
- Complete **Documentation** in CocoaDocs and tutorials made with Playgrounds
- Fully redesigned structure based on stacks 
- **REALM support**
- Fully detailed steps to **integrate all components in your project** (*while waiting the integration of CocoaPods*)
- CI with https://github.com/modcloth-labs/github-xcode-bot-builder

*Note: It's going to suppose a big step to SugarRecord because it's going to make it more flexible for all kind of developers. You can use the current initial version of SugarRecord 0.2 (master branch).*

## Requirements

- Xcode 6
- iOS 7.0+ / Mac OS X 10.9+
- If you have troubles with the compilation try to clean the DerivedData Xcode directory: `rm -rf ~/Library/Developer/Xcode/DerivedData/`

## Installation

Cocoapods doesn't support support Swift libraries yet so the instalation process has to be manual. To import SugarRecord into your project:

1. Drag the folder SugarRecord into your project traget.
2. SugarRecord folder has a folder for every storage technology. Leave only these that you're going to use in your app (e.g. `CoreData` or `Realm`)
3. Enjoy using it

*Note: As soon as CocoaPod supports it the library will have a pod to make this process easier for everybody*


## How to use SugarRecord
If you want to learn how to setup SugarRecord with the stack and stack working with it, the library comes with an useful Playground HTML file with steps and some examples to follow. Take a look to the playground [**HERE**](https://github.com/SugarRecord/SugarRecord/docs/tutorial.playground).

Otherwise if you want to have a quick idea of how working with SugarRecord is, take a look to the examples below:

```swift
// Setting the stack
SugarRecord.addStack(DefaultREALMStack(stackName: "RealmTest", stackDescription: "Realm stack for tests"))

// Creating object
var person: Person = Person.create() as Person
person.name = "Realmy"
person.age = 22
let saved: Bool = person.save()

// Object finding
let people: [Person]? = Person.sorted(by:"name", ascending: true).firsts(10).find()?
let person: Person? = Person().find()?.first as Person
let people: [Person]? = Person("age", equalTo: "10").sorted(by:"name", ascending: true).find()?
let people: [Person]? = Person.all().find()?

// Deleting the object
let deleted: Bool = (Person.all().find()?.first()? as Person).delete



//NOTE: It doesn't matter if you're using CoreData or REALM, the syntax you use to work with these objects is the same!
```

### SugarRecord stacks

One of the main advantages of using SugarRecord is its big flexibility to choose the storage architecture you want for your app. SugarRecord comes with some default stacks for Realm and CoreData but you can implement your own ensuring it conforms the needed protocols (*take a look to the existing ones*). The available stacks are:

- **Default Core Data Stack**: This stack has a private context with the unique persistent store coordinator as parent. There is a main context under it to execute low load operations and a private one at the same level as the main one to execute high load operations. Changes  performed in that private context are brought to the main context using KVO.
- **Default REALM Stack**: This  stack provides a setup for REALM which is much easier than Core Data, no context, thread safe...
- **Default Core Data Stack + iCloud**: IN PROGRESS
- **Default Core Data Stack + Restkit**: IN PROGRESS

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
If you are currently using SugarRecord in your app, let me know and I'll add it to the list:

## Contribute
SugarRecord is provided free of charge. If you want to support it:

- You can report your issues directly through Github repo issues page. I'll try to fix them as soon as possible and listen your suggestion about how to improve the library.
- You can post your doubts in StackOverFlow too. I'll be subscribed to updates in StackOverFlow related to SugarRecord tag.
- We are opened to new PR introducing features to the implementation of fixing bugs in code. We can make SugarRecord even more sugar than it's right know. Contribute with it :smile:
