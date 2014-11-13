// Example initializing SugarRecord with the default Realm 
SugarRecord.addStack(DefaultREALMStack(stackName: "MyDatabase", stackDescription: "My database using the lovely library SugarRecord"))

// Example initializing SugarRecord with the default CoreData stack
let stack: DefaultCDStack = DefaultCDStack(databaseName: "Database.sqlite", automigrating: true)
SugarRecord.addStack(stack)