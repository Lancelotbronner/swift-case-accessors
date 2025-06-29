@attached(member, names: arbitrary)
public macro CaseAccessors() = #externalMacro(module: "CaseAccessorsMacros", type: "CaseAccessorsMacro")

@attached(member, names: arbitrary)
public macro CaseConditionals() = #externalMacro(module: "CaseAccessorsMacros", type: "CaseConditionalsMacro")
