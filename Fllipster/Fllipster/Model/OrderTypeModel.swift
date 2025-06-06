//
//  OrderTypeModel.swift
//  Fllipster
//
//  Created by spantar on 2025/6/5.
//

import Foundation

enum OrderType {
    case bid
    case ask
}

struct OrderBookItem: Identifiable {
    let id = UUID()
    let price: Double
    let qty: Double
    let side: String // "Buy" or "Sell"
    var total: Double = 0
}
