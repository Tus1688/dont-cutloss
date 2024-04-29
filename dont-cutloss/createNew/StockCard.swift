//
//  StockCard.swift
//  dont-cutloss
//
//  Created by user on 29/04/24.
//

import SwiftUI

struct StockCard: View {
    public var result: FinanceQuoteSearchResult
    
    var body: some View {
        HStack {
            Text(result.symbol?.prefix(7) ?? "")
                .font(.title3)
                .fontWeight(.bold)
            VStack (alignment: .leading){
                if result.sector != nil {
                    Text(result.sector ?? "")
                }
                if result.shortname != nil {
                    Text(result.shortname ?? "")
                }
            }
            .font(.caption2)
            Spacer()
            VStack (alignment: .trailing){
                if result.quoteType != nil {
                    Text(result.quoteType ?? "")
                }
                if result.exchange != nil {
                    Text(result.exchange ?? "")
                }
            }
            .font(.caption2)
        }
    }
}

#Preview {
    struct previewStockCard: View {
        var body: some View {
            StockCard(result: FinanceQuoteSearchResult(symbol: "AAPL", shortname: "Apple Inc.", longname: "Apple Inc.", quoteType: "EQUITY", exchange: "NASDAQ", sector: "Technology"))
        }
    }
    return previewStockCard()
}
