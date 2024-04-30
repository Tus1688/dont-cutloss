//
//  FillInfo.swift
//  dont-cutloss
//
//  Created by user on 29/04/24.
//

import SwiftUI

struct FillInfo: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isPresented: Bool
    let result: FinanceQuoteSearchResult
    
    @State private var quantity: Decimal = 0
    @State private var avgPrice: Decimal = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    StockCard(result: result)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke()
                        )
                        .padding()
                    Form {
                        Section(header: Text("Fill in the information")) {
                            HStack {
                                if !quantity.isNaN {
                                    Text("Quantity")
                                }
                                TextField("Quantity", value: $quantity, formatter: NumberFormatter())
                                    .multilineTextAlignment(quantity.isNaN ? .leading : .trailing)
                            }
                            HStack {
                                if !avgPrice.isNaN {
                                    Text("Average Price")
                                }
                                TextField("Average Price", value: $avgPrice, formatter: NumberFormatter())
                                    .multilineTextAlignment(avgPrice.isNaN ? .leading : .trailing)
                            }
                        }
                    }
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveData()
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func saveData() {
        let newPortfolioItem = Portfolio(context: viewContext)
        newPortfolioItem.id = UUID()
        newPortfolioItem.symbol = result.symbol ?? ""
        newPortfolioItem.quantity = NSDecimalNumber(decimal: quantity)
        newPortfolioItem.averagePrice = NSDecimalNumber(decimal: avgPrice)
        newPortfolioItem.timestamp = Date()
        newPortfolioItem.exchange = result.exchange ?? ""
        newPortfolioItem.shortName = result.shortname ?? ""
        newPortfolioItem.quoteType = result.quoteType ?? ""
        newPortfolioItem.sector = result.sector ?? ""
        
        withAnimation {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    struct previewFillInfo: View {
        @State private var isPresented = true
        let result: FinanceQuoteSearchResult = FinanceQuoteSearchResult(
            symbol: "BBCA.jk",
            shortname: "Bank Central Asia Tbk.",
            longname: "PT Bank Central Asia Tbk.",
            quoteType: "EQUITY",
            exchange: "JKT",
            sector: "Financial Services"
        )
        var body: some View {
            NavigationStack {
                Text("Hello world from FillInfo")
                Button("Toggle") {
                    isPresented.toggle()
                }
            }
            .sheet(isPresented: $isPresented, content: {
                NavigationStack {
                    FillInfo(isPresented: $isPresented, result: result)
                }
            })
        }
    }
    return previewFillInfo().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
