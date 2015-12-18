### Version 2.1.1

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
