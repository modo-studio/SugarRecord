## Integrate in your project
Cocoapods doesn't support support Swift libraries yet so the instalation process has to be manual. To import SugarRecord into your project:

### CoreData/Realm (without Restkit)

1. Download the project into your project's libraries folder. You can use git submodules too `git submodule add https://github.com/sugarrecord/sugarrecord myproject/libraries`
2. You have to add now the project files **into your project's target**. To do it, Drag SugarRecord.xcodeproj to your project in the Project Navigator that you'll find on the `SugarRecord/project` folder.
3. Finally you have to specify which framework you would like to compile with your project. There are three:

- SRCoreData
- SRRealm

4. In the *build phases* tab of your project's main target. Add the `.framework` you chose in the **Target Dependencies** group.
5. Click on the + button at the top left of the panel and select **New Copy Files Phase**. Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add the `.framework` you chose
6. Import `SRCoreDataRestKit/SRCoreData/SRRealm` wherever you want to use it. Otherwise the classes won't be visible

*Note: As soon as CocoaPod supports it the library will have a pod to make this process easier for everybody*

### CoreData with Restkit

1. Your project needs the RetKit framework. Install it using CocoaPods or its Github Repo steps.
2. Ensure that your project has the CoreData framework too.
3. Drag the `/library` folder into your project and rename it to `SugarRecord`
4. Remove the Realm folder because you don't need it.
4. Build and Run your project!

## Initialize SugarRecord with a stack

SugarRecord needs you to pass the stack you are going to work with *(you can learn more about stacks [here](TODO))*. There are some stacks availables to use directly but you can implement your own regarding your needs. Keep in mind that it's important to set it because otherwise SugarRecord won't have a way communicate your models with the database. Take a look how it would be using the default stack of Realm and CoreData:

```swift
// Example initializing SugarRecord with the default Realm
SugarRecord.addStack(DefaultREALMStack(stackName: "MyDatabase", stackDescription: "My database using the lovely library SugarRecord"))

// Example initializing SugarRecord with the default CoreData stack
let stack: DefaultCDStack = DefaultCDStack(databaseName: "Database.sqlite", automigrating: true)
SugarRecord.addStack(stack)
```

## App's lifecycle notifications

Once you have the stack set, a connection between SugarRecord and your app's lifecycle is **REQUIRED** in order to execute cleaning and saving internal tasks. **Ensure** you have the following calls in your app delegate:

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

## Setup the log level

By default the log level of the library is `Info`. If you want to change it you can do it with:

```swift
SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelVerbose
```




