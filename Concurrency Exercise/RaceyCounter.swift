//
//  RaceyCounter.swift
//  Concurrency Exercise
//
//  Created by Michael Roebuck on 7/10/25.
//

import Foundation

class RaceyCounter {
    var count = 0

    func increment() async {
        let current = count
        try? await Task.sleep(nanoseconds: 10_000) // 10 microseconds
        count = current + 1
    }
}
