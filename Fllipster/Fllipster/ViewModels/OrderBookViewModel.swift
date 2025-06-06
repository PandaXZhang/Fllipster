//
//  OrderBookViewModel.swift
//  Fllipster
//
//  Created by spantar on 2025/6/5.
//

import Foundation
import Combine

class OrderBookViewModel: ObservableObject {
    @Published var bids: [OrderBookItem] = []
    @Published var asks: [OrderBookItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    var maxQty: Double {
        let allQtys = bids.map { $0.qty } + asks.map { $0.qty }
        return allQtys.max() ?? 1.0
    }
    
    init() {
        WebSocketManager.shared.orderBookSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.processItems(items)
            }
            .store(in: &cancellables)
        
        WebSocketManager.shared.connect()
    }
    
    private func processItems(_ items: [OrderBookItem]) {
        bids = items.filter { $0.side == "Buy" }.sorted { $0.price > $1.price }
        asks = items.filter { $0.side == "Sell" }.sorted { $0.price < $1.price }
    }
}
