//
//  RecentTradesViewModel.swift
//  Fllipster
//
//  Created by spantar on 2025/6/6.
//

import SwiftUI
import Combine

class RecentTradesViewModel: ObservableObject {
    @Published var trades: [Trade] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        WebSocketManager.shared.tradesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTrades in
                self?.addNewTrades(newTrades)
            }
            .store(in: &cancellables)
        
        WebSocketManager.shared.connect()
    }
    
    private func addNewTrades(_ newTrades: [Trade]) {
        trades = (newTrades + trades).prefix(30).map { $0 }
    }
    
    func removeHighlight(for id: UUID) {
        if let index = trades.firstIndex(where: { $0.id == id }) {
            trades[index].highlight = false
        }
    }
}

