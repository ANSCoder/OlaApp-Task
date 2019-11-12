//
//  Promise.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import Foundation

class Promise<Value>: Future<Value> {
    
    init(value: Value? = nil) {
        super.init()
        
        // If the value was already known at the time the promise
        // was constructed, we can report the value directly
        result = value.map(Result.success)
    }
    
    func resolve(with value: Value) {
        result = .success(value)
    }
    
    func reject(with error: Error) {
        result = .failure(error)
    }
}
