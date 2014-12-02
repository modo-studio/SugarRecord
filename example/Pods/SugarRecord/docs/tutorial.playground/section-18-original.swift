let users: [User]? = User.sorted(by:"name", ascending: true).firsts(10).find()?
users: User? = User().find()?.first as Person
users: [User]? = User("age", equalTo: "10").sorted(by:"name", ascending: true).find()?
users: [User]? = User.all().find()?