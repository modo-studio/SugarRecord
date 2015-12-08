Setup
=======

SugarRecord supports integration using the two main dependency managers for Swift/Objectiv-C, [CocoaPods](https://cocoapods.org) and [Carthage](https://github.com/carthage/carthage). Decide which one fits with your project and follow the steps below.

> We recommend you to use the same dependency manager you've used for other dependencies in your project.

## CocoaPods

1. The first think you need is having CocoaPods installed. In case you don't have it you can install it with `gem install cocoapods`
2. Once installed you have to add the following line to your `Podfile`:
```ruby
pod 'SugarRecord', :git => 'https://github.com/gitdoapp/sugarrecord.git'
```
3. Then execute `pod install` and CocoaPods will fetch your dependencies and integrate them with your project using a `Workspace`
4. Open your project using the `.xcworkspace` file.

### Subspecs
If you follow the steps above you'll integrate SugarRecord with all the persistence solutions available. If you want only one of them you can specify thanks to the defined subspecs in the project:

```
pod 'SugarRecord/CoreData', :git => 'https://github.com/gitdoapp/sugarrecord.git'
pod 'SugarRecord/Realm', :git => 'https://github.com/gitdoapp/sugarrecord.git'
```

## Carthage

If you prefer to use `Carthage` the follow these steps:

1. Install Carthage if you didn't have it installed with `brew install carthage`
2. Once completed edit your `Cartfile` and add the dependency:
```ruby
github 'gitdoapp/sugarrecord'
```
3. Execute the command `carthage update` and Carthage will fetch the dependency and compile them under `/Carthage/Build`
4. Follow the steps [here](https://github.com/carthage/carthage) to add this compiled frameworks into your project.

### Platforms
SugarRecord is available for *iOS/OSX/watchOS/tvOS*, you'll find these frameworks in respective folders inside `/Carthage/Build`. If your project conforms only to only one of these platforms then use the proper framework. You don't need all of them

> Don't forget to drag all the compiled frameworks. Some of them might be internal dependencies of SugarRecord and without them the project could not compile.
