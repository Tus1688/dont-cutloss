//
//  OwnershipCardView.swift
//  dont-cutloss
//
//  Created by user on 05/05/24.
//

import SwiftUI

struct OwnershipCardView: View {
    let portfolio: Portfolio
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ownership")
                .font(.subheadline)
                .fontWeight(.semibold)
            Text("\(portfolio.quantity!) shares")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(portfolio.averagePrice!) average price")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
