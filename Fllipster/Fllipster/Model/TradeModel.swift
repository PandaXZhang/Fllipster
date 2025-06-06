//
//  TradeModel.swift
//  Fllipster
//
//  Created by spantar on 2025/6/6.
//

import Foundation

struct Trade: Identifiable {
    let id: UUID = UUID()
    let price: Double
    let qty: Double
    let timestamp: Date
    let side: String // "Buy" or "Sell"
    var highlight: Bool = false
}
