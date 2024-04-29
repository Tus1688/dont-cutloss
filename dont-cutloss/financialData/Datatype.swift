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

//Instance method 'decode(_:from:)' requires that 'FinanceQuoteSearchResult' conform to 'Decodable'
public struct FinanceQuoteSearchResult: Decodable {
    public var symbol: String?
    public var shortName: String?
    public var longName: String?
    public var exchange: String?
    public var assetType: String?
}
