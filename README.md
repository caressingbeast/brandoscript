# BrandoScript

BrandoScript is a modern, statically-typed programming language that is designed to compile directly to JavaScript. The language prioritizes readability, simplicity, and safety in both type handling and error management. BrandoScript is still in its specification phase, with no current compiler or runtime available. This repository outlines the language's syntax, features, and functionality.

Currently, BrandoScript is a specification and is not yet available for installation or compilation. Future updates will provide implementation details and tooling for compiling and running BrandoScript code.

## Key Features (Spec)

- **Immutability by default**: Variables are immutable unless explicitly marked as mutable with the `mutable` keyword.
- **First-class functions**: Functions are first-class citizens, enabling clean, flexible code structures.
- **Advanced types**: Supports primitives, structs, optional types, unions, and more.
- **Pattern matching**: Easily match and destructure complex data structures (including lists, maps, and structs).
- **Safe access with `with`**: Access nested fields and handle optional values safely, with automatic fallback to defaults.
- **Result-based error handling**: No exceptions—use the `Result` type to handle errors and success states in a structured way.
- **Async/Await**: Asynchronous programming built-in, leveraging `Result` types for robust error handling.

## Language Features

### Variables

- Immutable by default (`define`), mutable with `mutable` keyword.
- Variables cannot be reassigned; use `set` for assignments.
  
```brandoscript
define name: String = "Brandon"  
define mutable status: String = "active"  
set status = "inactive" # Valid, status is mutable
```

### Functions

- Functions are first-class, and their types are declared on creation.
- Supports default parameters and custom return types.

```brandoscript
define greet = takes (a: Number, n: String) returns String {  
  "Hello, #{n}! You are #{a} years old."  
}
```

### Types and Structs

- Built-in support for structs, optional types, unions, and advanced composition.
  
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

- Powerful `which` expression for pattern matching on lists, structs, and more.

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

- Built-in async/await support with `Result` types for structured error handling.

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

## Development and Next Steps

BrandoScript is currently in the specification phase. There is no installation or compilation process yet. The next step will be to develop a compiler, runtime, and associated tooling to make BrandoScript executable.

## Contributing

If you want to contribute to BrandoScript, feel free to fork the repository, review the language spec, and submit your suggestions or improvements.

## License

This project does not have a license at the moment. Please check back for updates in the future.
