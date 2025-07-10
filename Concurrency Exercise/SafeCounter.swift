//
//  SafeCounter.swift
//  Concurrency Exercise
//
//  Created by Michael Roebuck on 7/10/25.
//

actor SafeCounter {
    private(set) var count = 0

    func increment() {
        count += 1
    }
}
