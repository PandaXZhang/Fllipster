//
//  ContentView.swift
//  Fllipster
//
//  Created by spantar on 2025/6/4.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TabButton(title: "Order Book", index: 0, selectedTab: $selectedTab)
                TabButton(title: "Recent Trades", index: 1, selectedTab: $selectedTab)
            }
            .padding(.top, 8)
            .background(Color(.systemBackground))
            
            TabView(selection: $selectedTab) {
                OrderBookView()
                    .tag(0)
                RecentTradesView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct TabButton: View {
    let title: String
    let index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button(action: {
            selectedTab = index
        }) {
            Text(title)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(selectedTab == index ? Color.blue : Color.clear)
                .foregroundColor(selectedTab == index ? .white : .primary)
                .cornerRadius(8)
        }
    }
}


#Preview {
    ContentView()
}
