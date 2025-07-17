//
//  APIResponse.swift
//  Domain
//
//  Created by JDeoks on 7/14/25.
//


public struct APIResponse<T: Codable>: Codable {
  public let code: String
  public let result: T?
  public let timeStamp: String
}