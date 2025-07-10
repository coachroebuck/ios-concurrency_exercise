//
//  ItemViewModel.swift
//  Concurrency Exercise
//
//  Created by Michael Roebuck on 7/10/25.
//

import Foundation

class ItemViewModel: ObservableObject {
    @Published var count: Int = 0

    func increment() {
        count += 1
    }
}
