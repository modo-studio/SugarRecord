var migrations: [RLMObjectMigration<RLMObject>] = [RLMObjectMigration<RLMObject>]()

migrations.append(RLMObjectMigration<RealmObject>(toSchema: 13, migrationClosure: { (oldObject, newObject) -> () in // Your code here}) as RLMObjectMigration<RLMObject>)
migrations.append(RLMObjectMigration<RLMObject>(toSchema: 3, migrationClosure: { (oldObject, newObject) -> () in // Your code here}) as RLMObjectMigration<RLMObject>)
migrations.append(RLMObjectMigration<RLMObject>(toSchema: 1, migrationClosure: { (oldObject, newObject) -> () in  // Your code here}) as RLMObjectMigration<RLMObject>)

let stack: DefaultREALMStack = DefaultREALMStack(stackName: "Stack name", stackDescription: "Stack description", migrations: migrations)