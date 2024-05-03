//
//  TrendView.swift
//  dont-cutloss
//
//  Created by user on 03/05/24.
//

import SwiftUI
import Charts

struct AnalystRecommendation: View {
    let trend: [Trend]
    
    // This function converts the period string to month names based on the current month
    func getMonthPeriod(period: String) -> String {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let monthMapping: [String: String] = [
            "0m": calendar.monthSymbols[currentMonth - 1], // Current month
            "-1m": calendar.monthSymbols[(currentMonth - 2 + 12) % 12], // Previous month
            "-2m": calendar.monthSymbols[(currentMonth - 3 + 12) % 12], // Month before previous month
            "-3m": calendar.monthSymbols[(currentMonth - 4 + 12) % 12], // 4 months before current month
        ]
        return monthMapping[period] ?? period
    }
    
    private let barWidth = 30
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Analyst Recommendation")
                .font(.headline)
                .fontWeight(.bold)
            Chart(trend.reversed()) { value in
                BarMark(
                    x: .value("Period", getMonthPeriod(period: value.period ?? "")),
                    y: .value("Sell", value.strongSell ?? 0),
                    width: .fixed(CGFloat(barWidth))
                )
                .foregroundStyle(.red)
                BarMark(
                    x: .value("Period", getMonthPeriod(period: value.period ?? "")),
                    y: .value("UnderPerform", value.sell ?? 0),
                    width: .fixed(CGFloat(barWidth))
                )
                .foregroundStyle(.orange)
                BarMark(
                    x: .value("Period", getMonthPeriod(period: value.period ?? "")),
                    y: .value("Hold", value.hold ?? 0),
                    width: .fixed(CGFloat(barWidth))
                )
                .foregroundStyle(.yellow)
                BarMark(
                    x: .value("Period", getMonthPeriod(period: value.period ?? "")),
                    y: .value("Buy", value.buy ?? 0),
                    width: .fixed(CGFloat(barWidth))
                )
                .foregroundStyle(.blue)
                BarMark(
                    x: .value("Period", getMonthPeriod(period: value.period ?? "")),
                    y: .value("Strong Buy", value.strongBuy ?? 0),
                    width: .fixed(CGFloat(barWidth))
                )
                .foregroundStyle(.green)
            }
            .chartLegend(.visible)
            .frame(height: 150)
        }
    }
}

#Preview {
    struct TrendViewPreview: View {
        let trend: [Trend] = [
            Trend(period: "0m", strongBuy: 11, buy: 21, hold: 6, sell: 0, strongSell: 0),
            Trend(period: "-1m", strongBuy: 10, buy: 17, hold: 12, sell:2, strongSell: 0),
            Trend(period: "-2m", strongBuy: 10, buy: 17, hold: 12, sell:2, strongSell: 0),
            Trend(period: "-3m", strongBuy: 10, buy: 24, hold: 7, sell:1, strongSell: 0),
        ]
        var body: some View {
            AnalystRecommendation(trend: trend)
        }
    }
    return TrendViewPreview()
}
