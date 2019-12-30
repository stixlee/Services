//
//  Api+Login.swift
//  Services
//
//  Created by Michael Lee on 12/30/19.
//

extension Api {

  open func login(username: String,
                  password: String,
                  success: @escaping ((_ user: User?) -> Void),
                  failure: @escaping OperationFailure) {

    loadUsers(
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

  func loadUsers(succces: @escaping OperationSuccess<[User]>,
                 failure: @escaping OperationFailure) {
    let file = FileDescriptor(name: "users", type: "json")
    let operation = LocalFileOperation<[User]>(file: file, success: succces, failure: failure)
    operation.allowCompletionInBackground = false
    localFileQueue.addOperation(operation)
  }

}
