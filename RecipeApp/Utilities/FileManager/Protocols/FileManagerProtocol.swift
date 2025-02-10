//
//  FileManagerProtocol+FileManagerExtension.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/7/25.
//

import Foundation

protocol FileManagerProtocol {
    func createDirectory(
        at url: URL,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey: Any]?
    ) throws
    
    func urls(
        for directory: FileManager.SearchPathDirectory,
        in domainMask: FileManager.SearchPathDomainMask
    ) -> [URL]
    
    func fileExists(atPath path: String) -> Bool
    func contentsOfDirectory(atPath path: String) throws -> [String]
    func removeItem(at url: URL) throws
    func write(data: Data, to url: URL) throws
    func read(from url: URL) throws -> Data
}
