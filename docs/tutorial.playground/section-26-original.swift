SugarRecord.operation(SugarRecordStackType.SugarRecordStackTypeRealm, closure: { (context) -> () in
  users: [User]? = User.all().find(inContext: context)?
  context.beginWriting() // <- Notifying we're starting the edition
  for user in users {
    user.age++
  }
  context.endWriting() // <- Notifying that we've finished the edition
})