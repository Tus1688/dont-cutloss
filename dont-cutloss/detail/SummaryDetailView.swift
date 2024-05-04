//
//  SummaryDataView.swift
//  dont-cutloss
//
//  Created by user on 04/05/24.
//

import SwiftUI

struct SummaryDetailView: View {
    let detail: summaryDetail
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                helperView(title: "Previous Close", fmtValue: detail.previousClose?.fmt ?? "-")
                helperView(title: "Open", fmtValue: detail.open?.fmt ?? "-")
                helperView(title: "Bid", fmtValue: (detail.bid?.fmt ?? "-") + " x " + (detail.bidSize?.fmt ?? "-"))
                helperView(title: "Ask", fmtValue: (detail.ask?.fmt ?? "-") + " x " + (detail.askSize?.fmt ?? "-"))
                helperView(title: "Day Range", fmtValue: (detail.dayLow?.fmt ?? "-") + " - " + (detail.dayHigh?.fmt ?? "-"))
                helperView(title: "52 Week Range", fmtValue: (detail.fiftyTwoWeekLow?.fmt ?? "-") + " - " + (detail.fiftyTwoWeekHigh?.fmt ?? "-"))
                helperView(title: "Volume", fmtValue: detail.volume?.longFmt ?? "-")
                helperView(title: "Avg. Volume", fmtValue: detail.averageVolume?.longFmt ?? "-")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 6) {
                helperView(title: "Market Cap (Intraday)", fmtValue: detail.marketCap?.fmt ?? "-")
                helperView(title: "Beta (5Y Monthly)", fmtValue: detail.beta?.fmt ?? "-")
                helperView(title: "PE ratio (TTM)", fmtValue: detail.trailingPE?.fmt ?? "-")
                helperView(title: "PE ratio (Forward)", fmtValue: detail.forwardPE?.fmt ?? "-")
                helperView(title: "PS ratio (TTM)", fmtValue: detail.priceToSalesTrailing12Months?.fmt ?? "-")
                helperView(title: "Dividend Rate", fmtValue: detail.dividendRate?.fmt ?? "-")
                helperView(title: "Dividend Yield", fmtValue: detail.dividendYield?.fmt ?? "-")
                helperView(title: "Ex-Dividend Date", fmtValue: detail.exDividendDate?.fmt ?? "-")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct helperView: View {
    let title: String
    let fmtValue: String
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.gray)
            Text(fmtValue)
                .font(.caption)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    struct previewSummaryDetail: View {
        let detail: summaryDetail = summaryDetail(
            previousClose: ratioChunkDetail(raw: 169.3, fmt: "169.30"),
            open:  ratioChunkDetail(raw: 173.39, fmt: "173.39"),
            dayLow: ratioChunkDetail(raw: 173.12, fmt: "173.12"),
            dayHigh: ratioChunkDetail(raw: 176.03, fmt: "176.03"),
            regularMarketPreviousClose: ratioChunkDetail(raw: 169.3, fmt: "169.30"),
            regularMarketOpen: ratioChunkDetail(raw: 173.39, fmt: "173.39"),
            regularMarketDayLow: ratioChunkDetail(raw: 173.12, fmt: "173.12"),
            regularMarketDayHigh: ratioChunkDetail(raw: 176.03, fmt: "176.03"),
            dividendRate: ratioChunkDetail(raw: 0.96, fmt: "0.96"),
            dividendYield: ratioChunkDetail(raw: 0.0055, fmt: "0.55%"),
            exDividendDate: ratioChunkDetail(raw: 1707436800, fmt: "2024-02-09"),
            payoutRatio: ratioChunkDetail(raw: 0.14770001, fmt: "14.77%"),
            fiveYearAvgDividendYield: ratioChunkDetail(raw: 0.74, fmt: "0.74"),
            beta: ratioChunkDetail(raw: 1.276, fmt: "1.28"),
            trailingPE: ratioChunkDetail(raw: 26.940994, fmt: "26.94"),
            forwardPE: ratioChunkDetail(raw: 26.051052, fmt: "26.05"),
            volume: ratioChunkDetail(raw: 66144936, fmt: "66.14M", longFmt: "66,144,936"),
            regularMarketVolume: ratioChunkDetail(raw: 66144936, fmt: "66.14M", longFmt: "66,144,936"),
            averageVolume: ratioChunkDetail(raw: 61731277, fmt: "61.73M", longFmt: "61,731,277"),
            averageVolume10days: ratioChunkDetail(raw: 54265890, fmt: "54.27M", longFmt: "54,265,890"),
            averageDailyVolume10Day: ratioChunkDetail(raw: 54265890, fmt: "54.27M", longFmt: "54,265,890"),
            bid: ratioChunkDetail(raw: 173.68, fmt: "173.68"),
            ask: ratioChunkDetail(raw: 173.68, fmt: "173.68"),
            bidSize: ratioChunkDetail(raw: 200, fmt: "200"),
            askSize: ratioChunkDetail(raw: 200, fmt: "200"),
            marketCap: ratioChunkDetail(raw: 2679169613824, fmt: "2.68T", longFmt: "2,679,169,613,824"),
            fiftyTwoWeekLow: ratioChunkDetail(raw: 164.08, fmt: "164.08"),
            fiftyTwoWeekHigh: ratioChunkDetail(raw: 199.62, fmt: "199.62"),
            priceToSalesTrailing12Months: ratioChunkDetail(raw: 6.9461446, fmt: "6.95"),
            fiftyDayAverage: ratioChunkDetail(raw: 171.36188, fmt: "171.36"),
            twoHundredDayAverage: ratioChunkDetail(raw: 176.36188, fmt: "176.36"),
            trailingAnnualDividendRate: ratioChunkDetail(raw: 0.96, fmt: "0.96"),
            trailingAnnualDividendYield: ratioChunkDetail(raw: 0.0055, fmt: "0.55%"),
            currency: "USD"
        )
        
        var body: some View {
            VStack {
                SummaryDetailView(detail: detail)
                    .padding()
            }
        }
    }
    return previewSummaryDetail()
}
