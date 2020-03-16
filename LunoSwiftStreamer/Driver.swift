//
//  Driver.swift
//  LunoStreamer
//
//  Created by Mpendulo Ndlovu on 2020/03/16.
//  Copyright © 2020 Elefantel. All rights reserved.
//

import Cocoa

class Driver: NSViewController {
    private let bot = Bot(.sandpit)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stream()
    }
    
    func stream() {
        let exchangeService = ExchangeService(streamer: Streamer(endpoint: .exchange))
        exchangeService.streamOrderBook(
            pair: .btczar,
            completion: { [weak self] snapshot, update in
                self?.bot.didReceive(snapshot: snapshot, update: update)
        }, failure: { print($0.message)})
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
