# This is a example of a single line comment

###
This is an example of a multiline comment
###

###
Variable declaration
###

str name = "Brandon"
num age = 41
num[] scores = [50, 100, 75] # access = scores[0]
str[] words = ["test1", "test2", "test3"]
bool isCool = true # could be false (no null or nil or undefined in BrandoScript)
(num, str) person = (41, "Brandon") # access = person[0]
User[] user = [
  User { id: 1, name: "Brandon" }
]
mut unknown[] values = []

(num or str)[] values = ["Brandon", 41, "old"]

str greet(str name) {
  "Hello, \(name)!"
}

(num)(num, num) add = (num a, num b) {
  a + b
}

`mut` keyword means the variable is mutable; immutable by default
mut num age = 41
age = 42

`unknown` keyword means the type is unknown and will require type guards

###
Types
###

type generic Result(O, E) = ok(O) or err(E)

type AddFn = (num)(num, num)
AddFn add = (num a, num b) {
  a + b
}

###
Maps
###

# map(<KeyType>, <ValueType>)
map(str, unknown) user = {
  name: "Brandon",
  age: 41,
  isAdmin: true
}
maybe str name = user at "name"
if (name is str) {
  print("Hello, \(name)!")
}

# To add or update, the entire map must be mut (no support for fine-grained mut control)
mut map(str, str) simple = {
  key1: "value1"
}
simple at "key2" = "value2"

###
Structs
###

struct User = {
  num id
  str name
  (num or str) thing

  str greet() {
    "Hello, \(self.name)!"
  }

  void rename(str updatedName) {
    self.name = updatedName
  }
}

User user = User {
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

generic type Result(O, E) = ok(O) or err(E)
type MathResult = Result(num, Error)

MathResult divide(num a, num b) {
  if b equals 0 {
    return err(Error { code: 1, message: "Cannot divide by 0" })
  }

  ok(a / b)
}

MathResult divideAndProcess(num a, num b) {
  attempt {
    num result = divide(a, b)
    ok(result)
  }

  handle(e) {
    err(e)
  }
}

MathResult res = divideAndProcess(10, 0)

match res {
  ok(val) {
    print("Result: \(val)")
  }
  err(e) {
    print("Error: \(error)")
  }
}

# Default values
struct User {
  num id
  str name = "Test" # default value
  bool isAdmin = false
}

# Extending structs
struct AdminUser extends User {
  bool isAdmin = true # can override a default value
  str[] roles = ["admin"] # add new properties/methods not on parent
}

# Struct shape (built-in, hidden, readonly property)
struct User {
  num id
  str name
}

# User.shape = { num id, str name }

###
Destructuring
By default, destructuring copies and does not remove
###

num[] coords = [1, 2]
[num as x, num as y] = coords
# x = 1, y = 2

{ num id, str name } = user
# id = user.id, name = user.name

(num, num) coords = (1, 2)
(num as x, num as y) = coords
# x = 1, y = 2

{ num id as userId, str name as userName } = coords
# userId = user.id, userName = user.name

num[] numbers = [1, 2, 3, 4, 5]
[num as x, rest num[] as remaining] = numbers

{ num id, rest unknown as remaining } = user

# Using Omit
import { Omit } from std.struct
{ num id, rest Omit(User, ["id"]) as remaining } = user

###
If/Else/Etc.
###

if user.id equals 1 {
  print("Hello")
} else {
  print("Goodbye")
}

if not user.id equals 1 {
  print("Not user 1!")
}

if user.id is num {
  print("User ID is a number")
}

# Type checking
if user is User {
  print("user is an instance of User!")
}

if (user.id equals 1 and user.name equals "Brandon") {
  print("You are Brandon!")
}

if (user.name equals "Brandon" or user.name equals "Brando") {
  print("You are cool!")
}

bool isActive = true
if not isActive {
  print("Go outside, nerd!")
}

for str key in user {
  if not user at key equals "Brandon" {
    print("You're not Brandon!")
  }
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

# Modular checks uses the "mod" keyword
if 2 mod 2 equals 0 {
  print("No remainder")
}

###
Maybe
###

import { length } from std.arr
maybe (num, num) find(num[] arr, num target) {
  for num i from 0 until arr.length(arr) {
    if arr[i] equals target {
      return yes((i, target))
    }
  }
  return no
}

maybe (num, num) result = find([1, 2, 3], 3)

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

# Typing
(ReturnType)(ArgType...) # (num)(str, num)

str greet(str name) {
  "Hello, \(name)!"
}

# makeCounter returns a function that returns a number and accepts no args
((num)())(num) makeCounter(num start) {
  mut num count = start

  num next() {
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

generic O[] transform(I, O)(I[] arr, (O)(I) transformer) {
  mut O[] result = []

  for I item in array {
    result = push(result, transformer(item))
  }

  result
}

generic bool includes(T)(T[] arr, T element) {
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
(str or num) doTheThing((str or num) val) {
  if val is num {
    return num * 2
  }

  return "Hello, \(val)!"
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

# structs
User user = { id: 1, name: "Brandon" }
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
Importing
###

import { length, trim } from std.str
import { bar, foo } from "./utils.bs"
import { thing as otherThing } from "./things.bs"
import * as numLib from std.num

export str bar() { "Hello!" }

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
Structs
- keys
###