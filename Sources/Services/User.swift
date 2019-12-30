//
//  User.swift
//  Services
//
//  Created by Michael Lee on 12/30/19.
//

import Core

public struct User {
  public var username: String
  public var password: String
  public var avatarUrl : String
  public var name: String
  public var handle: String?

  public func isMatch(for username: String, password: String) -> Bool {
    return ((username.uppercased() == self.username.uppercased()) && password ==  self.password)
  }
}

extension User: Model { }
