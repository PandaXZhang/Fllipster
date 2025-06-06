//
//  WebSocketManager.swift
//  Fllipster
//
//  Created by spantar on 2025/6/4.
//

import Combine
import Foundation

class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    static let shared = WebSocketManager()
    private var webSocketTask: URLSessionWebSocketTask?
    private let url = URL(string: "wss://ws.bitmex.com/realtime")!
    
    let orderBookSubject = PassthroughSubject<[OrderBookItem], Never>()
    let tradesSubject = PassthroughSubject<[Trade], Never>()
    
    func connect() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
        
        subscribeToChannels()
    }
    
    private func subscribeToChannels() {
        let orderBookMsg = """
        {"op": "subscribe", "args": ["orderBookL2:XBTUSD"]}
        """
        let tradesMsg = """
        {"op": "subscribe", "args": ["trade:XBTUSD"]}
        """
        
        [orderBookMsg, tradesMsg].forEach { message in
            webSocketTask?.send(.string(message)) { error in
                if let error = error { print("Subscribe error: \(error)") }
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(.string(let text)):
                self?.handleMessage(text)
            case .failure(let error):
                //TODO: error handler
                print("WebSocket error: \(error)")
            default: break
            }
            self?.receiveMessage()
        }
    }
    
    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
        
        if let table = json["table"] as? String {
            switch table {
            case "orderBookL2":
                processOrderBookData(json)
            case "trade":
                processTradeData(json)
            default: break
            }
        }
    }
    
    private func processOrderBookData(_ json: [String: Any]) {
        var bids: [OrderBookItem] = []
        var asks: [OrderBookItem] = []
        
        if let data = json["data"] as? [[String: Any]] {
            data.forEach { item in
                guard let side = item["side"] as? String,
                      let price = item["price"] as? Double,
                      let size = item["size"] as? Double else { return }
                
                let orderItem = OrderBookItem(
                    price: price,
                    qty: size,
                    side: side
                )
                
                if side == "Buy" {
                    bids.append(orderItem)
                } else {
                    asks.append(orderItem)
                }
            }
        }
        
        // sort and prefix
        let sortedBids = bids.sorted { $0.price > $1.price }.prefix(20)
        let sortedAsks = asks.sorted { $0.price < $1.price }.prefix(20)
        
        // publish
        orderBookSubject.send(Array(sortedBids) + Array(sortedAsks))
    }
    
    private func processTradeData(_ json: [String: Any]) {
        var trades: [Trade] = []
        
        if let data = json["data"] as? [[String: Any]] {
            data.forEach { item in
                guard let price = item["price"] as? Double,
                      let size = item["size"] as? Double,
                      let timestamp = item["timestamp"] as? String,
                      let side = item["side"] as? String else { return }
                
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [
                    .withInternetDateTime,
                    .withFractionalSeconds
                ]
                if let date = dateFormatter.date(from: timestamp) {
                    trades.append(Trade(
                        price: price,
                        qty: size,
                        timestamp: date,
                        side: side,
                        highlight: true
                    ))
                }
            }
        }
        
        
        let sortedTrades = trades.sorted { $0.timestamp > $1.timestamp }.prefix(30)
        tradesSubject.send(Array(sortedTrades))
    }
}
