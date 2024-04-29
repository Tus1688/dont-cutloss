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
