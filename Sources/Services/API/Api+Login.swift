//
//  Api+Login.swift
//  Services
//
//  Created by Michael Lee on 12/30/19.
//

import Foundation

extension Api {

  open func login(username: String,
                  password: String,
                  fileUrl: URL,
                  success: @escaping ((_ user: User?) -> Void),
                  failure: @escaping OperationFailure) {

    loadUsers(from: fileUrl,
      succces: { users in
        for user in users {
          if user.isMatch(for: username, password: password) {
            success(user)
            return
          }
        }
        success(nil)
      },
      failure: failure)
  }

  func loadUsers(from url: URL,
                 succces: @escaping OperationSuccess<[User]>,
                 failure: @escaping OperationFailure) {
    let operation = LocalFileOperation<[User]>(url: url, success: succces, failure: failure)
    operation.allowCompletionInBackground = false
    localFileQueue.addOperation(operation)
  }

}
