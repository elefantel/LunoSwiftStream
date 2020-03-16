//
//  Streaming.swift
//  Elefantel
//
//  Created by Mpendulo Ndlovu on 2020/03/16.
//  Copyright © 2020 Elefantel. All rights reserved.
//

import Foundation

protocol Streaming: AnyObject {
    var timer: Timer? { get }
    var session: URLSession { get }
    var webSocketTask: URLSessionWebSocketTask? { get }
    var endpoint: Endpoint { get }
    func stream<T: Codable, U: Codable>(resource: String,
                                        completion: ((T?, U?) -> Void)?,
                                        failure: ((StreamError) -> Void)?)
    func receive<T: Codable, U: Codable>(completion: ((T?, U?) -> Void)?,
                                         failure: ((StreamError) -> Void)?)
    func cancel()
    func ping()
}

enum Endpoint {
    case exchange
    
    var url: String {
        switch self {
        case .exchange:
            return "wss://ws.luno.com/api/1/stream"
        }
    }
}

protocol StreamingService: AnyObject {
    var streamer: Streaming { get }
}

//TODO: implement streamer exponential backoff
class Streamer: NSObject, Streaming {
    var timer: Timer?
    let endpoint: Endpoint
    var session: URLSession
    static let timeout = 60.0
    private let privilege: Privilege
    var webSocketTask: URLSessionWebSocketTask?
    
    init(endpoint: Endpoint,
         session: URLSession = URLSession.shared,
         privilege: Privilege = .trading) {
        self.session = session
        self.endpoint = endpoint
        self.privilege = privilege
    }
    
    func stream<T: Codable, U: Codable>(resource: String,
                                        completion: ((T?, U?) -> Void)?,
                                        failure: ((StreamError) -> Void)?) {
        guard
            let url = URL(string: endpoint.url)?
            .appendingPathComponent(resource)
            else { return }
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
    
        guard
            let credentialsData = try? JSONEncoder().encode(privilege.credentials),
            let credentialsJSON = String(
                data: credentialsData,
                encoding: .ascii)
            else { return }
        webSocketTask?.send(.string(credentialsJSON)) { error in
            print(error?.localizedDescription ?? "")
        }
        ping()
        receive(completion: completion, failure: failure)
    }
    
    func receive<T: Codable, U: Codable>(completion: ((T?, U?) -> Void)?,
                                         failure: ((StreamError) -> Void)?) {
        webSocketTask?.receive { result in
            switch result {
            case .failure(let error):
                failure?(StreamError(error))
            case .success(let message):
                switch message {
                case .data(let data):
                    if let model = try? JSONDecoder().decode(T.self, from: data) {
                        completion?(model, nil)
                    } else if let model = try? JSONDecoder().decode(U.self, from: data) {
                        completion?(nil, model)
                    } else {
                        failure?(StreamError.dataDecodingError)
                    }
                case .string(let string):
                    if string.count < 3 {
                        print("server keep-alive")
                        self.receive(completion: completion, failure: failure)
                        return
                    }
                    guard let data = string.data(using: .utf8) else {
                        print(string)
                        failure?(StreamError.stringDataError)
                        return
                    }
                    if let model = try? JSONDecoder().decode(T.self, from: data) {
                        completion?(model, nil)
                    } else if let model = try? JSONDecoder().decode(U.self, from: data) {
                        completion?(nil, model)
                    } else {
                        print("string char count: \(string.count)")
                        print("\(string)\ncould not convert to \(T.self) or \(U.self)")
                        failure?(StreamError.stringDecodingError)
                    }
                @unknown default:
                    fatalError("Unknown response")
                }
                self.receive(completion: completion, failure: failure)
            }
        }
    }
    
    func cancel() {
        print("cancel...")
        timer?.invalidate()
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func ping() {
        print("ping...")
        webSocketTask?.sendPing(pongReceiveHandler: { [weak self] error in
            if let error = error {
                print("ping error: \(error.localizedDescription)")
            }
            print("pong...")
            self?.timer = Timer.scheduledTimer(
                withTimeInterval: Streamer.timeout,
                repeats: true,
                block: { _ in
                    self?.ping()
            })
        })
    }
}

//TODO: make delegate a little clever & connected
extension Streamer: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        print("web socket connected")
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        print("web socket disconnected")
    }
}
