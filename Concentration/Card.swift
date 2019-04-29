//
//  Card.swift
//  Concentration
//
//  Created by yanxinyi on 2019-03-22.
//  Copyright © 2019 yanxinyi. All rights reserved.
//

import Foundation
struct Card: Hashable {
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs: Card, rhs:Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var uniqueIdFactory = 0
    private static func getUniqueId() -> Int {
            uniqueIdFactory += 1
            return uniqueIdFactory
    }
    
    init() {
        self.identifier = Card.getUniqueId()
    }
}
