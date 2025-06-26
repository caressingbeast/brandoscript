###
Types
- Bool: true or false
- List
- Map
- Number
- String
- Unknown (type of value is unknown)
- Void
- instances of structs
###

###
Variables
###

# `let` means immutable
let String name = "Brandon"
let Number age = 41
age = 42 # doesn't work!

# `mut` means mutable
mut String nickname = "Brando"
nickname = "Brando" # works!

# Lists
# To acess a particular entry: list[0]
# To assign: list[0] = THING
let List<String> list = []
let List<(Number or String)> list = []

# Maps
# To access a particular entry: map["key"]
# To assign: map["key"] = THING
let Map<String> map = {
  name: "Brandon"
}

let Map<(Number or String)> map = {
  id: 1,
  name: "Brandon"
}

let Map<Unknown> map = {
  unknown: "anything"
}

# Tuples
# To access a particular entry: t[0]
# To assign: t[0] = THING
let (Number, String) t = (41, "Brandon")

# Structs
# To access a particular entry: user.name
# To assign: user.name = THING
struct User1 {
  Number id
  Bool active
  String name
}

let User1 user = User1 {
  id: 1,
  active: true,
  name: "Brandon"
}

###
Structs
To re-assign any value, the entire struct instance must be `mut`
###
struct User2 {
  Number id
  String name
}

# Optional values using Maybe<T>
struct User2 {
  Number id
  String name
  Maybe<String> status # Maybe is a built-in enum type (Yes/No; defaults to No)
}

# Default values
struct User3 {
  Number id
  String name = "Anonymous"
  Maybe<String> status = Yes("active") # can default a maybe (defaults to No if not provided)
}

# Methods
struct User4 {
  Number id
  String name

  String greet() {
    "Hello, @{self.name}!"
  }

  Void rename(String n) { // struct instance needs to be `mut`
    self.name = n
  }
}

# Extension
struct User5 {
  Number id
  Bool isAdmin = false # default value
  String name
}

struct AdminUser extends User5 {
  Bool isAdmin = true # override defaults from parent
  List<String> roles = ["admin"]
}

###
Maps
###

# Typing
# Map<ValueType>
# BS implicity assumes the key type is String, but you can be explicit (and if BS ever supports other types)
# Map<String, ValueType>

# Shorthand
let Map map = {} # = Map<Unknown> = Map<String, Unknown>

# You can create partially open maps with a custom `type`
type PartialUser = Map {
  id: Number,
  name: String,
  ...: Unknown
}

mut PartialUser user = {
  id: 1,
  name: "Brandon"
  age: 41
}
user["id"] = "1" # not allowed, incorrect type
user["name"] = "Brando" # allowed, correct type
user["key"] = "value" # allowed, new key/value pair
let Number id = user["id"] # safe
let String whatever = user["whatever"] # unsafe, should use Maybe<T>
let Maybe<String> whatever = user["whatever"] # safe after `match` of type check

# Alternatively
mut String whatever = ""
match user["whatever"]:
  Yes(val): { if val is String { whatever = val } }
  No: { print("error") }

###
Functions and Methods
If the last line of a function is a bare expression, it is implicitly returned. Otherwise, use `return`.
###

# Typing
# F<(ArgTypes), ReturnType>

let F<(Number), Number> sum = fun(Number n) {
  n + 10
}

# You can also save the type signature and reference it
type SquareFn = F<(Number), Number>
let SquareFn square = fun(Number n) {
  n * n
}

let F<(), String> greet = fun() {
  "Hello, World!"
}

let F<(String), Void> log = fun(String message) {
  print(message)
}

# Functions can return other functions and capture outer-scope values (closures)
type InnerFn = F<(), Number>
type CounterFn = F<(Number), InnerFn>
let CounterFn counter = fun(Number start) {
  mut Number count = start

  let InnerFn next = fun() {
    count = count + 1
    return count
  }

  next
}

let InnerFn inner = counter(3)
inner() # count = 4
inner() # count = 5

###
Control Flow
###

# While
mut Number counter = 0
while counter < 10 {
  print(counter)
  counter = counter + 1
}

# Loops
# Assume `user` is a map with a name property
for (_, Unknown val) in user { # use `_` to discard
  let String name = match val:
    Yes(String n): { n }
    No: { "" }

  print("Hello, #{name}!")
}

for key in user {
  let Maybe<String> name = user[key]
}

# Inclusive range loop
for Number i in 0 to 10 {
  print(i)
}

# Exclusive range loop
for Number i in 0 until 10 {
  print(i) # stops at 9
}

let List<Number> nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
for Number num in nums {
  if num mod 2 equals 0 { skip }
  if num  > 8 { exit }
  print(num) # 1, 3, 5, 7
}

# If/Else
# Supports `equals`, <, <=, >, >=, `not`, `is`
let Number counter = 0
if counter < 10 {
  print(counter)
}

let Bool isActive = true
if isActive {
  print("Active")
}

struct User6 {
  String name
}
let User6 user = User6 {
  name: "Brandon"
}

if user.name equals "Brandon" {
  print("Yes")
}

# This could be an else, but I wanted to explicity show `not`
if not user.name equals "Brandon" {
  print("No")
}

if user.name is String {
  print("#{user.name} is a String")
}

if not user.name is String {
  print("#{user.name} is not a String")
}

# If/else as assignment
let Number userId = 1
let String name = if userId equals 1 { "Brandon" } else { "Unknown" }

# Match
let String name = match userMap["name"]: // `userMap` is a map
  Yes(String n): { n }
  No: { "" }

let Number status = 200
match status: 
  (200 or 201): { print("OK") }
  500: { print("Error") }
  _: { print("Unknown") }

# Match as assignment
let Number userId = 1
let Map<Unknown> userMap = match (await getUser(userId)): # getUser is an async API call
  Yes(Map<Unknown> data): { data }
  No: { {} }

### 
Destructuring
Structs cannot be destructured (to extract fields, use dot notation (`user.id`) or convert to a Map)
The default behavior is to copy references, not alter the original
###

# Lists
let List<Number> coords = [1, 2]
[Number x, Number y] = coords
# x = 1, y = 2

# Tuples
let (Number, Number) coords = (1, 2)
let (Number x, Number y) = coords
# x = 1, y = 2

# Maps
let { Maybe<Number> id, Number age = 18 } = mapUser # Default values provide fallback behavior, so `Maybe<T>` and runtime checks are optional
print("age = \(age)")
if id is Number {
  print("id = \(id)")
}

let { Number id as userId = 1, Number age as userAge = 18 } = mapUser
# userId = mapUser.id, userAge = mapUser.age

# Rest operators
let List<Number> numbers =  [1, 2, 3, 4, 5]
let [Number ...List<Number> rest] = numbers
# x = 1, remaining = [2, 3, 4, 5]

let { Number id = 1, ...Map<Unknown> rest} = mapUser




