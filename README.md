![Logo](https://raw.githubusercontent.com/pepibumur/SugarRecord/master/Resources/Slogan.png)

### What is SugarRecord?
SugarRecord is a CoreData management library to make it easier work with CoreData. Thanks to SugarRecord you'll be able to start the CoreData stack structure just with a line of code and start working with your database models using closures thanks to the fact that SugarRecord is completly written in Swift.

### Pending stuff
- Fill CocoaDocs documentation using CocoaPods library
- Generate wiki with some examples.
- Add tests

### Initialize SugarRecord

To start working with SugarRecord the first thing you have to do is to initialize the entire stack (persistent store, persistent store coordinator, and contexts stack). The simplest way to do it is through the call:

```swift
SugarRecord.setupCoreDataStack(automigrating: true, databaseName: nil)
```

Where with automigrating we specify that the initializer executes the migration if needed and in databaseName the sqlite database name (If *nil* the default one is taken)

### Contexts


### Fetching


### Useful Swift Resources
- Tests with Swift (Matt): http://nshipster.com/xctestcase/
- Quick, a library for testing written in swift https://github.com/modocache/personal-fork-of-Quick
- CoreData and threads with GCD: http://www.cimgf.com/2011/05/04/core-data-and-threads-without-the-headache/

### Notes
SugarRecord is hardly inspired in **Magical Record**. We loved its structure and we brought some of these ideas to SugarRecord CoreData stack but using sugar Swift syntax and adding more useful methods to make working with CoreData easier.

### Contribute
