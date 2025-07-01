###
Design notes
- No type inference for now, all types must be explicit
###


# This is a example of a single line comment

###
This is an example of a multiline comment
###

###
Variable declaration
All variables are immutable by default. You must use the `mut` keyword to change a variable's value
This applies to maps, arrays, tuples, structs (instances, not the struct itself)
###

str name = "Brandon"
num age = 41
num[] scores = [50, 100, 75] # access = scores[0]
str[] words = ["test1", "test2", "test3"]
bool isCool = true # could be false (no null or undefined in BrandoScript)
(num, str) person = (41, "Brandon") # access = person[0]
User[] user = [
  User { id: 1, name: "Brandon" }
]
mut unknown[] values = []

(num or str)[] values = ["Brandon", 41, "old"]

fn((num, num): num) add = (num a, num b) {
  a + b
}

# `mut` keyword means the variable is mutable; immutable by default
mut num age = 41
age = 42

# `unknown` keyword means the type is unknown and will require type guards
# unknown val = <ApiResponse>

###
Types
###

generic type Maybe(Y) = yes(Y) or no
generic type Result(O, E) = ok(O) or err(E)

type AddFn = fn((num, num): num)
AddFn add = (num a, num b) {
  a + b
}

type UserId = num or str
Maybe(UserId) id = user at "id" # user is a map (`at` syntax is only available on maps)

###
Maps
###

# map(ValueType) # under the hood, BS infers map(KeyType = "string", ValueType)
map(unknown) user = {
  age: 41,
  isAdmin: true,
  name: "Brandon"
}

Maybe(str) name = user at "name" # may not exist

if name is str {
  print("Hello, \(name)!")
}

# To add or update, the entire map must be `mut` (no support for fine-grained `mut` control yet)
mut map(str) simple = {
  key1: "value1"
}
simple at "key2" = "value2"

if "name" in user {
  print("`name` exists in user!")
}

type MapValues = bool or num or str
map(MapValues) mixedMap = {
  id: 1,
  isCool: true, # always
  name: "Brandon"
}

# You can also create a partially open map
map {
  id: num,
  name: str,
  ...: unknown
} user {
  id: 1,
  name: "Brandon"
}

type UserMap = map {
  id: num,
  name: str,
  ...: bool or num or str
}
UserMap user = {
  id: 1,
  name: "Brandon"
  status: "active"
}

# This allows for safe retrieval (without unknown)
str name = user at "name"
{ id, name } = user

###
Structs
###

struct User = {
  num id
  str name
  (num or str) status

  str greet() {
    "Hello, \(self.name)!"
  }

  # Remember, any instance of this struct must be `mut`
  void rename(str updatedName) {
    self.name = updatedName
  }
}

# The instance is marked `mut`, not the struct itself
mut User user = User {
  id: 1,
  name: "Brandon"
}

user.id # 1
user.greet() # "Hello, Brandon!"
user.rename("Brando")
user.greet() # "Hello, Brando!"

# Error handling/generic structs
struct Error {
  num code
  str message
}

# This is for easy reference. In reality, `Result` is a built-in generic type
generic type Result(O, E) = ok(O) or err(E)

Result(num, Error) divide(num a, num b) {
  if b equals 0 {
    return err(Error { code: 1, message: "Cannot divide by 0" })
  }

  ok(a / b)
}

attempt {
  num res = divide(10, 0)
  print(res)
} handle(Error e) {
  print("Error: \(e.message)")
}

# Default values
struct User {
  num id
  bool isAdmin = false  # default value
  str name
}

# Extending structs
struct AdminUser extends User {
  bool isAdmin = true # can override a default value on parent
  str[] roles = ["admin"] # add new properties/methods not on parent
}

###
Destructuring
By default, destructuring copies and does not remove from the original structure
Only maps and structs support the `as` syntax for renaming
Using the `rest` keyword requires a variable name (e.g. "as remaining")
###

num[] coords = [1, 2]
[num x, num y] = coords
# x = 1, y = 2

{ num id, str name } = user
# id = user.id, name = user.name

(num, num) coords = (1, 2)
(num x, num y) = coords
# x = 1, y = 2

{ num id as userId, str name as userName } = user
# userId = user.id, userName = user.name

# Rest operators
num[] numbers = [1, 2, 3, 4, 5]
[num x, rest num[] as remaining] = numbers

User user = User { id: 1, name: "Brandon" }
{ num id, rest unknown as remaining } = user

map(unknown) mapUser = { id: 1, age: 41, name: "Brandon" }
{ Maybe(num) id, num age = 18 } = mapUser # default values negate the need for maybe and checking
print("age = \(age)")
if id is num {
  print("id = \(id)")
}

# Using omit (stdlib)
import { omit } from std.struct
{ num id, rest omit(User, ["id"]) as remaining } = user

###
If/Else/Etc.
###

if user.id equals 1 {
  print("Hello")
} else {
  print("Goodbye")
}

# Primitives check value; structs, maps, arrays, tuples do deep checking
if not user.id equals 1 {
  print("Not user 1!")
}

# Type checking (structural)
if user.id is num {
  print("User ID is a number")
}

if user is User {
  print("user is an instance of User!")
}

if not id is num {
  print("id is not a num!")
}

if user.id equals 1 and user.name equals "Brandon" {
  print("You are Brandon!")
}

if user.name equals "Brandon" or user.name equals "Brando" {
  print("You are one of us!")
}

bool isActive = true
if not isActive {
  print("Go outside, nerd!")
}

# Looping over keys is only available for maps, not structs
for str key in user {
  Maybe(unknown) val = user at key

  if val is str {
    if not val equals "Brandon" {
      print("You're not Brandon!")
    }
  }
}

# `in` syntax is also only available for maps
if "name" in user {
  print("Found `name`")
}

if key in user {
  print(user at key)
}

str name = if user.id equals 1 { "Brandon" } else { "Brando" }

match user.id {
  1 { print("Hello") }
  _ { print("Goodbye") } # _ is the default arm
}

###
Math
###

# BrandoScript supports all standard mathematical notation (+ - / * () > < >= <=)
# No overloading
num sum = 3 + 3
num difference = 3 - 3
num product = 3 * 3
num quotient = 3 / 3
num advanced = (3 + 3) - (3 / 3) * 3 # follows order of operations

if sum < difference { # do something }
if sum >= product { # do something }

# Modular checks uses the "mod" keyword
if 2 mod 2 equals 0 {
  print("No remainder")
}

###
Maybe
###

# This returns a tuple if it returns "yes"
import { length } from std.arr
Maybe((num, num)) find(num[] arr, num target) {
  for num i from 0 until length(arr) {
    if arr[i] equals target {
      return yes((i, target))
    }
  }
  return no
}

Maybe((num, num)) result = find([1, 2, 3], 3)

if result is yes((idx, target)) {
  print("Target \(target) was found at index \(idx)!")
} else {
  print("Target not found!")
}

match result {
  yes((idx, target)) { print("Target \(target) was found at index \(idx)!") }
  no { print("Target not found!") }
}

###
Functions
###

# Typing for functions (not methods in a struct)
fn((ArgType/s): ReturnType) # fn((num): str)

# makeCounter accepts a `num` and returns a function that returns a `num` but accepts no args
type MakeCounterFn = fn((num): fn((): num))
MakeCounterFn makeCounter = (num start) {
  mut num count = start

  fn((): num) next = () {
    count = count + 1
    return count # explicit return
  }

  next # implicit return (last expression is always implicitly returned unless the function is marked as void)
}

str greet(str name = "World") {
  "Hello, \(name)!"
}

# Generic functions
import { push } from std.arr
type TransformerFn = fn((I): O)
generic fn((I[], TransformerFn): O[]) transform(I, O)(I[] arr, TransformerFn transformer) {
  mut O[] result = []

  for I item in arr {
    result = push(result, transformer(item))
  }

  result
}

generic fn((T[], T): bool) includes(T)(T[] arr, T element) {
  for T item in arr {
    if item equals element {
      return true
    }
  }

  false
}
num[] numbers = [1, 2, 3]
bool found = includes(num)(numbers, 3)

# Unions as args/return types
type DoubleOrHelloFn = fn((str or num): str or num)
DoubleOrHelloFn doubleOrHello = ((str or num) val) {
  if val is num {
    return val * 2
  }

  "Hello, \(val)!"
}

###
String interpolation
###

num age = 41
str name = "Brandon"
print("Hello, \(name)!")

str message = """
  Hello, \(name)!
  You are \(age) years old!
"""

###
Loops
###

# inclusive
for num i from 0 to 10 {
  print("Hello")
}

# exclusive
for num i from 0 until 10 {
  print("Hello")
}

# steps
for num i from 0 to 10 by 2 {
  print(i)
}

for num i from 10 to 0 by -2 {
  print(i)
}

# arrays
num[] scores = [100, 75, 50]
for num score in scores {
  print(score)
}

# maps
map(unknown) user = { id: 1, name: "Brandon" }
for str key in user {
  print(user at key)
}

# while
mut num i = 0
while i < 10 {
  print(i)
  i = i + 1
}

# Loop keywords
for num i from 0 to 10 {
  if i < 3 {
    skip
  }

  if i equals 7 {
    exit
  }

  print(i)
}

###
Async/await
###
struct Error {
  str message
  num status
}

struct User {
  num id
  str name
}

# Reference structs/types only... all are part of core BS
struct Response {
  bool ok
  map(str) headers
  num status
  str statusText
  str url
  async unknown json()
  async str text()
}
generic type Result(O, E) = ok(O) or err(E)
####

struct ApiUser {
  num id
  str name
}
type FetchResponse = Result(Response, Error)
type GetUserResult = Result(User, Error)

async fn((str): GetUserResult) getUser = (str userId) {
  attempt {
    FetchResponse result = await fetch("http://example.com/users/\(userId)")
    
    if not res is ok(Response response) {
      return err(Error { message: "Network error", status: 0 })
    }

    ApiUser data = await res.json()

    User user = User {
      id: data.id,
      name: data.name
    }

    return ok(user)
  } handle(unknown err) {
    return err(Error { message: "Network error", status: 0 })
  }
}

###
Importing
###

import { length, trim } from std.str
import { bar, foo } from "./utils.bs"
import { thing as otherThing } from "./things.bs"
import * as numLib from std.num

export str bar() { "Hello!" }
export type ExportType = bool or num or str

###
Standard Library
###

###
 Numbers
- min
- max
- roundUp
- roundDown
- pow
###

###
Strings
- length
- substring
- replace
- split
- join
- trim
- uppercase
- lowercase
###

###
Arrays
- transform (e.g. map)
- aggregate (e.g. reduce)
- length
- pop
- push
- includes
- find
- insert (at a specific index)
- delete
- filter
###

###
Maps
- getAtKey
- lookup # lookup(user, "profile.location.address.city")

###
Structs
- omit
- lookup
###