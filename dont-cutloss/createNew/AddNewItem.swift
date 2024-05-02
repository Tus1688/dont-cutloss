//
//  AddNewItem.swift
//  dont-cutloss
//
//  Created by user on 26/04/24.
//

import SwiftUI
import CoreData

struct AddNewItem: View {
    @Binding var isPresented: Bool
    @State private var searchString: String = ""
    @State private var foundContainers: [FinanceQuoteSearchResult] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search for a symbol", text: $searchString, onCommit: self.searchObjects)
                    .padding()
                List {
                    ForEach(self.foundContainers, id: \.symbol) { result in
                        NavigationLink(destination:
                                        FillInfo(isPresented: $isPresented, result: result)
                        ) {
                            StockCard(result: result)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Choose a symbol")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    isPresented = false
                }
            }
        }
    }
    
    func searchObjects() {
        isLoading = true
        YFinance.fetchSearchDataBy(searchTerm: self.searchString) {data, error in
            isLoading = false
            if error != nil {
                return
            }
            self.foundContainers = data!
        }
    }
}


#Preview {
    struct previewAddNewItem: View {
        @State private var isPresented = true
        var body: some View {
            NavigationStack {
                Text("hello world from AddNewView")
                Button("toggle sheet") {
                    isPresented.toggle()
                }
            }
            .sheet(isPresented: $isPresented, content: {
                NavigationStack {
                    AddNewItem(isPresented: $isPresented)
                }
            })
        }
    }
    return previewAddNewItem().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
