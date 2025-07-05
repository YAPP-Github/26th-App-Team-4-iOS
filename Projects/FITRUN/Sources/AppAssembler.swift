//
//  AppAssembler.swift
//  FITRUN
//
//  Created by dong eun shin on 7/3/25.
//  Copyright © 2025 com.yapp. All rights reserved.
//

import Swinject

import Data
import Presentation
import Domain

final class AppAssembler {
  public static let shared = AppAssembler()
  public let resolver: Resolver
  private let assembler: Assembler

  private init() {
    assembler = Assembler([
      LaunchAssembler(),
    ])
    resolver = assembler.resolver
  }
}
