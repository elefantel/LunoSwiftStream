//
//  Bot.swift
//  Elefantel
//
//  Created by Mpendulo Ndlovu on 2020/03/16.
//  Copyright © 2020 Elefantel. All rights reserved.
//

import Foundation

enum Heuristic {
    case sandpit
    case gridlock
    case breakout
    case minmaxim
}

//TODO: Implement heuristics
//Explore:
// - moving average derivatives
// - hamming distance (spread) velocity
// - volume velocity
// - candle ratio velocity
// - support vectors
// - goldman rule
// - ofcourse I still love you (sentiment)

//Refine:
// - distint or juxtaposed?
// - ocislu: twit twats or east dragons?

class Bot {
    private let strategy: Heuristic
    
    init(_ strategy: Heuristic = .sandpit) {
        self.strategy = strategy
    }
    
    func didReceive(snapshot: Codable?, update: Codable?) {
        if let snapshot = snapshot {
            print(snapshot)
        } else if let update = update {
            print(update)
        }
    }
}
