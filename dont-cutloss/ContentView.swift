//
//  ContentView.swift
//  dont-cutloss
//
//  Created by user on 26/04/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Portfolio.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Portfolio>
    
    @State private var createSheetVisible = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    StockCard(result: FinanceQuoteSearchResult(
                        symbol: item.symbol,
                        shortname: item.shortName,
                        quoteType: item.quoteType,
                        exchange: item.exchange,
                        sector: item.sector
                    ))
                    .overlay {
                        NavigationLink(destination: DetailView(ticker: item), label: {
                            EmptyView()
                        })
                        .opacity(0)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        createSheetVisible = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Portfolio")
        }
        .sheet(isPresented: $createSheetVisible, content: {
            NavigationStack {
                AddNewItem(isPresented: $createSheetVisible)
            }
        })
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
