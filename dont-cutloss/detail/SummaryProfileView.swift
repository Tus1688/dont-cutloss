//
//  SummaryProfileView.swift
//  dont-cutloss
//
//  Created by user on 06/05/24.
//

import SwiftUI

struct SummaryProfileView: View {
    let data: summaryProfileDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let desc = data.longBusinessSummary {
                Text(desc.prefix(300))
                    .font(.caption)
            }
            
            if let website = data.irWebsite {
                Link(website, destination: URL(string: website)!)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    struct previewSummaryProfileView: View {
        let data: summaryProfileDetail = summaryProfileDetail(
            address1: "One Apple Park Way",
            city: "Cupertino",
            state: "CA",
            zip: "95014",
            country: "United States",
            phone: "408 996 1010",
            website: "https://www.apple.com",
            industry: "Consumer Electronics",
            sector: "Technology",
            longBusinessSummary: "Apple Inc. designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories worldwide. The company offers iPhone, a line of smartphones; Mac, a line of personal computers; iPad, a line of multi-purpose tablets; and wearables, home, and accessories comprising AirPods, Apple TV, Apple Watch, Beats products, and HomePod. It also provides AppleCare support and cloud services; and operates various platforms, including the App Store that allow customers to discover and download applications and digital content, such as books, music, video, games, and podcasts. In addition, the company offers various services, such as Apple Arcade, a game subscription service; Apple Fitness+, a personalized fitness service; Apple Music, which offers users a curated listening experience with on-demand radio stations; Apple News+, a subscription news and magazine service; Apple TV+, which offers exclusive original content; Apple Card, a co-branded credit card; and Apple Pay, a cashless payment service, as well as licenses its intellectual property. The company serves consumers, and small and mid-sized businesses; and the education, enterprise, and government markets. It distributes third-party applications for its products through the App Store. The company also sells its products through its retail and online stores, and direct sales force; and third-party cellular network carriers, wholesalers, retailers, and resellers. Apple Inc. was founded in 1976 and is headquartered in Cupertino, California.",
            fullTimeEmployees: 161000,
            irWebsite: "http://investor.apple.com/"
        )
        var body: some View {
            SummaryProfileView(data: data)
        }
    }
    return previewSummaryProfileView()
}
