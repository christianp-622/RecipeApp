//
//  ImageCacheProtocol.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/7/25.
//

import Foundation
import SwiftUI

protocol ImageCacheProtocol {
    func addImage(forKey key: String, value: UIImage)
    func getImage(forKey key: String) -> UIImage?
    func clearCache()
}
