When working with dabase fetched objects there are some points you should keep in mind if you don't want to have headaches in the future. We recommend you to take a look at them:

- Be careful **working with objects between contexts**. In case of **CoreData** remember that a ManagedObject belongs to a given context. Once the context dies the object disappears and trying to access to it will bring you into a trouble. SugarRecord has defensive code to ensure that if you are saving objecs from one context in other one one they are automatically brought to the new context to be saved there. In **Realm** it's less critical.

- **Not referencing objects**. Try to use their remote or local identifiers instead. Strong references is something dangerous because you can break the normal behaviour of CoreData/REALM. In CoreData for example it might cause **fault relationship** crashes although your propagation rules are properly defined. Use their unique identifiers from the API for example or your own created in PONSO objects. Think that the UI shouldn't be coupled to the data layer and shouldn't know anything about it. Doing this way you are coupling both through the model.

- **Beta version**. SugarRecord is still a beta version and it might have some bugs. If you find any, report us using Github issues. SugarRecord is actively supported so we'll cover reported bugs with high priority as quicly. Due to the fact that we have tests around the app the number of bugs is very low but it's impossible to cover all the library.

