//
//  Helper.swift
//  SwiftTestsUIKit
//
//  Created by Глеб Хамин on 13.01.2025.
//

import Foundation

func warningMessage(error: NetworkError) -> String {
    switch error {
    case .noData:
        return "Data cannot be found at this URL"
    case .badRequest:
        return "An error occurred while processing the request"
    case .decodingError:
        return "Can't decode data"
    }
}
