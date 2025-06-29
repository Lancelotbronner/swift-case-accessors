# ``CaseAccessors/CaseAccessors()``

Adds accessors for each case of an `enum` that have associated values

E.g. the following code:

```swift
@CaseAccessors
enum TestEnum {
	case none
	case some(String)
	case optional(Int?)
	case tuple(name: String, Int)
}
```

Expands out to the following:

```swift
enum TestEnum {
	case none
	case some(String)
	case optional(Int?)
	case tuple(name: String, Int)

	var some: String? {
		get {
			if case let .some(value) = self { value } else { nil }
		}
		set {
			if let newValue { self = .some(newValue) }
		}
	}

	var optional: Int? {
		get {
			if case let .optional(value) = self { value } else { nil }
		}
		set {
			if let newValue { self = .optional(newValue) }
		}
	}

	var tuple: (first: Bool, Int)? {
		get {
			if case let .tuple(a, b) = self { (a, b) } else { nil }
		}
		set {
			if let newValue { self = .tuple(first: newValue.first, newValue.1) }
		}
	}
}
```
