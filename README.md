![Logo](https://raw.githubusercontent.com/pepibumur/SugarRecord/master/Resources/Slogan.png)
![image](http://cl.ly/image/3J052s402j0L/Image%202014-08-21%20at%209.22.56%20am.png)

## What is SugarRecord?
SugarRecord is a CoreData management library to make it easier work with CoreData. Thanks to SugarRecord you'll be able to start the CoreData stack structure just with a line of code and start working with your database models using closures thanks to the fact that SugarRecord is completly written in Swift.

### Pending stuff
- Organize current code status and add comments
- Review closures retaining
- Fill CocoaDocs documentation using CocoaPods library
- Integrate with iCloud
- Add tests

### Index
- [How to use SugarRecord](#how-to-use-sugarrecord)
  - [Library useful methods](#library-useful-methods)
  - [Initialize SugarRecord](#initialize-sugarrecord)
  - [Logging levels](#logging-levels)
  - [Contexts](#contexts)
  - [Fetching](#fetching)
- [Notes](#notes)
  - [Useful Swift Resources](#useful-swift-resources)
- [Contribute](#contribute)


## How to use SugarRecord
### Library useful methods

In this main class you'll finde usefull static methods linke the following ones:

- **cleanUp():** Cleans the stack and notifies it using KVO and notification key `srKVOCleanedUpNotification`
- **cleanUpStack():** Cleans the stack
- **currentStack():** Returns a String with the current stack information
- **currentVersion():** Return the current SugarRecord version as a String
- **defaultDatabaseName():** Returns the default database name that will be used unless you pass your own one in the initialization.

### Initialize SugarRecord

To start working with SugarRecord the first thing you have to do is to initialize the entire stack (persistent store, persistent store coordinator, and contexts stack). The simplest way to do it is through the call:

```js
SugarRecord.setupCoreDataStack(true, databaseName: nil)
```

Where with automigrating we specify that the initializer executes the migration if needed and in databaseName the sqlite database name (If *nil* the default one is taken).
The stack of SugarRecord has the following contexts or items:

![Logo](https://raw.githubusercontent.com/pepibumur/SugarRecord/master/Resources/StackScheme.png)


`Root Saving Context` should never be used directly. It's a extra step context to report changes to the persistant coordinator. Below the Root Saving Context it is the Default `Main Context` that will be used for operations in Main Thread like the use of FetchedResultsController or even low load operations that might not lock the MainThread

When operating in other thread instead of the MainThread we keep a similar structure where the bottom context changes. In this case the `Private Saving Context` should only be used for background operations. All changes applied there will be automatically reported to its parent context `Root Saving Context` and stored into the database.

**How does `Default Main Context` know about changes applied from that private context?**

As you probably know changes in CoreData are propagated in up direction but not down neither lateral. It means that if we have an object in `Private Saving Context`and in `Default Main Context` and any of them reports a change it won't be reported to the other one unless we do something. To do it we make use of KVO to listen about changes in the `Private Saving Context` to merge them into `Default Main Context`.

*Remember: Operations related with saving, do them in `Private Saving Context`*

### Logging levels
Logging level can be specified to see what's happening behind SugarRecord. To set the **SugarRecordLogger** level you have just to use the static currentLevel var of SugarRecordLogger

```swift
SugarRecordLogger.currentLevel = .logLevelWarm
````
*Note: By default the log level is .logLevelInfo*. The available log levels are:

```swift
enum SugarRecordLogger: Int {
    case logLevelFatal, logLevelError, logLevelWarm, logLevelInfo, logLevelVerbose
}
```
### Examples
Any other better thing to learn about how to use a library than watching some examples?
#### Finding Examples
If you want to fetch items from the database, SugarRecord has a NSManagedObject extension with some useful methods to directly and, passing context, predicates, and sortDescriptors ( most of them optionals ) fetch items from your database. 
#####- Find the first 20 users in Default Context (Main Context)
We use the class method find, where the first argument is an enum value `(.all, .first, .last, .firsts(n), .lasts(n))` indicating how many values you want to fetch. We can pase the context but if not passing, the default one is selected and moreover filter and sort results passing an NSPredicate and an array with NSSortDescriptors
```swift
let users: [NSManagedObject] = NSManagedObject.find(.firsts(20), inContext: nil, filberedBy: nil, sortedBy: nil)
```

#####- Find all the users called Pedro
Using the same as similar method as above, but in this case we can pass directly the filtered argument and value like as shown below:
```swift
let pedroUsers: [NSManagedObject] = NSManagedObject.find(.all, inContext: nil, attribute: "name", value: "Pedro", sortedBy: nil, sortDescriptors: nil)
```



### Background operations

## Notes
SugarRecord is hardly inspired in **Magical Record**. We loved its structure and we brought some of these ideas to SugarRecord CoreData stack but using sugar Swift syntax and adding more useful methods to make working with CoreData easier.

### Useful Swift Resources
- Tests with Swift (Matt): http://nshipster.com/xctestcase/
- Quick, a library for testing written in swift https://github.com/modocache/personal-fork-of-Quick
- CoreData and threads with GCD: http://www.cimgf.com/2011/05/04/core-data-and-threads-without-the-headache/

## Contribute
