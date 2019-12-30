//
//  LocalFileQueue.swift
//  Services
//
//  Created by Michael Lee on 12/30/19.
//

import Foundation

let localFileQueue = LocalFileQueue()

class LocalFileQueue: OperationQueue {
    override init() {
        super.init()
        maxConcurrentOperationCount = 10
    }

}
