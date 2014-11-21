### Objects creation

ManagedObjects and RLMObjects have extensions to make the creation easier. Methods included there are connected with SugarRecord and the stacks you previously setup. The example below shows the creation of an user without mattering if it's a RLMObject OR A CoreData object
```swift
var user: User = User.create() as User
user.name = "Testy"
user.age = 21
let saved: Bool = user.save()
```
### Objects edition

To edit your objects you have to notify SugarRecord that you are going to start/end an edition. If you are going to edit only one object you can do it quickly with the methods `beginWriting()` and `endWriting() `. It's very important to tell SugarRecord about any edition or you app might crash. Take a look to the example below

```swift
user.beginWriting()
user.name ="Pepito"
user.endWriting()
```
If you are editing different objects that are in the same Sugar Record context it's recommended to call `beginWriting()` before starting editing any of them. Once you've finished the edition call `endWriting()`.

### Objects deletion

If you want to delete an object that you have in a SugarRecord context you can do it easily using the method `delete()`. **It's very important** to call `beginWriting()` and `endWriting()` here too to notify the library about the changes you are making. Take a look to the examples below:

```swift
// 3-Lines syntax
user.beginWriting()
user.delete()
user.endWriting()

// 1-Line syntax
user.beginWriting().delete().endWriting()
```

### Objects querying

Fetching elements had never been so easy as it's now with SugarRecord. Take a look to the examples below because they are self-explaining:

```swift
let users: [User]? = User.sorted(by:"name", ascending: true).firsts(10).find()?
users: User? = User().find()?.first as Person
users: [User]? = User("age", equalTo: "10").sorted(by:"name", ascending: true).find()?
users: [User]? = User.all().find()?
```
The example above is valid for **Realm** and **Objective-C**

### Transactions

Operations like edition/deletion **MUST** be grouped in a transaction. The way to group different operations into a single trasaction is using the following methods of the SugarRecordContext:

```swift
context.beginWriting()
context.endWriting()
```
**It's very important to notify the context when you are going to execute any of these kind of operations**, otherwise the app might crash. Moreover, remember that the changes are persisted once you call `endWriting()`, otherwise they will be in your object but not in the database. 

*Note: If you want to cancel a transaction and return everything to the previous status you can do it using the `cancelWriting()* method.

### Advanced options

Although we've tried to offer an easy API interface for beginners we have advanced options too to go further into lower layers of the library. SugarRecord offers operations closures connected with your stacks to work directly with these context and decide then when and how saving them.

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
