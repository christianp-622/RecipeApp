//
//  FileManager+Extensions.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/8/25.
//

import Foundation

extension FileManager: FileManagerProtocol {
    func write(data: Data, to url: URL) throws {
        try data.write(to: url)
    }
    
    func read(from url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }
}
