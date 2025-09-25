import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct CaseConditionalsMacro: MemberMacro {
	public static func expansion(
		of attribute: AttributeSyntax,
		providingMembersOf declaration: some DeclGroupSyntax,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax]  {
		guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
			context.diagnose(Diagnostic(
				node: Syntax(attribute),
				message: CaseConditionalsDiagnostic.expectedEnum
			))
			return []
		}

		let members = enumDeclaration.memberBlock.members
		let caseDeclarations = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
		let caseElements = caseDeclarations.flatMap(\.elements)

		return caseElements.map { caseElement in
			var identifier = caseElement.name.text
			identifier = identifier.prefix(1).uppercased() + identifier.dropFirst()

			if caseElement.parameterClause != nil {
				return """
				public var is\(raw: identifier): Bool {
					if case .\(caseElement.name) = self { true } else { false }
				}
				"""
			} else {
				return """
				public var is\(raw: identifier): Bool {
					get { 
						if case .\(caseElement.name) = self { true } else { false }
					}
					set {
						if newValue { self = .\(caseElement.name) }
					}
				}
				"""
			}
		}
	}
}

enum CaseConditionalsDiagnostic: String, DiagnosticMessage {
	case expectedEnum

	var severity: DiagnosticSeverity {
		switch self {
		case .expectedEnum: .error
		}
	}

	var message: String {
		switch self {
		case .expectedEnum: "'@CaseConditionals' can only be applied to 'enum'"
		}
	}

	var diagnosticID: MessageID {
		MessageID(domain: "CaseAccessorMacros", id: "\(Self.self)-\(rawValue)")
	}
}
