## Changelog

### 3.0.0-alpha.1
- Swift 3.0 support.
- Swift 2.3 support dropped.
- Carthage support.

### 2.3.0
- Add Danger.
- Remove Carthage support.
- Bump Realm version to 1.0.2.
- Update Fastlane setup.

### Version 2.2.7
- Add Observable feature https://github.com/pepibumur/SugarRecord/pull/243
- Fix a CoreDataStorage `journal_mode` property not set properly.

### Version 2.2.5
- Updated Carthage Quick/Nimble dependencies

### Version 2.2.4
- Improve error throwing in operations https://github.com/pepibumur/SugarRecord/issues/222

### Version 2.1.6
- Implemented example project.
- Fixed a bug with the CoreDataDefaultStorage that didn't persist the changes.

### Version 2.1.4
- Integrated with Travis-CI

### Version 2.1.3
- Added initializer to RealmDefaultStorage that takes a Realm.Configuration as initializer.

### Version 2.1.2
- First version giving support to [RxSwift](https://github.com/ReactiveX/RxSwift)
- Fixed broken unit tests after the refactor for Carthage for having `SugarRecordCoreData` and `SugarRecordRealm`

### Version 2.1.1
- Added [Realm 0.97](https://realm.io/news/realm-objc-swift-0.97.0/) version. That version includes:
  - Support for tvOS. You can use now SugarRecord+Realm with your tvOS.
  - Better integration with Carthage. Installing SugarRecord+Realm should be faster now.
- Improved Carthage integration. Now each platform has two schemes, `SugarRecordRealm` & `SugarRecordCoreData`. Drag only the one you need in your app plus Realm in case you are using the Realm integration.


### Version 2.1.0
**Date:** 13th December 2015<br>
**Changelog**
- Removed `Result` dependency from context methods. Methods `throw` now instead of returning a `Result` object wrapping Error and Values.
- Reviewed the interface of Context to make it similar to [Realm's one](https://realm.io/docs/swift/latest/): `add`, `create`, `new`, `fetch`, `remove`.
- Removed asynchrony from from `operation` methods in storage. Asynchrony has to be handled externally now *(Realm inspired)*.
- Added `LICENSE` file.
- Added `fetch` method to `Storage` using internally the main context for fetching.
- Implemented a **Reactive** API in Storage:
```swift
func rac_operation(operation: (context: Context, save: Saver) -> Void) -> SignalProducer<Void, NoError>
func rac_backgroundOperation(operation: (context: Context, save: Saver) -> Void) -> SignalProducer<Void, NoError>
func rac_backgroundFetch<T, U>(request: Request<T>, mapper: T -> U) -> SignalProducer<[U], Error>
func rac_fetch<T>(request: Request<T>) -> SignalProducer<[T], Error>
```

### Version 2.0.0
**Date:** 8th December 2015 <br>
**Changelog**
- New version with Swift 2.XX support.
- New API.
- Test coverage of core features.
- Realm and CoreData support.
- [Carthage](https://github.com/carthage) and [CocoaPods](https://cocoapods.org) support
