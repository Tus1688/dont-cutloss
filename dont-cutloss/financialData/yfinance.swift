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
        "Accept": "*/*",
        "Pragma": "no-cache",
        "Origin": "https://finance.yahoo.com",
        "Cache-Control": "no-cache",
        // "Host": "query1.finance.yahoo.com"
        // most commont user agent by now
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.3",
        "Accept-Encoding": "gzip, deflate, br",
        "Accept-Language": "en-US,en;q=0.9",
        "Connection": "keep-alive",
        // "Referer": "https://finance.yahoo.com/quote/AAPL/history?p=AAPL",
        // "Referer": "https://finance.yahoo.com",
    ]
    
    static var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.httpCookieAcceptPolicy = .never
        return URLSession(configuration: configuration)
    }()
    
    private class func fetchCredentials() {
        let semaphore = DispatchSemaphore(value: 0)
        
        session.dataTask(with: URL(string: "https://finance.yahoo.com/quote/AAPL/history")!) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            defer { semaphore.signal() }
            
            Self.cookies = response.debugDescription
                .split(separator: ";")
                .map { String($0) }
                .filter { $0.contains("B=") }
                .joined(separator: ";")
            
            let data = String(data: data!, encoding: .utf8)!
            let crumbPattern = #""CrumbStore":\{"crumb":"(?<crumb>[^"]+)"\}"#
            let range = NSRange(location: 0, length: data.utf16.count)
            guard let regex = try? NSRegularExpression(pattern: crumbPattern),
                  let match = regex.firstMatch(in: data, range: range),
                  let rangeData = Range(match.range, in: data) else {
                return
            }
            let crumbString = String(data[rangeData])
            
            let wI = NSMutableString(string: crumbString)
            CFStringTransform(wI, nil, "Any-Hex/Java" as NSString, true)
            let decodedString = wI as String
            Self.crumb = String(decodedString.suffix(13).prefix(11))
            
        }.resume()
        
        semaphore.wait()
    }
    
    // fetch creds if they were not set.
    private class func prepareCredentials() {
        if Self.crumb == "" {
            Self.fetchCredentials()
        }
    }
    
    public class func fetchSearchSymbol(
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
}
