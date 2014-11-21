### SugarRecord stacks

One of the main advantages of using SugarRecord is its big flexibility to choose the storage architecture you want for your app. SugarRecord comes with some default stacks for Realm and CoreData but you can implement your own ensuring it conforms the needed protocols (*take a look to the existing ones*). The available stacks are:

- **Default Core Data Stack**: This stack has a private context with the unique persistent store coordinator as parent. There is a main context under it to execute low load operations and a private one at the same level as the main one to execute high load operations. Changes  performed in that private context are brought to the main context using KVO.
- **Default REALM Stack**: This  stack provides a setup for REALM which is much easier than Core Data, no context, thread safe...
- **Default Core Data Stack + iCloud**: With the stack of iCloud you'll be able to persist your users' data in iCloud easily. Initialize the stack and leave SugarRecord do the rest.
- **Default Core Data Stack + Restkit**: It connects thd default CoreData stack with RestKit to enjoy the powerful features of that library.