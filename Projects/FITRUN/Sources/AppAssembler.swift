//
//  AppAssembler.swift
//  FITRUN
//
//  Created by dong eun shin on 7/18/25.
//

import Swinject
import Presentation
import Domain
import Data

public final class AppAssembler {
  public static let shared = AppAssembler()
  public let assembler: Assembler

  public init() {
    assembler = Assembler([
      DataAssembly(),
      DomainAssembly(),
      PresentationAssembly()
    ])
  }

  public var resolver: Resolver {
    return assembler.resolver
  }
}
