//
//  ContentView.swift
//  Concurrency Exercise
//
//  Created by Michael Roebuck on 7/9/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    let raceyCounter = RaceyCounter()
    let safeCounter = SafeCounter()
    let store = ItemStore()

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button("Use Store") {
                        Task {
                            await store.recordAccess()
                        }
                    }
                }
                ToolbarItem {
                    Button("Race Condition") {
                        triggerRaceCondition()
                    }
                }
                ToolbarItem {
                    Button("Fix Condition") {
                        triggerSafeCondition()
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    private func triggerRaceCondition() {
        raceyCounter.count = 0

        for _ in 0..<1000 {
            Task.detached {
                await raceyCounter.increment()
            }
        }

        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            print("Final count: \(raceyCounter.count)") // Should be 1000 — but won’t be
        }
    }
    private func triggerSafeCondition() {
        Task {
            for _ in 0..<1000 {
                Task.detached {
                    await safeCounter.increment()
                }
            }

            // Wait before checking final count
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            let finalCount = await safeCounter.count
            print("✅ Safe final count: \(finalCount)")
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
