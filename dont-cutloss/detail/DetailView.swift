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
    
    let ticker: Portfolio
    
    @State var isLoading = false
    
    @State private var data: FinanceSummaryDetailResult = FinanceSummaryDetailResult()
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                        .foregroundStyle(.white)
                } else {
                    VStack {
                        if let summary = data.summaryDetail {
                            SummaryDetailView(detail: summary)
                                .padding()
                        }
                        if let trend = data.recommendationTrend?.trend {
                            AnalystRecommendationView(trend: trend)
                                .padding()
                        }
                    }
                }
            }
            .task {
                isLoading = true
                await loadData()
                isLoading = false
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
                        Text(ticker.shortName?.prefix(25) ?? "")
                            .font(.callout)
                            .fontWeight(.bold)
                        HStack (spacing: 4) {
                            Text(ticker.quoteType ?? "")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text(ticker.exchange ?? "")
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
    
    private func loadData() async {
        let (fetchedData, error) = YFinance.syncFetchSummaryData(identifier: ticker.symbol ?? "", selection: [QuoteSummarySelection.supported])
        if let error = error {
            // TODO: show toast / alert
            print("Error fetching data: \(error)")
            return
        }
        data = fetchedData!
    }
}

