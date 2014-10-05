# SugarRecord playground
Enjoy learning how to play with SugarRecord

## Setup the stack

Once you have SugarRecord integrated in your project the first thing you have to do is telling SugarRecord wich stack it should use. SugarRecord has different stacks depending on the developer requeriments. Some of them available are:

**Default Core Data Stack**: This stack has a private context with the unique persistent store coordinator as parent. There is a main context under it to execute low load operations and a private one at the same level as the main one to execute high load operations. Changes performed in that private context are brought to the main context using KVO.

**Default REALM Stack**: This stack provides a setup for REALM which is much easier than Core Data, no context, thread safe...

**Default Core Data Stack + iCloud**: IN PROGRESS

**Default Core Data Stack + Restkit**: It connects thd default CoreData stack with RestKit to enjoy the powerful features of that library.

Take a look how we set the stack for Realm and CoreData

```swift
// Example initializing SugarRecord with the default Realm 
SugarRecord.addStack(DefaultREALMStack(stackName: "MyDatabase", stackDescription: "My database using the lovely library SugarRecord"))

// Example initializing SugarRecord with the default CoreData stack
let stack: DefaultCDStack = DefaultCDStack(databaseName: "Database.sqlite", automigrating: true)
SugarRecord.addStack(stack)
```

**It's very important to set the stack otherwise SugarRecord won't know how to work with your storage library**

## Notify about the application status changes

Some stacks execute operations during the transitions of the apps from/to background. For that reason is important to connect your application delegate calls with the library. The example below shows how to connect them:

```swift
func applicationWillResignActive(application: UIApplication!) {
  SugarRecord.applicationWillResignActive()
}

func applicationWillEnterForeground(application: UIApplication!) {
  SugarRecord.applicationWillEnterForeground()
}

func applicationWillTerminate(application: UIApplication!) {
  SugarRecord.applicationWillTerminate()
}
```

## Log level

SugarRecord allows you to choose the log level that you want in the integration with your project. Log levels available are:

```swift
public enum SugarRecordLogger: Int {
    /// Current SugarRecord log level
    static var currentLevel: SugarRecordLogger = .logLevelInfo
    
    /// SugarRecord enum levels
    case logLevelFatal, logLevelError, logLevelWarn, logLevelInfo, logLevelVerbose
}
```
Where **logLevelFatal** means that the most critical logs will be shown and **logLevelVerbose** that everything will be shown. To change the current level which by default is **logLevelInfo** you can do it on this way:

```swift
SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelVerbose
```

## Database Model

Once you have everything setup in SugarRecord you need to have a database model. In case of **CoreData** you can define it in an *.xcdatamodel* file that XCode can create automatically during the project creation. There you'll have to create the entities and generate **NSManagedObject** classes for these entities. Take a look to this tool [**Mogenerator**](https://github.com/rentzsch/mogenerator) where specifying the .xcdatamodel file it generates human & machine classes for your entities.

Otherwise, if you are working with Realm you have just to define the models on your own following the documentation in their website [**Realm documentation for Cocoa**](http://realm.io/docs/cocoa/0.86.0/)

Let's take a look to the models we have created for CoreData and Realm:

**CoreData**
```swift
import Foundation
import CoreData

@objc(CoreDataObject)
class CoreDataObject: NSManagedObject {

    @NSManaged var age: NSDecimalNumber
    @NSManaged var birth: NSDate
    @NSManaged var city: String
    @NSManaged var email: String
    @NSManaged var name: String

}
```

**Realm**
```swift
import Foundation
import Realm

public class RealmObject: RLMObject
{
    public dynamic var name: String = ""
    public dynamic var age: Int = 0
    public dynamic var email: String = ""
    public dynamic var city: String = ""
    public dynamic var birthday: NSDate = NSDate()
}
``` 

## Creation
We have models, we have the library. Let's play with them. The first operation we do when we don't have any data in the database is the creation. Creating an object is as easier as the example below where the object is created, some of its fields are edited and then the object is saved.:

```swift
var user: User = User.create() as User
user.mame = "Testy"
user.age = 21
let saved: Bool = user.save()
```
*Notice that the creation of the object doesn't mean that the object is persisted in the database. You have to notify it using the save command*

**The same syntax is valid for REALM:**

```swift
var realmObject: RealmObject = RealmObject.create() as RealmObject
realmObject.name = "Testy"
realmObject.age = 21
let saved: Bool = realmObject()
```

## Querying

Having data in the database other typical operation is the queryng. Bringing these entities persisted in the database into memory objects to work with them. SugarRecord has a **friendly** syntax to make it hyper Sugar! and easy to remember:

```swift
let users: [User]? = User.sorted(by:"name", ascending: true).firsts(10).find()?
users: User? = User().find()?.first as Person
users: [User]? = User("age", equalTo: "10").sorted(by:"name", ascending: true).find()?
users: [User]? = User.all().find()?
```
**Notice that the returned value is an **optional**, it's due to the fact that there might not be items with your criteria in the database**

The querying operation has to finish with the fetch command, **find()**. Don't forget it! 

## Edition
Objects have been fetched, how do I edit them? To do it you have to remember the three simple steps below:

1. **Notify the object about its edition**
2. **Edit whatever you want**
3. **Notify the object that you have finished with the edition**

It's important to not forget any of the steps above or it might cause a runtime exception, especially in Realm where the notifications to the database library are crucial.

```swift
user.beginWriting()
user.name ="Pepito"
user.endWriting()
```

**Note: The same syntax applies for Realm**

```swift
realmObject.beginWriting()
realmObject.age = 2
realmObject.name = "Changed"
realmObject.endWriting()
```

## Deletion
Have you forget the steps above? Because you have to apply for deletion too but in this case the edition setters is only one, `delete()`. Take a look:
```swift
// 3-Lines syntax
user.beginWriting()
user.delete()
user.endWriting()

// 1-Line syntax
user.beginWriting().delete().endWriting()
```
**Remember here too the important of notify the `beginWriting()` and `endWriting()`**

## Advanced options
Although the previous operations are ideal for these users who don't need to work with a big amount of data, if this quantity increases and you need to be changing, deleting, creating objects in big groups you shouldn't be notifying beginWriting() and endWriting() for each model because it's not efficient. Thinking on this, SugarRecord offers operation closures to manipulate these objects inside the closure like the example below:

```swift
SugarRecord.operation(SugarRecordStackType.SugarRecordStackTypeRealm, closure: { (context) -> () in
  users: [User]? = User.all().find(inContext: context)?
  context.beginWriting() // <- Notifying we're starting the edition
  for user in users {
    user.age++
  }
  context.endWriting() // <- Notifying that we've finished the edition
})
```
Where the age of all our users is incremented by 1. Notice how in this case the beginWriting() and endWriting() are executed in the context before beginning with all the items and after finishing the edition of **all** the items.

### Talking about contexts
Although contexts are something typical working with CoreData, it's not a pattern of Realm. However we've found a way to abstract the edition using SugarRecord contexts that have features of the CoredData ones and features of Realm too. 
As you might have noticed it allows us to work with our models using the same syntax. It means that if in a future you decide it's time to change Realm by CoreData or viceversa you have only to **ensure that the new models have the same fields** and you won't have to change anything around the app because the new models will have the same syntax. Yeiii!!


## Migrations
It's been impossible to abstract mirations between CoreData and Realm because they are managed diferently:

- **CoreData**: In this case migrations can be either automatically managed if you specify it during the stack creation of manually managed using **migration policies**. I recommend you to read this post of objc.io, [**Core Data Migration**](http://www.objc.io/issue-4/core-data-migration.html) where they explain different migration options. In case of a failing migration, the CoreData stack automatically can notify you if you specify it. The way to do it is passing a closure to the stack:

```swift
stack.migrationFailedClosure = {
  // The migration failed
}
```
- **Realm**: Realm manages the migrations passing them manually in code though. It's pretty easier but we've done it even more. To specify the migrations you can do it during the Realm stack creation passing an array with these migrations. Each migration is an struct with fields that specify the schema model where the model is going to migrate to:

```swift
var migrations: [RLMObjectMigration<RLMObject>] = [RLMObjectMigration<RLMObject>]()

migrations.append(RLMObjectMigration<RealmObject>(toSchema: 13, migrationClosure: { (oldObject, newObject) -> () in // Your code here}) as RLMObjectMigration<RLMObject>)
migrations.append(RLMObjectMigration<RLMObject>(toSchema: 3, migrationClosure: { (oldObject, newObject) -> () in // Your code here}) as RLMObjectMigration<RLMObject>)
migrations.append(RLMObjectMigration<RLMObject>(toSchema: 1, migrationClosure: { (oldObject, newObject) -> () in  // Your code here}) as RLMObjectMigration<RLMObject>)

let stack: DefaultREALMStack = DefaultREALMStack(stackName: "Stack name", stackDescription: "Stack description", migrations: migrations)
```
Where the oldObject and newObject fields are managed regarding the Realm docummentation:

```swift
newObject["name"] = "Mr. \(oldObject["name"])"
```

### Keep playing
Now that you know the basic operators and functions in SugarRecord it's time to play with them in your project. If you figure out that there's something wrong or something that might be improved do not hesitate to contact me [pepibumur@gmail.com](mailto://pepibumur@gmail.com). I'll be pleased to help as much as possible.
