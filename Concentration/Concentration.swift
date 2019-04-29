//
//  Concentration.swift
//  Concentration
//
//  Created by yanxinyi on 2019-03-22.
//  Copyright © 2019 yanxinyi. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyOneCardFaceUp: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (newValue == index)
            }
        }
    }
    
    var allCardsMatched: Bool {
        return cards.filter { !$0.isMatched }.count == 0
    }
    
    
    func chooseCard(at index:Int) {
        if cards[index].isMatched {
            return
        }
        
        if let matchIndex = indexOfOneAndOnlyOneCardFaceUp, matchIndex != index {
            cards[index].isFaceUp = true
            if cards[index] == cards[matchIndex] {
                cards[index].isMatched = true
                cards[matchIndex].isMatched = true
            }
            
        } else {
            indexOfOneAndOnlyOneCardFaceUp = index
        }
    }
    
    init(numOfPairsOfCards: Int) {
        for _ in 0..<numOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        // shuffle cards using Fisher-Yate Algorithm
        for index in (1..<cards.count).reversed() {
            let randomIndex = index.arc4random
            let tmp = cards[randomIndex]
            cards[randomIndex] = cards[index]
            cards[index] = tmp
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
