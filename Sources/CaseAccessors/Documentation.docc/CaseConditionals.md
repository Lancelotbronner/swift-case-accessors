# ``CaseConditionals``

Adds new members to an `enum` that let you perform a quick boolean check on an instance's `case`. For an enum with a case `one`, a method `isOne` will be generated that returns true when an instance's value is `one`.

E.g.:

```swift
@CaseConditionals 
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

	var isNone: Bool {
		get {
			if case .none = self { true } else { false }
		}
		set {
			if newValue { self = .none }
		}
	}

	var isSome: Bool {
		if case .some = self { true } else { false }
	}

	var isOptional: Bool {
		if case .optional = self { true } else { false }
	}

	var isTuple: Bool {
		if case .tuple = self { true } else { false }
	}
}
```
