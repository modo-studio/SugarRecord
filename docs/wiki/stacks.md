# SugarRecord stacks

One of the main advantages of using SugarRecord is its big flexibility to choose the storage architecture you want for your app. SugarRecord comes with some default stacks for Realm and CoreData but you can implement your own ensuring it conforms the needed protocols (*take a look to the existing ones*). The available stacks are:

## Default Core Data Stack
- **Class:** DefaultCDStack
This stack has a private context with the unique persistent store coordinator as parent. There is a main context under it to execute low load operations and a private one at the same level as the main one to execute high load operations. Changes  performed in that private context are brought to the main context using KVO.

**Constructors**
```swift
public init(databaseURL: NSURL, model: NSManagedObjectModel?, automigrating: Bool)
convenience public init(databaseName: String, automigrating: Bool)
convenience public init(databasePath: String, automigrating: Bool)
convenience public init(databaseURL: NSURL, automigrating: Bool)
convenience public init(databaseName: String, model: NSManagedObjectModel, automigrating: Bool)
convenience public init(databasePath: String, model: NSManagedObjectModel, automigrating: Bool)
```

**Properties**
- **databaseName**: Name of the database with .sqlite extension
- **databaseURL**: NSURL with the local path of the database
- **model**: CoreData .xcdatamodel, if not supplied, the main one in your project is taken.
- **automigrating**: If true, SugarRecord tries the migration automatically and clean the database in case of failing
- **autoSaving**: If true, when you execute any saving operation in background they are automatically persisted into the database. Otherwise, they will be persisted when the app moves to the background (false by default)


## Default REALM Stack
- **Class:** DefaultRealmStack
This  stack provides a setup for REALM which is much easier than Core Data, no context, thread safe...

**Constructors**
```swift
convenience public init(stackName:String, stackDescription: String, migrations: [RLMObjectMigration<RLMObject>])
```

**Properties**
- **migrations:** Migrations objects to be executed in case of migratiions existing

**RLMObjectMigration**
- **toSchema:** Destination schema of the migration (Int)
- **migrationClosure:** Actions to be executed in the migration. That closure has as input parameters the old and new model copies to decide what you should do with these models.

## Default Core Data Stack + iCloud
- **Class:** iCloudCDStack
With the stack of iCloud you'll be able to persist your users' data in iCloud easily. Initialize the stack and leave SugarRecord do the rest.

**Constructors**
```swift
public init(databaseURL: NSURL, model: NSManagedObjectModel?, automigrating: Bool, icloudData: iCloudData)
convenience public init(databaseName: String, icloudData: iCloudData)
convenience public init(databaseURL: NSURL, icloudData: iCloudData)
convenience public init(databaseName: String, model: NSManagedObjectModel, icloudData: iCloudData)
convenience public init(databasePath: String, model: NSManagedObjectModel, icloudData: iCloudData)
```

**Properties**
- **icloudData**: iCloudData object with information about the iCloud connection

**iCloudData properties**
- **iCloudAppID:** Is the full AppID (including the Team Prefix). It's needed to change tihs to match the Team Prefix found in the iOS Provisioning profile.
- **iCloudDataDirectoryName:** Is the name of the directory where the database will be stored in. It should always end with .nosync *(by default data.nosync)*
- **iCloudLogsDirectory:** Is the name of the directory where the database change logs will be stored in


## Default Core Data Stack + Restkit
- **Class:** RestkitCDStack
It connects thd default CoreData stack with RestKit to enjoy the powerful features of that library.

**Constructors**
Same DefaultCDStack constructors

**Properties**
Same DefaultCDStack properties