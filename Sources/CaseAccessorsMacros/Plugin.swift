import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main struct Plugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		CaseAccessorsMacro.self,
		CaseConditionalsMacro.self,
	]
}
