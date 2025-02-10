//
//  FileManagerError.swift
//  RecipeApp
//
//  Created by Christian Pichardo on 2/7/25.
//

import Foundation

private enum Constants {
    static let directoryCreationFailedErrorText = "Failed to create directory: "
    static let fileSaveFailedErrorText = "Failed to save file: "
    static let fileDeletionFailedErrorText = "Failed to delete file: "
    static let directoryDeletionFailedErrorText = "Failed to delete directory: "
    static let retrieveFilesInDirectoryFailedErrorText = "Failed to retrieve files in directory: "
    static let fileReadFailedErrorText = "Failed to read file disk"
}

enum FileManagerError: Error {
    case directoryCreationFailed(Error)
    case fileSaveFailed(Error)
    case fileDeletionFailed(Error)
    case directoryDeletionFailed(Error)
    case retrieveFilesInDirectoryFailed(Error)
    case fileReadFailed
    
    var errorDescription: String {
        switch self {
        case .directoryCreationFailed(let error):
            return Constants.directoryCreationFailedErrorText + error.localizedDescription
        case .fileSaveFailed(let error):
            return Constants.fileSaveFailedErrorText + error.localizedDescription
        case .fileDeletionFailed(let error):
            return Constants.fileDeletionFailedErrorText + error.localizedDescription
        case .directoryDeletionFailed(let error):
            return Constants.directoryDeletionFailedErrorText + error.localizedDescription
        case .retrieveFilesInDirectoryFailed(let error):
            return Constants.retrieveFilesInDirectoryFailedErrorText + error.localizedDescription
        case .fileReadFailed:
            return Constants.fileReadFailedErrorText
        }
    }
}
