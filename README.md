# Case Accessors

This package offers macros that ease enum pattern-matching.
This version was forked from [rhysforyou's repository](https://github.com/rhysforyou/swift-case-accessors) in order to add additional features.

## Overview

The `@CaseAccessors` macro adds computed properties to easily retrieve and modify associated values.

```swift
@CaseAccessors 
enum TestEnum {
    case stringValue(String)
    case intValue(Int)
    case boolValue(Bool)
}

var enumValue = TestEnum.stringValue("Hello, Macros!")

if let stringValue = enumValue.stringValue {
    print(stringValue) // Prints "Hello, Macros!"
}

enumValue.intValue = 4
print(enumValue) // Prints "intValue(4)"
```

The `@CaseConditionals` macro adds boolean computed properties that simplify conditional checks and assignments.

```swift
@CaseConditionals 
enum TestEnum {
    case one, two, three
}

var enumValue = TestEnum.one

if enumValue.isOne {
    enumValue.isTwo = true
}
print(enumValue) // Prints "two"

// The above is equivalent to
if case .one = enumValue {
    enumValue = .two
}
```
