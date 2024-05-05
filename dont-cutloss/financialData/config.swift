//
//  config.swift
//  dont-cutloss
//
//  Created by user on 30/04/24.
//

import Foundation

public enum QuoteSummarySelection: String {
    case assetProfile
    case incomeStatementHistory
    case incomeStatementHistoryQuarterly
    case balanceSheetHistory
    case balanceSheetHistoryQuarterly
    case cashFlowStatementHistory
    case cashFlowStatementHistoryQuarterly
    case defaultKeyStatistics
    case financialData
    case calendarEvents
    case secFilings
    case recommendationTrend
    case upgradeDowngradeHistory
    case institutionOwnership
    case fundOwnership
    case majorDirectHolders
    case majorHoldersBreakdown
    case insiderTransactions
    case insiderHolders
    case netSharePurchaseActivity
    case sectorTrend
    case earnings
    case companyOfficers
    case summaryProfile
    case quoteType
    case earningsHistory
    case earningsTrend
    case indexTrend
    case industryTrend
    case price
    case symbol
    case summaryDetail
    case fundProfile
    case topHoldings
    case fundPerformance
    case all = "quoteType,summaryProfile,assetProfile,incomeStatementHistory,incomeStatementHistoryQuarterly,balanceSheetHistory,balanceSheetHistoryQuarterly,cashFlowStatementHistory,cashFlowStatementHistoryQuarterly,defaultKeyStatistics,financialData,calendarEvents,secFilings,recommendationTrend,upgradeDowngradeHistory,institutionOwnership,fundOwnership,majorDirectHolders,insiderTransactions,insiderHolders,netSharePurchaseActivity,sectorTrend,earnings,companyOfficers,earningsHistory,earningsTrend,indexTrend,industryTrend,majorHoldersBreakdown,price,summaryDetail,symbol,fundProfile,topHoldings,fundPerformance"
    case supported = "quoteType,summaryProfile,recommendationTrend,price,indexTrend,calendarEvents,summaryDetail"
}

public enum ChartDataRange: String, Identifiable {
    //    "1d","5d","1mo","3mo","6mo","1y","2y","5y","10y","ytd","max"
    case oneDay = "1d"
    case fiveDay = "5d"
    case oneMonth = "1mo"
    case threeMonth = "3mo"
    case sixMonth = "6mo"
    case oneYear = "1y"
    case twoYear = "2y"
    case fiveYear = "5y"
    case tenYear = "10y"
    case yearToDate = "ytd"
    case max = "max"
    
    static var allCases: [ChartDataRange] = [
        .oneDay,
        .fiveDay,
        .oneMonth,
        .threeMonth,
        .sixMonth,
        .oneYear,
        .twoYear,
        .fiveYear,
        .tenYear,
        .yearToDate,
        .max
    ]
    
    public var id: String { self.rawValue }
}

