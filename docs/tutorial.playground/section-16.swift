var realmObject: RealmObject = RealmObject.create() as RealmObject
realmObject.name = "Testy"
realmObject.age = 21
let saved: Bool = realmObject()
