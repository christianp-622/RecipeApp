//
//  CacheFileStorageProtocol.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/7/25.
//

import Foundation
import SwiftUI

protocol CacheFileStorageProtocol {
    func saveImageToDisk(_ image: UIImage, forKey key: String) throws
    func loadImageFromDisk(forKey key: String) throws -> UIImage?
    func clearDiskCache() throws
}
