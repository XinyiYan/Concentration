//
//  ViewController.swift
//  Concentration
//
//  Created by yanxinyi on 2019-03-20.
//  Copyright © 2019 yanxinyi. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numOfPairsOfCards: numOfPairsOfCards)

    // a read-only computed property.
    var numOfPairsOfCards:Int {
        return (visibleCardButtons.count + 1 ) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeColor: UIColor.orange,
            .strokeWidth: 5.0
        ]
        
        let attributedString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact ? "Flips\n\(flipCount)" : "Flips: \(flipCount)",
            attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    @IBOutlet weak var newGame: UILabel! {
        didSet {
            newGame.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startNewGame(_:))))
            newGame.isUserInteractionEnabled = true
        }
    }
    
    @objc private func startNewGame(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            flipCount = 0
            emojiDic = [Card:String]()
            emojiFactory = theme!
            game = Concentration(numOfPairsOfCards: (visibleCardButtons.count + 1 ) / 2 )
            updateViewFromModel()
            newGame.isHidden = true
        default:
            break
        }
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNum = visibleCardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNum)
            updateViewFromModel()
            
            if game.allCardsMatched {
                newGame.isHidden = false
            }
            
        } else {
            print("Button out of range")
        }
    }

    private func updateViewFromModel() {
        if visibleCardButtons == nil {
            return
        }
        for index in visibleCardButtons.indices {
            let button = visibleCardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(getEmoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    var theme: String? {
        didSet {
            emojiFactory = theme ?? ""
            emojiDic = [:]
            updateViewFromModel()
        }
    }
    
    private var emojiFactory = "👻🎃😈🐳🌸☃️🔮🐾🦉"
    
    private var emojiDic = [Card:String]()
    
    private func getEmoji(for card: Card) -> String {
        if emojiDic[card] == nil, emojiFactory.count > 0 {
            let randomStringIndex = emojiFactory.index(emojiFactory.startIndex, offsetBy: emojiFactory.count.arc4random)
            emojiDic[card] = String(emojiFactory.remove(at: randomStringIndex))
        }
        return emojiDic[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

