//
//  OrderBookView.swift
//  Fllipster
//
//  Created by spantar on 2025/6/6.
//
import SwiftUI

struct OrderBookView: View {
    @StateObject private var vm = OrderBookViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                // buy
                VStack(spacing: 0) {
                    ForEach(vm.bids) { item in
                        OrderBookRow(item: item, type: .bid, maxQty: vm.maxQty)
                    }
                }
                
                // sell
                VStack(spacing: 0) {
                    ForEach(vm.asks) { item in
                        OrderBookRow(item: item, type: .ask, maxQty: vm.maxQty)
                    }
                }
            }
        }
    }
}

struct OrderBookRow: View {
    let item: OrderBookItem
    let type: OrderType
    let maxQty: Double
    
    var body: some View {
        HStack {
            if type == .bid {
                Text(String(format: "%.1f", item.price))
                    .foregroundColor(.green)
                Spacer()
                Text(String(format: "%.4f", item.qty))
            } else {
                Text(String(format: "%.4f", item.qty))
                Spacer()
                Text(String(format: "%.1f", item.price))
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
        .frame(height: 40)
        .background(
            GeometryReader { geometry in
                let width = geometry.size.width * CGFloat(item.qty / maxQty)
                if type == .bid {
                    Color.green.opacity(0.1)
                        .frame(width: width, alignment: .trailing)
                } else {
                    Color.red.opacity(0.1)
                        .frame(width: width, alignment: .leading)
                }
            }
        )
    }
}
