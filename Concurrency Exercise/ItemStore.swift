//
//  ItemStore.swift
//  Concurrency Exercise
//
//  Created by Michael Roebuck on 7/9/25.
//

actor ItemStore {
    private(set) var accessedCount = 0

    func recordAccess() {
        accessedCount += 1
        print("Accessed count: \(accessedCount)")
    }
}
