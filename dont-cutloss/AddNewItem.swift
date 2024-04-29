//
//  AddNewItem.swift
//  dont-cutloss
//
//  Created by user on 26/04/24.
//

import SwiftUI
import CoreData

struct AddNewItem: View {
    @State private var symbol = ""
    var body: some View {
        Form {
            Section(header: Text("Company Information")) {
                TextField("Symbol", text: $symbol)
            }
        }
    }
}

#Preview {
    AddNewItem().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
