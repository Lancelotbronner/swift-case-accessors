import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct CaseAccessorsMacro: MemberMacro {
	public static func expansion(
		of attribute: AttributeSyntax,
		providingMembersOf declaration: some DeclGroupSyntax,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax] {
		guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
			context.diagnose(Diagnostic(
				node: Syntax(attribute),
				message: CaseAccessorsDiagnostic.expectedEnum
			))
			return []
		}

		let members = enumDeclaration.memberBlock.members
		let caseDeclarations = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
		let caseElements = caseDeclarations.flatMap(\.elements)
		let caseElementsWithAssociatedValues = caseElements.filter { caseElement in
			caseElement.parameterClause != nil
		}

		guard !caseElementsWithAssociatedValues.isEmpty else {
			context.diagnose(Diagnostic(
				node: Syntax(attribute),
				message: CaseAccessorsDiagnostic.noCasesWithAssociatedValues
			))
			return []
		}

		return caseElementsWithAssociatedValues.map { caseElement in
			let associatedValues = caseElement.parameterClause!.parameters

			let returnTypeSyntax: TypeSyntax
			let valueBindings: String
			let returnValue: String
			let assignmentValue: String

			if associatedValues.count == 1, associatedValues.first!.type.is(OptionalTypeSyntax.self) {
				returnTypeSyntax = associatedValues.first!.type
				valueBindings = "value"
				returnValue = "value"
				assignmentValue = "newValue"
			} else if associatedValues.count == 1 {
				returnTypeSyntax = TypeSyntax(OptionalTypeSyntax(wrappedType: associatedValues.first!.type))
				valueBindings = "value"
				returnValue = "value"
				assignmentValue = "newValue"
			} else {
				let tupleType = TupleTypeSyntax(
					elements: TupleTypeElementListSyntax {
						for associatedValue in associatedValues {
							TupleTypeElementSyntax(
								firstName: associatedValue.firstName,
								secondName: associatedValue.secondName,
								colon: associatedValue.colon,
								type: associatedValue.type)
						}
					}
				)

				returnTypeSyntax = TypeSyntax(OptionalTypeSyntax(wrappedType: tupleType))
				valueBindings = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "x", "y", "z"].lazy
					.prefix(associatedValues.count)
					.joined(separator: ", ")
				returnValue = "(\(valueBindings))"

				let names = associatedValues.enumerated().map { (i, value) in
					value.firstName?.text ?? value.secondName?.text ?? "\(i)"
				}
				assignmentValue = names
					.map { ($0.first?.isLetter ?? false) ? "\($0): newValue.\($0)" : "newValue.\($0)" }
					.joined(separator: ", ")
			}

			return """
			public var \(caseElement.name): \(returnTypeSyntax) {
				get {
					if case let .\(caseElement.name)(\(raw: valueBindings)) = self { \(raw: returnValue) } else { nil } 
				}
				set {
					if let newValue { self = .\(caseElement.name)(\(raw: assignmentValue)) }
				}
			}
			"""
		}
	}
}

enum CaseAccessorsDiagnostic: String, DiagnosticMessage {
	case expectedEnum
	case noCasesWithAssociatedValues

	var severity: DiagnosticSeverity {
		switch self {
		case .expectedEnum: .error
		case .noCasesWithAssociatedValues: .warning
		}
	}

	var message: String {
		switch self {
		case .expectedEnum: "'@CaseAccessors' can only be applied to 'enum'"
		case .noCasesWithAssociatedValues: "'@CaseAccessors' was applied to an enum without any cases containing associated values"
		}
	}

	var diagnosticID: MessageID {
		MessageID(domain: "CaseAccessorMacros", id: "\(Self.self)-\(rawValue)")
	}
}

