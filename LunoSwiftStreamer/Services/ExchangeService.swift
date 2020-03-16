//
//  ExchangeService.swift
//  Luno
//
//  Created by Mpendulo Ndlovu on 2020/03/16.
//  Copyright © 2020 Luno. All rights reserved.
//

import Foundation

class ExchangeService: StreamingService {
    let streamer: Streaming
    
    init(streamer: Streaming) {
        self.streamer = streamer
    }
    
    func streamOrderBook(pair: CurrencyPair,
                completion: @escaping (Snapshot?, Update?) -> Void,
                failure: ((StreamError) -> Void)?) {
        streamer.stream(resource: pair.code,
                        completion: completion,
                        failure: failure)
    }
}
