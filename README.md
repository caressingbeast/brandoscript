# BrandoScript

BrandoScript is a fun, statically-typed programming language that compiles to JavaScript. It's all about keeping things simple, readable, and safe when working with types and errors. Right now, BrandoScript is just a spec — no compiler or runtime yet, but the idea is to eventually bring it to life.

This repo outlines the language's syntax and features as they stand.

## Cool Features (Spec)

- **Immutability by default**: Variables are immutable unless you explicitly mark them as `mutable`.
- **First-class functions**: Functions are just like any other value, so you can pass them around.
- **Fancy types**: Includes primitive types, structs, unions, optionals, and more.
- **Pattern matching**: Match and destructure complex data structures (like lists, maps, and structs) with ease.
- **Safe access with `with`**: Use `with` to safely access nested values with fallbacks, no more `null` errors.
- **Error handling with Results**: No exceptions — just use the `Result` type for structured error handling.
- **Async/Await**: Built-in async/await support with structured error handling using `Result`.

## Language Features

### Variables

- Immutable by default (`define`), mutable with the `mutable` keyword.
- Variables can’t be reassigned, but you can use `set` for that.

```brandoscript
define name: String = "Brandon"  
define mutable status: String = "active"  
set status = "inactive" # This works because `status` is mutable
```

### Functions

- Functions are first-class, and you define their types upfront.
- You can even set default parameters.

```brandoscript
define greet = takes (a: Number, n: String) returns String {  
  "Hello, #{n}! You are #{a} years old."  
}
```

### Types and Structs

- You can define structs, optional types, unions, and even compose new types from others.

```brandoscript
define User = {  
  id: Number,  
  name: String  
}

define user: User = {  
  id: 1,  
  name: "Brandon"  
}
```

### Pattern Matching

- Use `which` to match against lists, structs, or any kind of data.

```brandoscript
which user {  
  { id, name } {  
    print("#{name}, #{id}")  
  }  
  _ {  
    print("Unknown user")  
  }  
}
```

### Async/Await

- Full async/await support, with `Result` types for handling errors.

```brandoscript
define main = takes () async returns Nothing {  
  define response = await fetchData("https://example.com")  
  which response {  
    Ok { data } {  
      print("Success: #{data}")  
    }  
    Error { error } {  
      print("Failed: #{error}")  
    }  
  }  
}
```

## Next Steps

Right now, BrandoScript is just a spec. There's no way to run it yet, but in the future, the goal is to get a compiler and runtime going.

## Contributing

Got ideas? Feel free to fork this repo, review the language spec, and send in suggestions or pull requests!

## License

No license yet! Check back later for updates.
