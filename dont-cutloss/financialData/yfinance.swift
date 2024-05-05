//
//  fetch.swift
//  dont-cutloss
//
//  Created by user on 26/04/24.
//

import Foundation

public class YFinance {
    // crumb and cookies are assigned on the first fetch
    static var crumb: String = ""
    static var cookies: String = ""
    
    // by changing the cacheCounter, the app expects uncached response
    static var cacheCounter = 0
    
    static var headers = [
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Sec-Fetch-Site": "none",
        "Sec-Fetch-Mode": "navigate",
        "Pragma": "no-cache",
        "Origin": "https://finance.yahoo.com",
        "Cache-Control": "no-cache",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.3",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8",
        "Connection": "keep-alive",
        "Sec-Fetch-Dest": "document",
    ]
    
    static var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        config.httpCookieStorage = .shared
        config.httpShouldSetCookies = true
        config.httpCookieAcceptPolicy = .always
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        return URLSession(configuration: config)
    }()
    
    
    private class func fetchCredentials() {
        let semaphore = DispatchSemaphore(value: 0)
        
        // Send the first request to https://finance.yahoo.com/quote/AAPL/history
        session.dataTask(with: URL(string: "https://finance.yahoo.com/quote/AAPL")!) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            defer { semaphore.signal() }
            
            let resp: HTTPURLResponse = (response as? HTTPURLResponse)!
            let cookies:[HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: resp.allHeaderFields as! [String : String], for: resp.url!)
            HTTPCookieStorage.shared.setCookies(cookies, for: response?.url!, mainDocumentURL: nil)
            
            Self.cookies = cookies.reduce("") { (result, cookie) -> String in
                return "\(result)\(cookie.name)=\(cookie.value);"
            }
        }.resume()
        
        // Wait for the first request to finish
        semaphore.wait()
        
        var reqGetCrumb = URLRequest(url: URL(string: "https://query1.finance.yahoo.com/v1/test/getcrumb")!)
        reqGetCrumb.setValue(Self.cookies, forHTTPHeaderField: "Cookie")
        reqGetCrumb.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        reqGetCrumb.setValue("same-site", forHTTPHeaderField: "Sec-Fetch-Site")
        reqGetCrumb.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        reqGetCrumb.setValue("en-GB,en-US;q=0.9,en;q=0.8", forHTTPHeaderField: "Accept-Language")
        reqGetCrumb.setValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
        reqGetCrumb.setValue("query1.finance.yahoo.com", forHTTPHeaderField: "Host")
        reqGetCrumb.setValue("https://finance.yahoo.com", forHTTPHeaderField: "Origin")
        reqGetCrumb.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
        reqGetCrumb.setValue("https://finance.yahoo.com/quote/AAPL/", forHTTPHeaderField: "Referer")
        reqGetCrumb.setValue("keep-alive", forHTTPHeaderField: "Connection")
        
        // Send the second request to https://query1.finance.yahoo.com/v1/test/getcrumb
        session.dataTask(with: reqGetCrumb) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            defer { semaphore.signal() }
            
            Self.crumb = String(data: data!, encoding: .utf8)!
            print("DEBUG Crumb: \(Self.crumb)")
        }.resume()
        
        // Wait for the second request to finish
        semaphore.wait()
    }
    
    // fetch creds if they were not set.
    private class func prepareCredentials() {
        if Self.crumb == "" {
            Self.fetchCredentials()
        }
    }
    
    // fetch symbols
    public class func fetchSearchDataBy(
        searchTerm: String,
        quotesCount: Int = 20,
        queue: DispatchQueue = .main,
        callback: @escaping ([FinanceQuoteSearchResult]?, Error?) -> Void
    ) {
        //    https://query1.finance.yahoo.com/v1/finance/search
        
        // trim \n and spaces
        if searchTerm.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback([], nil)
        }
        
        Self.prepareCredentials()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v1/finance/search"
        Self.cacheCounter += 1
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "crumb", value: Self.crumb),
            URLQueryItem(name: "quotesCount", value: String(quotesCount)),
            URLQueryItem(name: "cachecounter", value: String(Self.cacheCounter))
        ]
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let task = session.dataTask(with: urlComponents.url!) { data, response, error in
            if let error = error {
                queue.async {
                    callback(nil, error)
                }
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let searchResult = try decoder.decode(FinanceQuoteResultResponse.self, from: data)
                    queue.async {
                        callback(searchResult.quotes, nil)
                    }
                } catch {
                    queue.async {
                        callback(nil, error)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    // fetch news
    public class func fetchSearchDataBy(
        searchTerm: String,
        newsCount: Int = 20,
        queue: DispatchQueue = .main,
        callback: @escaping ([FinanceNewsSearchResult]?, Error?) -> Void
    ) {
        //    https:query1.finance.yahoo.com/v1/finance/search
        
        if searchTerm.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback([], nil)
        }
        
        Self.prepareCredentials()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v1/finance/search"
        Self.cacheCounter += 1
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "crumb", value: Self.crumb),
            URLQueryItem(name: "newsCount", value: String(newsCount)),
            URLQueryItem(name: "cachecounter", value: String(Self.cacheCounter))
        ]
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let task = session.dataTask(with: urlComponents.url!) { data, response, error in
            if let error = error {
                queue.async {
                    callback(nil, error)
                }
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let searchResult = try decoder.decode(FinanceNewsSearchResultResponse.self, from: data)
                    queue.async {
                        callback(searchResult.news, nil)
                    }
                } catch {
                    queue.async {
                        callback(nil, error)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    // fetch summary data
    public class func fetchSummaryData(
        identifier: String,
        selection: [QuoteSummarySelection],
        queue: DispatchQueue = .main,
        callback: @escaping(FinanceSummaryDetailResult?, Error?) -> Void
    ) {
        if identifier.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback(nil, NSError(domain: "invalid identifier", code: 0, userInfo: nil))
            return
        }
        
        Self.prepareCredentials()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query2.finance.yahoo.com"
        urlComponents.path = "/v10/finance/quoteSummary/\(identifier)"
        
        Self.cacheCounter += 1
        
        urlComponents.queryItems = [
            URLQueryItem(name: "modules", value: selection.map({
                data in
                String(data.rawValue)
            }).joined(separator: ",")),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "region", value: "US"),
            URLQueryItem(name: "crumb", value: Self.crumb),
            URLQueryItem(name: "includePrePost", value: "true"),
            URLQueryItem(name: "corsDomain", value: "finance.yahoo.com"),
            URLQueryItem(name: ".tsrc", value: "finance"),
            URLQueryItem(name: "symbols", value: identifier),
            URLQueryItem(name: "cachecounter", value: String(Self.cacheCounter))
        ]
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let task = session.dataTask(with: urlComponents.url!) { data, response, error in
            if let error = error {
                queue.async {
                    callback(nil, error)
                }
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(FinanceSummaryDetailResultReponse.self, from: data)
                    let error = try decoder.decode(FinanceSummaryDetailErrorResponse.self, from: data)
                    
                    if error.finance?.error != nil {
                        queue.async {
                            callback(nil, NSError(domain: error.finance!.error?.description! ?? "", code: 0, userInfo: nil))
                        }
                    }
                    
                    if response.quoteSummary?.result == nil {
                        queue.async {
                            callback(nil, NSError(domain: "no data", code: 0, userInfo: nil))
                        }
                    }
                    
                    queue.async {
                        callback(response.quoteSummary?.result![0], nil)
                    }
                } catch {
                    queue.async {
                        callback(nil, error)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    // async wrapper for fetch summary data
    public class func syncFetchSummaryData(
        identifier: String,
        selection: [QuoteSummarySelection]
    ) -> (FinanceSummaryDetailResult?, Error?) {
        var retData: FinanceSummaryDetailResult?, retError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.fetchSummaryData(
            identifier: identifier,
            selection: selection
        ) { data, error in
            defer { semaphore.signal() }
            
            retData = data
            retError = error
        }
        
        semaphore.wait()
        return (retData, retError)
    }
    
    public class func fetchChartData(
        identifier: String,
        range: ChartDataRange = .oneDay,
        queue: DispatchQueue = .main,
        callback: @escaping (ChartDataResult?, Error?) -> Void
    ) {
        if identifier.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback(nil, NSError(domain: "invalid identifier", code: 0, userInfo: nil))
            return
        }
        
        var interval: String {
            switch range {
            case .oneDay:
                return "1m"
            case .fiveDay:
                return "5m"
            case .oneMonth, .threeMonth, .sixMonth, .oneYear, .twoYear, .yearToDate:
                return "1d"
            case .fiveYear:
                return "1wk"
            case .max, .tenYear:
                return "1mo"
            }
        }
        
        var period1: String {
            switch range {
            case .oneDay:
                return String(Int(Date().timeIntervalSince1970) - 86400)
            case .fiveDay:
                return String(Int(Date().timeIntervalSince1970) - 432000)
            case .oneMonth:
                return String(Int(Date().timeIntervalSince1970) - 2592000)
            case .threeMonth:
                return String(Int(Date().timeIntervalSince1970) - 7776000)
            case .sixMonth:
                return String(Int(Date().timeIntervalSince1970) - 15552000)
            case .yearToDate:
                return String(Int(Date().timeIntervalSince1970) - 15768000)
            case .oneYear:
                return String(Int(Date().timeIntervalSince1970) - 31536000)
            case .twoYear:
                return String(Int(Date().timeIntervalSince1970) - 63072000)
            case .fiveYear:
                return String(Int(Date().timeIntervalSince1970) - 157680000)
            case .tenYear:
                return String(Int(Date().timeIntervalSince1970) - 315360000)
            case .max:
                return "0"
            }
        }
        
        Self.prepareCredentials()
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "query1.finance.yahoo.com"
        urlComponents.path = "/v8/finance/chart/\(identifier)"
        Self.cacheCounter += 1
        urlComponents.queryItems = [
            URLQueryItem(name: "symbols", value: identifier),
            URLQueryItem(name: "symbol", value: identifier),
            URLQueryItem(name: "region", value: "US"),
            URLQueryItem(name: "lang", value: "en-US"),
            URLQueryItem(name: "includePrePost", value: "false"),
            URLQueryItem(name: "corsDomain", value: "finance.yahoo.com"),
            URLQueryItem(name: "interval", value: interval),
            URLQueryItem(name: "range", value: range.rawValue),
            URLQueryItem(name: "crumb", value: Self.crumb),
            URLQueryItem(name: ".tsrc", value: "finance"),
//            URLQueryItem(name: "period1", value: String(Int(Date().timeIntervalSince1970))),
//            URLQueryItem(name: "period2", value: String(Int(Date().timeIntervalSince1970) + 10)),
            URLQueryItem(name: "period1", value: period1),
            URLQueryItem(name: "period2", value: String(Int(Date().timeIntervalSince1970))),
            URLQueryItem(name: "cachecounter", value: String(Self.cacheCounter))
        ]
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let task = session.dataTask(with: urlComponents.url!) { data, response, error in
            if let error = error {
                queue.async {
                    callback(nil, error)
                }
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(FinanceStockChartData.self, from: data)
                    
                    if response.chart?.error != nil {
                        queue.async {
                            callback(nil, NSError(domain: response.chart!.error?.description! ?? "", code: 0, userInfo: nil))
                        }
                    }
                    
                    queue.async {
                        callback(response.chart?.result[0], nil)
                    }
                } catch {
                    queue.async {
                        callback(nil, error)
                    }
                }
            }
        }
        
        task.resume()
    }
}
