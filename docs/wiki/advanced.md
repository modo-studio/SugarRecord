Although we've tried to offer an easy API interface for beginners we have advanced options too to go further into lower layers of the library. SugarRecord offers operations closures connected with your stacks to work directly with these context and decide then when and how saving them.

```swift
SugarRecord.operation(inBackground: true, SugarRecordStackType.SugarRecordStackTypeRealm, closure: { (context) -> () in
  users: [User]? = User.all().find(inContext: context)?
  context.beginWriting() // <- Notifying we're starting the edition
  for user in users {
    user.age++
  }
  context.endWriting() // <- Notifying that we've finished the edition
})
```

Using **background operations** is strongly recommended if you  are working with a big collection of items. Instead of notifying about saving in *each iteration* you can notify when you start modying/deleting the first element and  notify to save when the entire collection  has been  modified.

In case of **creation** objects have a method that creates them  in a given context (in that case, the background context we are using inside the closure):

```swift
class func create(inContext context: SugarRecordContext) -> AnyObject
```

**This is especially useful if you are inserting a big collection coming from the API into your database**

```swift
SugarRecord.operation(inBackground: true, SugarRecordStackType.SugarRecordStackTypeRealm, closure: { (context) -> () in
  context.beginWriting() // <- Notifying we're starting the edition
  for userJSON in users {
    user: User = User.create(inContext: context) as User
    context.insertObject(user)
  }
  context.endWriting() // <- Notifying that we've finished the edition
})
```

*Notice how we insert the object into the context in each iteration using `insertObject(user)` method of the context*
