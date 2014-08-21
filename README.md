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
  - [Examples](#examples)
    - [Finding examples](#finding-examples)
    - [Counting examples](#counting-examples)
    - [Background Operations Examples](#background-operations-examples)
      - [Background operation without saving](#background-operation-without-saving)
      - [Background operation saving](#background-operation-saving)
- [Keep in mind](#keep-in-mind)
- [Notes](#notes)
  - [Useful Swift Resources](#useful-swift-resources)
- [Contribute](#contribute)
- [License](#license)

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
####Finding Examples
If you want to fetch items from the database, SugarRecord has a NSManagedObject extension with some useful methods to directly and, passing context, predicates, and sortDescriptors ( most of them optionals ) fetch items from your database. 
#####- Find the first 20 users in Default Context (Main Context)
We use the class method find, where the first argument is an enum value `(.all, .first, .last, .firsts(n), .lasts(n))` indicating how many values you want to fetch. We can pase the context but if not passing, the default one is selected and moreover filter and sort results passing an NSPredicate and an array with NSSortDescriptors
```swift
let users: [NSManagedObject] = User.find(.firsts(20), inContext: nil, filberedBy: nil, sortedBy: nil)
```

#####Find all the users called Pedro
Using the same as similar method as above, but in this case we can pass directly the filtered argument and value like as shown below:
```swift
let pedroUsers: [NSManagedObject] = User.find(.all, inContext: nil, attribute: "name", value: "Pedro", sortedBy: nil, sortDescriptors: nil)
```

#####Find all the users from Berlin sorted by Name
You can even pass the sorting key using its key name as shown below. In this case we are finding all the users from Berlin in the Main Context and sorting them by name ascending.
```swift
let berlinUsers: [NSManagedObject] = User.find(.all, inContext: nil, attribute: "city", value: "Berlin", sortedBy: "name", ascending: true)
```

####Counting examples
SugarRecord is even prepare to give you the number of entities with or without filters, passing or not the context and even if there's an object of a given class.
#####Count of cities
If we want to get a count of a given entity in database we can just use the class method count. It uses the Main Context to fetch this information. If you want to do it in a passed Context you can use it too.
```swift
let numberOfCities: Int = City.count()
```
#####Count of cities with 2 hospitals
In this case we are getting the count but filtering the results using a passed predicate. The predicate filters cities with only 2 hospitals.
```swift
let numberOfCitiesWithTwoHospitals: Int = City.count(NSPredicate(format: "hospitals == 2", argumentArray: nil))
```
#####Check if there is any prize
Alghough you can get directly if there is any entity using the count and equaling it to zero there is a method too in SugarRecord to do it. Just call any on the entity you want to know about its existence in database and a Bool will be returned with that information
```swift
let anyPrice: Bool = Prize.any()
```
####Background operations examples
#####Background operation without saving
Although all the examples above have been executed in the Main Context (Main Thread) all can be executed in a different thread just passing them in the method as an input paramenters. When the operations have high load it's not recommended to do them in the Main Context but in Private Contexts working on a background thread. You can create these contexts and execute them in background threads but **SugarRecord can handles it**. It has two methods, the first one is for a background execution **without savinv** and the other one includes saving. **How should I do them for example if I want for example get all the users but in background?**

```swift
background { (context) -> () in
  let users: [NSManagedObject] = User.find(.all, inContext: context, filberedBy: nil, sortedBy: nil)     
}
```
*Notice that users have been brought in a private context whose life finished when the closure execution ends. What does it supposes? That you can't use these users ManagedObject entities outside the closure because they were only alive in the context that now is death. If you want to use them you should get their objectIDs and bring these entities into the mainContext where you are working*
#####Background operation saving
For entities edition it's **highly recommended** to do it in background. The previous method only creates a context to do your operations but it doesn't save the context so if you have modified something there the change won't be reported. If you want to use background private threads for saving lets use save like the example below:

```swift
self.save(inBackground: true, savingBlock: { (context) -> () in
let berlinUsers: [NSManagedObject] = User.find(.all, inContext: context, attribute: "city", value: "Berlin", sortedBy: "name", ascending: true)
  var berlinUser: User? = berlinUsers.first?
  if berlinUser != nil {
    berlinUser.name = "Pedro"
  }
}) { (success, error) -> () in
    println("The user was saved successfuly")
}
```
*Notice that as in the previous example we're using the context passed in the closuer to fetch berlinUsers and taking the first one. Then we modify its name. When the closure execution ends then the created private context is internally saved and it notifies the user calling a completion closure **in the main thread***

## Keep in mind
- NSManagedObjectIDs and move objects between contexts
- Not referencing objects

## Notes
SugarRecord is hardly inspired in **Magical Record**. We loved its structure and we brought some of these ideas to SugarRecord CoreData stack but using sugar Swift syntax and adding more useful methods to make working with CoreData easier.

### Useful Swift Resources
- Tests with Swift (Matt): http://nshipster.com/xctestcase/
- Quick, a library for testing written in swift https://github.com/modocache/personal-fork-of-Quick
- CoreData and threads with GCD: http://www.cimgf.com/2011/05/04/core-data-and-threads-without-the-headache/

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

## Contribute
SugarRecord is provided free of charge. If you want to support it:
- You can report your issues directly through Github repo issues page. I'll try to fix them as soon as possible and listen your suggestion about how to improve the library.
- You can post your doubts in StackOverFlow too. I'll be subscribed to updates in StackOverFlow related to SugarRecord tag.
- We are opened to new PR introducing features to the implementation of fixing bugs in code. We can make SugarRecord even more sugar than it's right know. Contribute with it :smile:
