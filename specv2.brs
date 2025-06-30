###
Variables and Variable Declarations
All variables are immutable by default
To make a variable mutable, add the `mutable` keyword after `define`
`define` is first when declaring any new varable, `mutable` is an optional keyword but must come immediately after `define`
###

# Primitive types
define age: Number = 41
define isTrue: Bool = true
define name: String = "Brandon"

define mutable status: String = "active"

set name = "Brando" # invalid, not mutable
set status = "inactive" # all good!

# All variable value re-assignment requires the `set` keyword

# Functions (all functions are first-class functions; no function declarations)
# Because the type is declared when the function is created, no need to specify the type after the name
define greet = (a: Number, n: String): String {
  "Hello, #{n}! You are #{a} years old." # implicit return
}

greet(41, "Brandon") # "Hello, Brandon! You are 41 years old."

# just does stuff, no return value
define log = (message: String): Nothing {
  print(message)
}

define oops = (): Nothing {
  return 42 # invalid, cannot return a value from a `Nothing` function
}

# Default parameters
define log = (message: String or "Hello"): Nothing {
  print(message)
}

# Default parameters with a union
define log = (message: (Number or String) or "Hello"): Nothing {
  print(message);
}

log("Yo!") # => "Yo!"
log(42) # => 42
log() # => "Hello"

# Custom returns
define getCoords = (): (Number, Number) {
  (10, 20)
}

# Lists
define numbers: [Number] = [1, 2, 3]
define users: [User] = [{}, {}, {}] # update with examples
define whatever: [?] = [1, "Brandon", true]
define union: [Number or String] = [1, "Brandon"]

# Maps
# Maps use String keys by default, so the key type is omitted but still allowed
define map: {String} = {
  name: "Brandon"
}

# Values could be anything
define map: {?} = {
  name: "Brandon"
}

# Values could be multiple types
define map: {Bool or Number or String} = {
  name: "Brandon"
}

# Tuples
define coords: (Number, Number) = (10, 20)

# Types
define User = {
  age: Number,
  name: String
}

# Using the type
define user: User = {
  age: 41,
  name: "Brandon"
}

# Alternatively
define user: { age: Number, name: String } = {
  age: 41,
  name: "Brandon"
}

# Optional types
define User = {
  id: Number,
  name: String,
  profile: optional { # `profile` is optional
    username: String, # `username` is required and must be a string if `profile` exists
    website: optional String # `website` is optional
  }
}
define user: User = {
  id: 1,
  name: "Brandon"
}

# Accessing an optional property
# `with` is used for safe optional chaining with fallback for assignment expressions
# Don't use `with` in conditionals
define username: String = user with profile with username or user.name # if no, default to "Brandon"
define username: String = user with profile with username or "No Username" # if no, default to "No Username"
define username: optional String = user with profile with username # safe because `username` is optional

***
Lists
***

define list: [Number] = [1, 2, 3]
define list: [?] = [1, "2", true, {}]

# Accessing data
# Zero-based indexing
list[0] # = 1

# Because a value at a particular index could be `absent`, best practice to provide fallbacks
define first: Number = list[0] or 0

###
If/Else
###

define x: Number = 12
if x < 10 {
  print(x)
} else {
  print("x > 10")
}

define isAdmin: Bool = true
if isAdmin {
  # do something
}

if x equals 12 {
  # do something
}

if username equals "Brando" {
  # do something
}

# Type checks
# Type checking is structural
# Type checks check for presence and type
if x is Number {
  # do something
}

define User = {
  id: Number,
  name: String
}
define user: User = {
  id: 1,
  name: "Brandon"
}

if user is User {
  # do something
}

define mapUser: {?} = {
  name: "Brandon"
}

if mapUser["name"] is String as name {
  print("name = ${name}")
}

# Presence/checking
# Since some things can return `absent`
define user: {String} = {
  name: "Brandon"
}

if user["name"] is present {
  # do something
}

if user["name"] is absent {
  # do something
}

# Negation
# Use `not` as a prefix keyword
if not user is User {
  # do something
}

if not isAdmin {
  # do something
}

if not x equals 12 {
  # do something
}

# Casting value to a variable
# Casting only allowed on items with a previously declared type
if user.name is present as username {
  print(username) # username = user.name; user.name already explicitly typed
}

# Chained checks
# `and`/`or`
if user.profile is present as p and p.role is String and p.role equals "admin" {
  # do something
}

# Alternatively
if (user.profile is present as p and p.role is String and p.role equals "admin") {
  # do something
}

if x < 5 or x > 10 {
  # do something
}

# Assignment from `if`
define username: String = if user.profile is present as p and p.username is present {
  p.username
} else { "Anonymous" }


###
Structural types (structs)
Instances must be `mutable` to change any value
###
define User = {
  id: Number,
  name: String
}

define user: User = {
  id: 1,
  name: "Brandon"
}
set user.name = "Brando" # invalid, not mutable

define mutable user: User = {
  id: 1,
  name: "Brando"
}
set user.name = "Brando" # valid

# Partially defined structs
define User = {
  id: Number,
  name: String,
  ...: ? # unknown
  # ...: String
  # ...: Bool or String
  # ...: [Number]
  # ...: {String}
}

print(user.name) # safe, statically defined
print(user.whatever) # unsafe

# Optional fields
define User = {
  id: Number,
  name: String,
  status: optional ("active" or "inactive"), # `status` is optional, but if present can only be in the union
  profile: optional { # `profile` is optional
    username: String, # `username` is required if `profile`
    url: optional String # `url` is optional
  }
}

###
Maps
By default, keys are strings so it can be left off in declaration ({String, String})
###

# A map where all values are strings
define user: {String} = {
  id: "1"
}

# A map of unknown values
define user: {?} = {
  whatever: "whatever"
}

# This applies to any type, whether defined (e.g. User, [Number], {?}), or a single type or multiple (e.g. {Bool or String})

# Fetching data
# Because maps are dynamic, all fetched values need a presence check (`is` or `has`, or `with`)
define name: optional String = user["name"]
if name is String {
  # do something
}

# `optional` flag is required if no fallback provided
define name: String = user with "name" or "No Name"

if user has "name" {
  # do something
}

define name: String = user with "name" or "Brandon" # safely traverse and assign a fallback
# with is only for assignment, not for logic checks

define name: String = user["name"] # invalid, must be `optional String` or use `with` and a fallback

###
Loops
###

define x: Number = 0
while x < 5 {
  print(x)
  set x = x + 1
}

# Lists
define numbers: [Number] = [1, 2, 3]
each n in numbers {
  print(n)
}

each (i, n) in numbers {
  print("#{i}: #{n}")
}
# i is implicitly a Number, type of n is known from when `numbers` was defined

define whatever [?] = [1, "2", true]
each w in whatever {
  if w is Number as n {
    print("number: #{n}")
  } else if w is String as s {
    print("string: #{s}")
  } else {
    print("other: #{w}")
  }
}

# Maps
define user: {String} = {
  id: "1",
  name: "Brandon"
}

each (key, value) in user { # key is implicity of type String
  print("#{key} = #{value}")
}

# Structs
each (field, value) in user {
  print("#{field}: #{value}")
}

# Skip/exit
each n in numbers {
  if n equals 3 {
    exit each  # stop loop early
  }
  if n mod 2 equals 0 {
    skip  # skip even numbers before 3
  }
  print(n)  # prints: 1, then stops at 3
}

# Ranges

# Inclusive
each i in 0 to 5 {
  print(i)
}

# Exclusive
each i in 0 until 5 {
  print(i)
}

###
Destructuring
###

# Tuples
define coords: (Number, Number) = (10, 20)
define (x, y): (Number, Number) = coords
print(x)  # 10
print(y)  # 20

# Maps
define settings: {?} = {
  fontSize: 14,
  theme: "light"
}

define { fontSize or 12 as size: Number, theme or "dark": String } = settings

print(theme) # "dark"... would equal "dark" if `theme` didn't exist or wasn't a string
print(size) # 14... would equal 12 if `fontSize` didn't exist or wasn't a number

# Structs
# Structs require a type annotation that the instance inherited from
define User = {
  id: Number,
  name: String,
  status: optional ("active" or "inactive")
}

define user: User = {
  id: 42,
  name: "Brandon"
}

define { id as userId, name, status or "inactive" }: User = user

print(userId) # 42
print(status) # "inactive" (default used since missing)

define User = {
  id: Number,
  name: String,
  email: optional String,
  status: optional String
}

define mutable user: User = {
  id: 1,
  name: "Alice"
  # status and email are missing here, which is valid
}

define { id, &remaining }: User = user # `remaining` is a variable name, could be `rest` or whatever

print(id)         # 1
print(remaining)  # { name: "Alice", status: absent, email: absent }

# Accessing optional fields safely
if remaining.status is present {
  print(remaining.status)
}

print(remaining.email or "hello@example.com")

# Lists
# List require a type annotation
define [x, y, &remaining]: [Number] = [10]
# x = 10
# y = `absent`
# `remaining` = []

###
Error Handling
BrandoScript does not support `throw`. Errors must be handled via the built-in `Result` type
###
define Result of (T, E) =
  Ok { data: T }
  or Error { error: E }

define divide = (a: Number, b: Number): Result of (Number, String) {
  if b equals 0 {
    return Error { error: "Cannot divide by zero" }
  }
  return Ok { data: a / b }
}

###
Which
The `which` expression lets you examine a value and execute code based on which pattern it matches. It’s ideal for working with tagged unions, structs, literals, and more, providing clear, concise, and expressive control flow.
which <expression> {
  <pattern_1> {
    <block_1>
  }
  <pattern_2> {
    <block_2>
  }
  ...
  _ {
    <fallback_block>
  }
}
###

# `Result` matching
which result {
  Ok { data } {
    print("data: #{data}")
  }
  Error { error } {
    print("error: #{error}")
  }
  _ {
    print("Unknown")
  }
}

# Structs
define User = {
  id: Number,
  name: String,
  status: optional String
}

define user: User = {
  id: 1,
  name: "Alice"
}

which user {
  { id, name, status } {
    print("#{name}, #{id}, #{status or 'unknown'}") # would print `absent` for status without fallback
  }
  _ {
    print("Not a User")
  }
}

# Literals
define x: Number = 0
which x {
  0 {
    print("0")
  }
  1 {
    print("1")
  }
  _ {
    print(x)
  }
}

# Assignment
define result = divide(10, 0) # `divide` returns a `Result`

define message: String = which result {
  Ok { data } {
    "Success: #{data}"
  }
  Error { error } {
    "Error: #{error}"
  }
  _ {
    "Unknown result"
  }
}

print(message) # Should be "Error: Cannot divide by zero"

# Maps
# Because maps are dynamic, types must be specified
# `which` checks for presence and type match
# You can't access &rest in `which`
define user: {?} = {
  age: 41,
  name: "Brandon",
  status: "active"
}

which user {
  { age: Number, name: String } {
    print("Hello, #{name}!")
  }
}

which user {
  { age: String, name: String } {
    # arm is skipped because age is a Number
  }
}

# Lists

# Matches a list of just 2 numbers
which numbers {
  [x: Number, y: Number] {
    # do something
  }
  _ {
    # do something else
  }
}

# Match first element, capture rest
which numbers {
  [head: Number, &tail: [Number]] { # only matches if `head` is a Number and the rest of the list is all numbers
    # do something
  }
}

# Match with an array of at least 2 elements, ignore the rest
which numbers {
  [a: Number, b: Number, ...] {
    # do something
  }
}

# Wildcard to ignore specific elements
which numbers {
  [_, _, third: Number, _] { # matches on a list of 4 elements, of which the element[2] is a Number
    print(third)
  }
}

# Advanced match
which numbers {
  [first: Number, ...] if first > 0 { # only matches if `first` is a Number and greater than 0
    # do something
  }
}


define mixed: [?] = [1, "two", true, 4]

which mixed {
  # First element is Number, second is String, rest any
  [first: Number, second: String, &rest: [?]] {
    # do something
  }
  
  # First element is String or Bool
  [head: (String or Bool), &tail: [?]] {
    # do something
  }
  
  # Fallback
  _ {
    # do something
  }
}

# Guards with pattern matching
which user {
  { status as s: String } if s equals "active" { 
    print("User is active!")
  }

  { status as s: String } if s equals "inactive" {
    print("User is inactive!")
  }

  _ {
    print(user.status)
  }
}

# Tuples
which point {
  (x: Number, _, z: Number) {
    # do something
  }
}

###
Importing/Exporting
Applies to types, values, functions — anything defined.
###

# Exporting
export define User = {
  id: Number,
  name: String
}

export define getUser = (id: Number): User {
  { id: id, name: "Brando" }
}

# Importing
import User, getUser from "./user"
import all from "./user"
import getUser as fetchUser from "./user"
import length, print from std
import print as log from std

###
Type Aliases and Composition
###

# Built-in `Result` type
# BS supports generic types
define Result of (O, E) = 
  Ok { data: O } or
  Error { error: E }

define ID = Number

# Base struct
define Base = {
  id: ID,
  createdAt: String
}

# User composed with Base
define User = Base with {
  name: String
}

# Admin composed with User
define Admin = User with {
  permissions: [String]
}

define Timestamped = {
  createdAt: String,
  updatedAt: optional String
}

define Post = Base with Timestamped with {
  body: String,
  title: String
}

# If `with` leads to a conflict (same key with different types) it leads to a compilation error

### 
Async/Await
###
define async main = (): Nothing {
  define response = await fetchData("https://example.com") # async function returning a `Result`

  which response {
    Ok { data } {
      print("Success: #{value}")
    }
    Error { error } {
      print("Failed: #{reason}")
    }
  }
}

# returns a `Result` with a String `Ok` or a String `Error`
define fetchData = (url: String): async Result of (Response, String) {
  # body
}

# Built-in `Response` type
define Response = {
  ok: Bool,
  status: Number,
  headers: {?},
  json: async returns Result of ({?}, String),
  text: async returns Result of (String, String)
}

# Provide stdlib helpers to wrap a lot of API patterns

###
Loop Comprehension
###

define numbers: [Number] = [1, 2, 3, 4, 5, 6]
define evenSquares: [Number] = each num in numbers where num mod 2 equals 0 do num * num
# evenSquares = [4, 16, 36]

define whatever: [Number] = each num in numbers
  where num mod 2 equals 0 or num mod 3 equals 0 # if `num` / 2 or `num` / 3 has no remainder...
  and where num > 2 # and `num` > 2
  do num * num # then square `num`
# whatever = []