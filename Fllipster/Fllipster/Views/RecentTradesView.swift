//
//  RecentTradesView.swift
//  Fllipster
//
//  Created by spantar on 2025/6/6.
//

import SwiftUI

struct RecentTradesView: View {
    @StateObject private var vm = RecentTradesViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(vm.trades) { trade in
                    TradeRow(trade: trade)
                        .listRowInsets(EdgeInsets())
                        .background(trade.highlight ? (trade.side == "Buy" ? Color.green.opacity(0.2) : Color.red.opacity(0.2)) : Color.clear)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                vm.removeHighlight(for: trade.id)
                            }
                        }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct TradeRow: View {
    let trade: Trade
    
    var body: some View {
        HStack {
            Text(trade.timestamp, style: .time)
            Spacer()
            Text(String(format: "%.4f", trade.qty))
            Spacer()
            Text(String(format: "%.1f", trade.price))
                .foregroundColor(trade.side == "Buy" ? .green : .red)
        }
        .padding()
        .frame(height: 40)
    }
}
