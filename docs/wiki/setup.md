## Installation

Cocoapods doesn't support support Swift libraries yet so the instalation process has to be manual. To import SugarRecord into your project:

1. Download the project into your project's libraries folder. You can use git submodules too `git submodule add https://github.com/sugarrecord/sugarrecord myproject/libraries`
2. You have to add now the project files **into your project's target**. To do it, Drag SugarRecord.xcodeproj to your project in the Project Navigator that you'll find on the `SugarRecord/project` folder.
3. Finally you have to specify which framework you would like to compile with your project. There are three:

- SRCoreDataRestKit // Needs RestKit in your project
- SRCoreData
- SRRealm

4. In the *build phases* tab of your project's main target. Add the `.framework` you chose in the **Target Dependencies** group.
5. Click on the + button at the top left of the panel and select **New Copy Files Phase**. Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add the `.framework` you chose
6. Import `SRCoreDataRestKit/SRCoreData/SRRealm` wherever you want to use it. Otherwise the classes won't be visible

*Note: As soon as CocoaPod supports it the library will have a pod to make this process easier for everybody*

## Communication flow

If you want to communicate any issue, suggestion or even make a contribution, you have to keep in mind the flow bellow:

- If you **need help**, ask your doubt in Stack Overflow using the tag 'sugarrecord'
- If you want to ask something in general, use Stack Overflow too.
- **Open an issue** either when you have an error to report or a feature request.
- If you want to **contribute**, submit a pull request, and remember the rules to follow related with the code style, testing, ...

## How to use SugarRecord
If you want to learn how to setup SugarRecord with the stack and stack working with it, the library comes with an useful Playground HTML file with steps and some examples to follow. Take a look to the playground [**HERE**](https://github.com/SugarRecord/SugarRecord/docs/tutorial.playground).

Otherwise if you want to have a quick idea of how working with SugarRecord is, take a look to the examples below.

### Initialize SugarRecord with a stack
SugarRecord needs you to pass the stack you are going to work with. There are some stacks availables to use directly but you can implement your own regarding your needs. Keep in mind that it's important to set it because otherwise SugarRecord won't have a way communicate your models with the database. Take a look how it would be using the default stack of Realm and CoreData:

```Swift
// Example initializing SugarRecord with the default Realm 
SugarRecord.addStack(DefaultREALMStack(stackName: "MyDatabase", stackDescription: "My database using the lovely library SugarRecord"))

// Example initializing SugarRecord with the default CoreData stack
let stack: DefaultCDStack = DefaultCDStack(databaseName: "Database.sqlite", automigrating: true)
SugarRecord.addStack(stack)
```
Once you have the stack set, a connection between SugarRecord and your app's lifecycle is required in order to execute cleaning and saving internal tasks. Ensure you have the following calls in your app delegate:

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

### Setup the log level

By default the log level of the library is `Info`. If you want to change it you can do it with:
```swift
SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelVerbose
```
