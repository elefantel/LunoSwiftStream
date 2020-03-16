//
//  StreamError.swift
//  Elefantel
//
//  Created by Mpendulo Ndlovu on 2020/03/16.
//  Copyright © 2020 Elefantel. All rights reserved.
//

import Foundation

enum StreamError: LocalizedError {
    case stringDataError
    case stringDecodingError
    case dataDecodingError
    case custom(String)
    
    init(rawValue: String) {
        self = .custom(rawValue)
    }
    
    init(_ error: Error) {
        self = .custom(error.localizedDescription)
    }
    
    var message: String {
        switch self {
        case .stringDataError:
            return "Couldn't create message string data"
        case .stringDecodingError:
            return "Couldn't decode message string data"
        case .dataDecodingError:
            return "Couldn't decode message data"
        case .custom(let message):
            return message
        }
    }
}
