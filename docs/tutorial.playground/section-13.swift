var user: User = User.create() as User
user.mame = "Testy"
user.age = 21
let saved: Bool = user.save()