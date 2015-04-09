# <center>![xcres](/resources/Slogan.png)</center>
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/SugarRecord/SugarRecord?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


[![Twitter: @pepibumur](https://img.shields.io/badge/contact-@pepibumur-blue.svg?style=flat)](https://twitter.com/pepibumur)
[![Language: Swift](https://img.shields.io/badge/lang-Swift-yellow.svg?style=flat)](https://developer.apple.com/swift/)
[![Build Status](https://travis-ci.org/SugarRecord/SugarRecord.svg?branch=develop)](https://travis-ci.org/SugarRecord/SugarRecord)
[![Language: Swift](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://opensource.org/licenses/MIT)
[![Issues](https://img.shields.io/github/issues/sugarrecord/sugarrecord.svg?style=flat
)](https://github.com/SugarRecord/SugarRecord/issues?state=open)
[![Forks](https://img.shields.io/github/forks/sugarrecord/sugarrecord.svg?style=flat
)](https://github.com/SugarRecord/SugarRecord/network)
[![Stars](https://img.shields.io/github/stars/sugarrecord/sugarrecord.svg?style=flat
)](https://github.com/SugarRecord/SugarRecord)

## What is SugarRecord?
SugarRecord is a data management library designed to make working with **CoreData** and **Realm** simpler. Thanks to SugarRecord you’ll be able to use **CoreData/Realm** with just a few lines of code:

1. Choose your preferred stack from the provided stacks (_you can also implement your own!_)
2. Enjoy how easy database operations are with our library

The library is completely written in Swift and is fully tested to ensure the behavior is as expected.

**NOTE: We have a Google Group where you can leave your questions, doubts, suggestions, and other comments [here]. We also have a blog where we’ll post about the library’s development which you can check out [here].**

**The library was started by [@pepibumur](http://www.twitter.com/pepibumur) and is now maintained by [@dchavezlive](https://twitter.come/dchavezlive)**

## Features

- Support for Realm and CoreData using same syntax
- Multiple stacks (for Realm, CoreData, CoreData+iCloud)
- Simple and modern syntax, forget about complicated lines of code to fetch your last 20 users!
- Written 100% in Swift and compatible with Swift projects
- Compatible with OSX and iOS
- Fully documented with a playground tutorial and an updated Wiki page
- Fully tested (all components are tested using XCTest)
- Actively supported, issues covered in less than a week.
- More powerful features to discover!

## Components

![image](https://raw.githubusercontent.com/SugarRecord/SugarRecord/develop/Resources/scheme.png)
The scheme above shows the structure of SugarRecord. It's formed by:
- **Database Models Extensions**: Adds our custom syntax that links these models with SugarRecord and the database.
- **Finder**: SugarRecord custom element to abstract the querying components from the type of storage (Realm or CoreData)
- **Core**: Main component of the library that translates Save/Delete/Find calls into the appropriate internal operations for the stack.
- **SugarRecord contexts**: Although Realm doesn't have contexts as we have in CoreData, we have created abstracted contexts that surround the user operations with models independently of which stack you’re using. Yeah!
- **Stack**: The storage stack is another key piece in SugarRecord because it knows how and when to persist/fetch/delete your objects into the database. You can tell SugarRecord which stack it should use.

## Mailing list

If you want to stay updated we have a mailing list. We'll send emails with new updates, features, important bugs fixed, ...

[![image](https://cdn0.iconfinder.com/data/icons/flat-designed-circle-icon/128/mail.png)](http://eepurl.com/57tqX)

## Updates

| **Date**               | **Done**                     |
|-------------------------------|------------------------------------------------|
| 8th-January-2015 | Fixed Travis-CI Integration |
| 8th-January-2015 | Finally added CocoaPods support and updated the Wiki |
| 3st-January-2015 | Solved issue https://github.com/SugarRecord/SugarRecord/issues/101 |
| 29th-December-2014 | Version 1.0.5 released |
| 29th-December-2014 | Separated SugarRecordResults Logic https://github.com/SugarRecord/SugarRecord/issues/98|
| 25th-December-2014 | Version 1.0.4 released |
| 25th-December-2014 | Added Realm example |
| 25th-December-2014 | Added a continuous integration local script |
| 25th-December-2014 | Updated Realm to 0.89 |
| 25th-December-2014 | Setup SugaRecord.podspec file |

## Index
- [Features](#features)
- [Versions](#versions)
- [Version 1.0.7 [WIP]](#version-1.0.7-[WIP])
- [Version 1.0.6](#version-1.0.6)
- [Version 1.0.5](#version-1.0.5)
- [Version 1.0.4](#version-1.0.4)
- [Requirements](#requirements)
- [Wiki](#wiki)
- [Support](#support)
- [Useful Swift Resources](#useful-swift-resources)
- [License](#license)
- [Who uses SugarRecord?](#who-uses-sugarrecord?)

## Features

- For beginners and advanced users
- **Fully customizable**. Implement your own stack and set it as your SugarRecord stack to work with.
- **Friendly syntax**. Forget about NSPredicates and NSSortDescriptors
- You can change between different stacks without affecting to the rest of your app.
- In case of a transition from CoreData to Realm or viceversa you've only to ensure the objecs have the same property names, and nothing more.
- Background operations are automatically managed by Sugar Record
- Support for Realm and CoreData using the same syntax
- Multiple stacks (for Realm, CoreData, CoreData+iCloud)
- Sugar syntax, forget about complicated lines of code to fetch your last 20 users!
- Written 100% in Swift and compatible with Swift projects (in case of Objective-C a wrapper is needed)
- Compatible with OSX and iOS
- Fully documented with a playground tutorial and an updated Wiki page
- Fully tested (all components are tested using XCTest)
- Actively supported, issues covered in less than a week.
- More powerful features to discover!

## Versions
### Version 1.0.7 [WIP]

### Version 1.0.6
- Fixed autosaving feature on DefaultCDStack
- Use of printable instead of StringLiteralConvertible
- Reviewed the CI script (still not working travis :( )

### Version 1.0.5
- Fixed a regression introduced with 1.0.4 that caused users having to import Realm/CoreData even if they were using another database technology https://github.com/SugarRecord/SugarRecord/pull/99

### Version 1.0.4
- Updated the project structure and added easy setup steps (without CocoaPods)
- Added example project
- Added high performance count method
- Added SugarRecordResults type for results (inspired on RLMResults)

## Requirements

- Xcode 6
- iOS 7.0+ / Mac OS X 10.9+
- If you have troubles with the compilation try to clean the DerivedData Xcode directory: `rm -rf ~/Library/Developer/Xcode/DerivedData/`


## Wiki

If you want to know about how to use SugarRecord we have some Wiki pages in the repo to guide you through the integration in your project. Availble Wiki pages are:

- About SugarRecord: [Link](https://github.com/SugarRecord/SugarRecord/wiki/SugarRecord)
- Setup SugarRecord: [Link](https://github.com/SugarRecord/SugarRecord/wiki/Setup-SugarRecord)
- Working with Stacks: [Link](https://github.com/SugarRecord/SugarRecord/wiki/Working-with-Stacks)
- Operations: [Link](https://github.com/SugarRecord/SugarRecord/wiki/Operations)
- Advanced operations with SugarRecord: [Link](https://github.com/SugarRecord/SugarRecord/wiki/Advanced-operations-with-SugarRecord)
- Mapping models: [Link](https://github.com/SugarRecord/SugarRecord/wiki/Mapping-models)
- Advices: [Link](https://github.com/SugarRecord/SugarRecord/wiki/Advices)
- Contribution tips: [Link](https://github.com/SugarRecord/SugarRecord/wiki/Contribution-tips)

## Support

If you want to communicate any issue, suggestion or even make a contribution, you have to keep in mind the flow bellow:

- If you **need help**, ask your doubt in Stack Overflow using the tag 'sugarrecord'
- If you want to ask something in general, use Stack Overflow too.
- **Open an issue** either when you have an error to report or a feature request.
- If you want to **contribute**, submit a pull request, and remember the rules to follow related with the code style, testing, ...


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

## Donations
SugarRecord is almost completely the work of one man: me; Pedro Pinñera. I thoroughly enjoyed making SugarRecord, but nevertheless if you have found it useful then your bitcoin will give me a warm fuzzy feeling from my head right down to my toes
<a class="coinbase-button" data-code="1ec3e63d01a2bda96275e24a81c478c6" data-button-style="custom_large" href="https://www.coinbase.com/checkouts/1ec3e63d01a2bda96275e24a81c478c6">Donate Bitcoins</a><script src="https://www.coinbase.com/assets/button.js" type="text/javascript"></script>
