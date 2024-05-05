//
//  ChartRangeSwitchView.swift
//  dont-cutloss
//
//  Created by user on 05/05/24.
//

import SwiftUI

struct ChartRangeSwitchView: View {
    @Binding var range: ChartDataRange
    var body: some View {
        HStack {
            Picker("Chart Range", selection: $range) {
//                ForEach(ChartDataRange.allCases) { rangeValue in
//                    Text(rangeValue.rawValue.uppercased())
//                        .tag(rangeValue)
//                }
                Text("1D").tag(ChartDataRange.oneDay)
                Text("5D").tag(ChartDataRange.fiveDay)
                Text("1M").tag(ChartDataRange.oneMonth)
                Text("3M").tag(ChartDataRange.threeMonth)
                Text("YTD").tag(ChartDataRange.yearToDate)
                Text("1Y").tag(ChartDataRange.oneYear)
                Text("2Y").tag(ChartDataRange.twoYear)
                Text("5Y").tag(ChartDataRange.fiveYear)
            }
            .pickerStyle(.segmented)
        }
    }
}

#Preview {
    struct previewChartRangeSwitchView: View {
        @State private var range: ChartDataRange = .oneDay
        var body: some View {
            ChartRangeSwitchView(range: $range)
        }
    }
    return previewChartRangeSwitchView()
}
