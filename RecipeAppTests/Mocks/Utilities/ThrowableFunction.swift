//
//  ThrowableFunction.swift
//  RecipeAppTests
//
//  Created by Christian Pichardo on 2/8/25.
//

import Foundation

// Still under work, might set up some stub functions that will wrap functions under test to allow us to apply the property wrapper

@propertyWrapper
struct ThrowableFunction<T> {
    
    var shouldThrow: Bool
    var error: Error
    
    private var function: () throws -> T

    init(wrappedValue: @escaping () throws -> T, shouldThrow: Bool = false, error: Error) {
        self.shouldThrow = shouldThrow
        self.error = error
        self.function = wrappedValue
    }
    
    var wrappedValue: () throws -> T {
        get {
            return {
                if self.shouldThrow {
                    throw self.error
                } else {
                    return try self.function()
                }
            }
        }
    }
    
    // Allow us to modify the properties shouldThrow and error
    // someClass.$someFunction.shoudThrow = true/false
    var projectedValue: ThrowableFunction<T> {
        get {
            self
        }
        set {
            self = newValue
        }
    }
}
