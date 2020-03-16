//
//  Models.swift
//  Elefantel
//
//  Created by Mpendulo Ndlovu on 2020/03/16.
//  Copyright © 2020 Elefantel. All rights reserved.
//

import Foundation

struct OrderBookEntry: Codable {
    var id: String
    var price: String
    var volume: String
}

struct TradeUpdate: Codable {
    var base: String
    var counter: String
    var orderId: String
    var makerOrderId: String
    var takerOrderId: String
    
    enum CodingKeys: String, CodingKey {
        case base
        case counter
        case orderId = "order_id"
        case makerOrderId = "maker_order_id"
        case takerOrderId = "taker_order_id"
    }
}

struct CreateUpdate: Codable {
    var type: String
    var price: String
    var volume: String
    var orderId: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case price
        case volume
        case orderId = "order_id"
    }
}

struct DeleteUpdate: Codable {
    var orderId: String
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
    }
}

struct Snapshot: Codable {
    var status: String
    var sequence: String
    var timestamp: Int64
    var asks: [OrderBookEntry]
    var bids: [OrderBookEntry]
}

struct Order: Codable {
    var id: String
    var price: String
    var volume: String
}

struct OrderBook: Codable {
    var status: String
    var sequence: Int
    var asks: OrderBookEntry
    var bids: OrderBookEntry
}

struct StatusUpdate: Codable {
    var status: String
}

struct Update: Codable {
    var sequence: String
    var timestamp: Int64
    var tradeUpdates: [TradeUpdate]?
    var createUpdate: CreateUpdate?
    var deleteUpdate: DeleteUpdate?
    var statusUpdate: StatusUpdate?
    
    enum CodingKeys: String, CodingKey {
        case sequence
        case timestamp
        case tradeUpdates = "trade_updates"
        case createUpdate = "create_update"
        case deleteUpdate = "delete_update"
        case statusUpdate = "status_update"
    }
}

struct Credentials: Codable {
    var apiKeyID: String
    var apiKeySecret: String
    
    enum CodingKeys: String, CodingKey {
        case apiKeyID = "api_key_id"
        case apiKeySecret = "api_key_secret"
    }
}

enum CurrencyPair {
    case btczar
    case ethzar
    case xrpzar
    case ethbtc
    case bchbtc
    case xrpbtc
    
    init(rawValue: String) {
        switch rawValue {
        case "XBTZAR": self = .btczar
        case "ETHZAR": self = .ethzar
        case "XRPZAR": self = .xrpzar
        case "ETHXBT": self = .ethbtc
        case "BCHXBT": self = .bchbtc
        case "XRPXBT": self = .xrpbtc
        default: self = .btczar
        }
    }
    
    var code: String {
        switch self {
        case .btczar: return "XBTZAR"
        case .ethzar: return "ETHZAR"
        case .xrpzar: return "XRPZAR"
        case .ethbtc: return "ETHXBT"
        case .bchbtc: return "BCHXBT"
        case .xrpbtc: return "XRPXBT"
        }
    }
}
