//
//  Datatype.swift
//  dont-cutloss
//
//  Created by user on 29/04/24.
//

import Foundation

public struct FinanceQuoteResultResponse: Decodable {
    public var explains: [String]?
    public var count: Int?
    public var quotes: [FinanceQuoteSearchResult]?
}

public struct FinanceQuoteSearchResult: Decodable {
    public var symbol: String?
    public var shortname: String?
    public var longname: String?
    public var quoteType: String?
    public var exchange: String?
    public var sector: String?
}

public struct FinanceNewsSearchResultResponse: Decodable {
    public var explains: [String]?
    public var count: Int?
    public var news: [FinanceNewsSearchResult]?
}

public struct FinanceNewsSearchResult: Decodable {
    public var uuid: String?
    public var title: String?
    public var publisher: String?
    public var link: String?
    public var providerPublishTime: String?
    public var type: String?
    public var thumbnail: Thumbnail?
    public var relatedTickers: [String]?
}

public struct Thumbnail: Decodable {
    public var resolutions: [Resolutions]?
}

public struct Resolutions: Decodable {
    public var url: String?
    public var width: Int?
    public var height: Int?
    public var tag: String?
}

/*
 Beginning of detailed data struct
 */

public struct Trend: Decodable {
    public var period: String?
    public var strongBuy: Int?
    public var buy: Int?
    public var hold: Int?
    public var sell: Int?
    public var strongSell: Int?
}

public struct recommendationTrendDetail: Decodable {
    public var trend: [Trend]?
}

public struct ratioChunkDetail: Decodable {
    public var raw: Decimal?
    public var fmt: String?
    public var longFmt: String?
}

public struct summaryDetail: Decodable {
    public var previousClose: ratioChunkDetail?
    public var open: ratioChunkDetail?
    public var dayLow: ratioChunkDetail?
    public var dayHigh: ratioChunkDetail?
    public var regularMarketPreviousClose: ratioChunkDetail?
    public var regularMarketOpen: ratioChunkDetail?
    public var regularMarketDayLow: ratioChunkDetail?
    public var regularMarketDayHigh: ratioChunkDetail?
    public var devidedRate: ratioChunkDetail?
    public var exDividendDate: ratioChunkDetail?
    public var payoutRatio: ratioChunkDetail?
    public var fiveYearAvgDividendYield: ratioChunkDetail?
    public var beta: ratioChunkDetail?
    public var trailingPE: ratioChunkDetail?
    public var forwardPE: ratioChunkDetail?
    public var volume: ratioChunkDetail?
    public var regularMarketVolume: ratioChunkDetail
    public var averageVolume: ratioChunkDetail?
    public var averageVolume10days: ratioChunkDetail?
    public var averageDailyVolume10Day: ratioChunkDetail?
    public var bid: ratioChunkDetail?
    public var ask: ratioChunkDetail?
    public var bidSize: ratioChunkDetail?
    public var askSize: ratioChunkDetail?
    public var marketCap: ratioChunkDetail?
    public var fiftyTwoWeekLow: ratioChunkDetail?
    public var fiftyTwoWeekHigh: ratioChunkDetail?
    public var priceToSalesTrailing12Months: ratioChunkDetail?
    public var fiftyDayAverage: ratioChunkDetail?
    public var twoHundredDayAverage: ratioChunkDetail?
    public var trailingAnnualDividendRate: ratioChunkDetail?
    public var trailingAnnualDividendYield: ratioChunkDetail?
    public var currency: String?
}

public struct calendarEvents: Decodable {
    public var earnings: Earnings?
    public var exDividendDate: ratioChunkDetail?
    public var dividendDate: ratioChunkDetail?
}

public struct Earnings: Decodable {
    public var earningsDate: [ratioChunkDetail]?
    public var earningsAverage: ratioChunkDetail?
    public var earningsLow: ratioChunkDetail?
    public var earningsHigh: ratioChunkDetail?
    public var revenueAverage: ratioChunkDetail?
    public var revenueLow: ratioChunkDetail?
    public var revenueHigh: ratioChunkDetail?
}

public struct priceDetail: Decodable {
    public var postMarketChangePercent: ratioChunkDetail?
    public var postMarketChange: ratioChunkDetail?
    public var PostMarketTime: Int?
    public var PostMarketPrice: ratioChunkDetail?
    public var regularMarketChange: ratioChunkDetail?
    public var regularMarketTime: Int?
    public var priceHint: ratioChunkDetail?
    public var regularMarketPrice: ratioChunkDetail?
    public var regularMarketDayHigh: ratioChunkDetail?
    public var regularMarketDayLow: ratioChunkDetail?
    public var regularMarketVolume: ratioChunkDetail?
    public var averageDailyVolume10Day: ratioChunkDetail?
    public var averageDailyVolume3Month: ratioChunkDetail?
    public var regularMarketpreviousClose: ratioChunkDetail?
    public var regularMarketOpen: ratioChunkDetail?
    public var exchange: String?
    public var exchangeName: String?
    public var exchangeDataDelayedBy: Int?
    public var marketState: String?
    public var quoteType: String?
    public var symbol: String?
    public var shortName: String?
    public var longName: String?
    public var currency: String?
    public var quoteSourceName: String?
    public var currencySymbol: String?
    public var marketCap: ratioChunkDetail?
}

public struct indexTrendDetail: Decodable {
    public var symbol: String?
    public var peRatio: ratioChunkDetail?
    public var pegRatio: ratioChunkDetail?
    public var estimates: [Estimate]?
}

public struct Estimate: Decodable {
    public var period: String?
    public var growth: ratioChunkDetail?
}

public struct summaryProfileDetail: Decodable {
    public var address1: String?
    public var city: String?
    public var state: String?
    public var zip: String?
    public var country: String?
    public var phone: String?
    public var website: String?
    public var industry: String?
    public var sectory: String?
    public var longBusinessSummary: String?
    public var fullTimeEmployees: Int?
    public var irWebsite: String?
}

public struct quoteTypeDetail: Decodable {
    public var exchange: String?
    public var quoteType: String?
    public var symbol: String?
    public var underlyingSymbol: String?
    public var shortName: String?
    public var longName: String?
    public var firstTradeDateEpochUtc: Int?
    public var timeZoneFullName: String?
    public var timeZoneShortName: String?
    public var uuid: String?
}

public struct FinanceSummaryDetailResult: Decodable {
    public var recommendationTrend: recommendationTrendDetail?
    public var summaryDetail: summaryDetail?
    public var calendarEvents: calendarEvents?
    public var price: priceDetail?
    public var indexTrend: indexTrendDetail?
    public var summaryProfile: summaryProfileDetail?
    public var quoteType: quoteTypeDetail?
}

public struct FinanceSummaryDetailResultWrapper: Decodable {
    public var result: [FinanceSummaryDetailResult]?
}

public struct FinanceSummaryDetailResultReponse: Decodable {
    public var quoteSummary: FinanceSummaryDetailResultWrapper?
}

//{"finance":{"result":null,"error":{"code":"Unauthorized","description":"Invalid Cookie"}}}
public struct FinanceSummaryDetailErrorResponse: Decodable {
    public var finance: FinanceSummaryDetailErrorResult?
}

public struct FinanceSummaryDetailErrorResult: Decodable {
    public var error: FinanceSummaryDetailError?
}

public struct FinanceSummaryDetailError: Decodable {
    public var code: String?
    public var description: String?
}

/*
 End of detailed data struct
 */
