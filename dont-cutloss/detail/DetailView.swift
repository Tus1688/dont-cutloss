//
//  DetailView.swift
//  dont-cutloss
//
//  Created by user on 02/05/24.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    let symbol: Portfolio
    
    @State private var data: FinanceSummaryDetailResult = FinanceSummaryDetailResult()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("hello world")
            }
            .onAppear {
                loadData()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text(symbol.shortName ?? "")
                            .font(.callout)
                            .fontWeight(.bold)
                        HStack (spacing: 4) {
                            Text(symbol.quoteType ?? "")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text(symbol.exchange ?? "")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("search")
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("edit")
                    }) {
                        Image(systemName: "pencil")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("trash")
                    }) {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
    
    private func loadData() {
        YFinance.fetchSummaryData(identifier: symbol.symbol ?? "", selection: [QuoteSummarySelection.supported]) { data, err in
            if err != nil {
//                print(err)
                return
            }
//            print(data)
        }
    }
}

//#Preview {
//    struct previewDetailView: View {
//        let value = Portfolio(context: PersistenceController.shared.container.viewContext)
//        value.symbol = "AAPL"
//
//        var body: some View {
//            NavigationStack {
//                DetailView(symbol: value)
//            }
//        }
//    }
//    return previewDetailView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
