//
//  Privileges.swift
//  Luno
//
//  Created by Mpendulo Ndlovu on 2020/03/16.
//  Copyright © 2020 Luno. All rights reserved.
//

import Foundation

enum Privilege {
    case root /** mother of all privileges */
    case trading /** create orders */
    case readonly /** read only */
    
    var credentials: Credentials {
        switch self {
        case .root:
            return Credentials(
                apiKeyID: "###read-from-secret-file###",
                apiKeySecret: "###read-from-secret-file###")
        case .readonly:
            return Credentials(
                apiKeyID: "###read-from-secret-file###",
                apiKeySecret: "###read-from-secret-file###")
        case .trading:
            return Credentials(
                apiKeyID: "###read-from-secret-file###",
                apiKeySecret: "###read-from-secret-file###")
        }
    }
}
