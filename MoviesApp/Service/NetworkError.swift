//
//  NetworkError.swift
//  MoviesApp
//
//  Created by Wajeeh Ul Hassan on 07/09/2022.
//

import Foundation

enum NetworkError: Error {
    case urlFailure
    case dataFailure
    case serverResponse(Int)
    case decodeError(Error)
    case other(Error)
}


extension NetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .urlFailure:
            return NSLocalizedString("The url is not correct", comment: "URL Failure")
        case .dataFailure:
            return NSLocalizedString("The data is empty or corrupted", comment: "Data Failure")
        case .serverResponse(let statusCode):
            return NSLocalizedString("Server could not be reached, status code: \(statusCode)", comment: "Server Response Failure")
        case .decodeError:
            return NSLocalizedString("The data was fetched, but failed to serialize. Contact your failure of a developer", comment: "Decode Error")
        case .other:
            return NSLocalizedString("Unknown Error. Contact support", comment: "Other")

        }
        
        
    }
    
    
}
