# <center>![xcres](https://github.com/gitdoapp/SugarRecord/raw/version2/Assets/Banner.png)</center>

# SugarRecord

[![Twitter: @pepibumur](https://img.shields.io/badge/contact-@pepibumur-blue.svg?style=flat)](https://twitter.com/pepibumur)
[![Language: Swift](https://img.shields.io/badge/lang-Swift-yellow.svg?style=flat)](https://developer.apple.com/swift/)
[![Language: Swift](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/gitdoapp/SugarRecord.svg?branch=version2)](https://travis-ci.org/gitdoapp/SugarRecord)
[![Slack Status](https://sugarrecord-slack.herokuapp.com/badge.svg)](https://sugarrecord-slack.herokuapp.com)

**If you want to receive updates about the status of SugarRecord, you can subscribe to our mailing list [here](http://eepurl.com/57tqX)**

## What is SugarRecord?
SugarRecord is a persistence wrapper designed to make working with persistence solutions like CoreData/Realm/... in a much easier way. Thanks to SugarRecord you'll be able to use CoreData with just a few lines of code: Just choose your stack and start playing with your data.

The library is maintained by [@pepibumur](https://github.com/pepibumur) under [GitDo](https://github.com/gitdoapp). You can reach me at [pedro@gitdo.io](mailto://pedro@gitdo.io) for help or whatever you need to commend about the library.

## Features
- Swift 2.1 compatible (XCode 7.1).
- Fully rewritten from the version 1.0.
- Reactive API (using ReactiveCocoa).
- Protocols based design.
- For **beginners** and **advanced** users
- Fully customizable. Build your own stack!
- Friendly syntax (fluent)
- Away from Singleton patterns! No shared states :tada:
- Compatible with OSX/iOS/watchOS/tvOS
- Fully tested (thanks Nimble and Quick)
- Actively supported

## Setup

### Using Cocoapods

1. Install [CocoaPods](https://cocoapods.org). You can do it with `gem install cocoapods`
2. Edit your `Podfile` file and add the following line `pod 'SugarRecord'
3. Update your pods with the command `pod install`
4. Open the project from the generated workspace (`.xcworkspace` file).

*Note: You can also test the last commits by specifying it directly in the Podfile line*

### Using Carthage
1. Install [Carthage](https://github.com/carthage/carthage) on your computer using `brew install carthage`
3. Edit your `Cartfile` file adding the following line `github 'gitdoapp/sugarrecord'`
4. Update and build frameworks with `carthage update`
5. Add generated frameworks to your app main target following the steps [here](https://github.com/carthage/carthage)
6. Link your target with **CoreData** library *(from Build Phases)*

## Version 2.0 Checklist :white_check_mark:
- [ ] Development
 - [ ] CoreDataDefaultStorage tests
 - [ ] Request fluent interface
- [ ] Documentation (Jazzy): *Make sure all the components are documented*
- [ ] Create Contribution document
  - Make tasks
  - Style guideline
  - Unit testing

## Features backlog
- [ ] Reactive API
- [ ] Logging support

## Reference
You can check the SugarRecord documentation [here](http://blog.gitdo.io/SugarRecord/). Thanks [**Jazzy**](https://github.com/realm/jazzy) for that powerful tool for generating documentation :tada:

## Support

If you want to communicate any issue, suggestion or even make a contribution, you have to keep in mind the flow bellow:

- If you need help, ask your doubt in Stack Overflow using the tag 'sugarrecord'
- If you want to ask something in general, use Stack Overflow too.
- Open an issue either when you have an error to report or a feature request.
- If you want to contribute, submit a pull request, and remember the rules to follow related with the code style, testing, ...

## Contribution
- You'll find more details about contribution with SugarRecord in [contribution](CONTRIBUTION.md)

## Resources
- [Quick](https://github.com/quick/quick)
- [Nimble](https://github.com/quick/nimble)
- [CoreData and threads with GCD](http://www.cimgf.com/2011/05/04/core-data-and-threads-without-the-headache/)
- [Jazzy](https://github.com/realm/jazzy)
- [iCloud + CoreData (objc.io)](http://www.objc.io/issue-10/icloud-core-data.html)


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
Are you using SugarRecord? Let us know, and we'll list you here. We :heart: to hear about companies, apps that are using us with CoreData.
