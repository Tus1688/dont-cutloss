//
//  StockCard.swift
//  dont-cutloss
//
//  Created by user on 29/04/24.
//

import SwiftUI

struct StockCard: View {
    public var result: FinanceQuoteSearchResult
    
    private var sector: String {
        if result.sector?.isEmpty == true {
            return result.quoteType?.capitalized ?? ""
        }
        return result.sector ?? ""
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack (alignment: .leading) {
                if sector != "" {
                    Text(sector)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                if result.shortname != nil {
                    Text(result.shortname ?? "")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            Spacer()
            VStack (alignment: .trailing){
                if result.quoteType != nil {
                    Text(result.quoteType ?? "")
                        .foregroundStyle(result.quoteType == "EQUITY" ? .blue : .orange)
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
