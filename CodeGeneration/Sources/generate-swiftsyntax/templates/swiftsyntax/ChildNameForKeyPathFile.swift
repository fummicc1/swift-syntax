//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax
import SwiftSyntaxBuilder
import SyntaxSupport
import Utils

let childNameForKeyPathFile = SourceFileSyntax(leadingTrivia: copyrightHeader) {
  try! FunctionDeclSyntax(
    """
    /// If the keyPath is one from a layout structure, return the property name
    /// of it.
    internal func childName(_ keyPath: AnyKeyPath) -> String?
    """
  ) {
    try! SwitchExprSyntax("switch keyPath") {
      for node in NON_BASE_SYNTAX_NODES where !node.isSyntaxCollection {
        for child in node.children {
          SwitchCaseSyntax(
            """
            case \\\(raw: node.type.syntaxBaseName).\(raw: child.swiftName):
              return \(literal: child.swiftName)
            """
          )
        }
      }
      SwitchCaseSyntax(
        """
        default:
          return nil
        """
      )
    }
  }
}
