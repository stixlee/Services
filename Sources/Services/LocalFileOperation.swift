//
//  LocalFileOperation.swift
//  Services
//
//  Created by Michael Lee on 12/30/19.
//

import Foundation

public typealias OperationSuccess<T> = (T) -> Void
public typealias OperationFailure = (FileError) -> Void

public enum FileError: Error {
    case readError(String)
}

public struct FileDescriptor {
  public let name: String
  public let type: String
  public let bundle: Bundle
}
class LocalFileOperation<T>: Operation where T:Codable {

    var successClosure: OperationSuccess<T>
    var failureClosure: OperationFailure
    var file: FileDescriptor

    var sessionTask: URLSessionTask?

    override var isFinished: Bool {
        get {
            let wasFinished: Bool
            propertyLock.lock()
            wasFinished = _isFinished
            propertyLock.unlock()

            return wasFinished
        }
        set {
            willChangeValue(forKey: "isFinished")
            propertyLock.lock()
            _isFinished = newValue
            propertyLock.unlock()
            didChangeValue(forKey: "isFinished")
        }
    }

    override var isCancelled: Bool {
        get {
            let wasCancelled: Bool
            propertyLock.lock()
            wasCancelled = _isCancelled
            propertyLock.unlock()
            return wasCancelled
        }
        set {
            willChangeValue(forKey: "isCancelled")
            propertyLock.lock()
            _isCancelled = newValue
            propertyLock.unlock()
            didChangeValue(forKey: "isCancelled")
        }
    }

    override var isExecuting: Bool {
        get {
            let wasExecuting: Bool
            propertyLock.lock()
            wasExecuting = _isExecuting
            propertyLock.unlock()
            return wasExecuting
        }
        set {
            willChangeValue(forKey: "isExecuting")
            propertyLock.lock()
            _isExecuting = newValue
            propertyLock.unlock()
            didChangeValue(forKey: "isExecuting")
        }
    }

    override var isAsynchronous: Bool {
        return true
    }

    var allowCompletionInBackground: Bool = false

    private var _isExecuting: Bool = false
    private var _isFinished: Bool = false
    private var _isCancelled: Bool = false
    private var propertyLock = NSRecursiveLock()
    private var cancelLock = NSRecursiveLock()

    // MARK: - Initilization and lifecycle
    /// Default initialization method.
    init(file: FileDescriptor, success: @escaping OperationSuccess<T>, failure: @escaping OperationFailure, allowBackgroundCompletion: Bool = false) {

        self.file = file
        successClosure = success
        failureClosure = failure
        allowCompletionInBackground = allowBackgroundCompletion
        super.init()
    }



    override func start() {
        guard !isCancelled else {
            finish()
            return
        }

        isExecuting = true

        do {
          guard let fileURL = file.bundle.url(forResource: file.name, withExtension: file.type) else {
                failureClosure(FileError.readError("Failed to Read from file"))
                return
            }
            let data = try Data(contentsOf: fileURL, options: [])
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.iso8601
            do {
                let response = try decoder.decode(T.self, from: data)
                successClosure(response)
            } catch {
                failureClosure(FileError.readError("Failed to Read from file"))
            }

        } catch {
            assert(true, "*** Could Not read user data")
        }
    }

    // Start the actual network request
    override func cancel() {
        isCancelled = true
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }
}
