//
//  ViewController.swift
//  ShopifyW20
//
//  Created by Dema Abu Adas on 2019-09-22.
//  Copyright © 2019 Dema Abu Adas. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    lazy var game = MemoryMatching(numberOfPairsOfCards: cardButtons.count / 2)
    var matchedCards = 0 {
        didSet {
            if (matchedCards == cardButtons.count / 2) {
                gameOver()
            }
        }
    }
    
    
    @IBOutlet var cardButtons: [UIButton]!
    static var collection: ShopifyProduct?

    var emoji = [Int: String]()
    var twoCardTouched = 0
    var matchAttempts = 0

    
    @IBAction func ShuffleCards(_ sender: UIButton) {
        game.shuffleCards()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            let matchedCard = game.chooseCard(at: cardNumber)
            updateViewFromModel()
            
            if (matchedCard) {
                matchedCards += 1
            }
            
            twoCardTouched += 1
            if (twoCardTouched == 2) {
                twoCardTouched = 0
                matchAttempts += 1
            }
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp, let url = URL(string: emoji(for: card)) {
                let data = try? Data(contentsOf: url)
                button.setBackgroundImage(UIImage(data: data!), for: .normal) //!!!!
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0) : #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
                button.layer.borderWidth = card.isMatched ? 0 : 2
            }
        }
    }
    

    func emoji(for card: Card) -> String {
        if (emoji[card.identifier] == nil){
            //JIT loading
            if let test = ViewController.collection, (ViewController.collection?.products.count)! > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(test.products.count)))
                emoji[card.identifier] = ViewController.collection?.products[randomIndex].image.src
                ViewController.collection?.products.remove(at: randomIndex)
                return emoji[card.identifier]!
            }
        }
        return emoji[card.identifier] ?? "?"
    }


    override func viewDidLoad() {
        for button in cardButtons {
            button.layer.cornerRadius = 4
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.layer.borderWidth = 2
        }
        
        let ProductProvider = MoyaProvider<ProductService>()
        ProductProvider.request(.getProducts) { result in
            do {
                let decoder = JSONDecoder()
                ViewController.collection = try decoder.decode(ShopifyProduct.self, from: (result.value?.data)!)
            } catch let err {
                print("Err", err)
            }
        }
    }
    
    
    func gameOver() {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
    
        let gameOverView: UIView = {
            let view = UIView(frame: CGRect(x: screenWidth * 0.15, y: screenHeight * 0.25 , width: 300, height: 200))
            view.tag = 2
            view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            view.layer.borderWidth = 4
            view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            view.layer.cornerRadius = 4
            return view
        }()
        
        
        view.addSubview(gameOverView)
        let winLabel: UILabel = {
            let label = UILabel()
            label.frame = CGRect(x: screenWidth * 0.23, y: screenHeight * 0.05, width: 300, height: 20)
            label.text = "Game Over!"
            label.textColor = .black
            label.font = UIFont(name: "Helvetica", size: 20)
            return label
        }()
        
        let matchAttemptsLabel: UILabel = {
            let label = UILabel()
            label.frame = CGRect(x: screenWidth * 0.15, y: screenHeight * 0.10, width: 300, height: 20)
            label.text = "Matched attempts: \(matchAttempts)"
            label.textColor = .black
            label.font = UIFont(name: "Helvetica", size: 20)
            return label
        }()
        
        let newGameButton: UIButton = {
           let button = UIButton()
            button.frame = CGRect(x: screenWidth * 0.01, y: screenHeight * 0.15, width: 300, height: 20)
            button.setTitle("New Game?", for: .normal)
            button.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
            button.addTarget(self, action:#selector(self.newGame), for: .touchUpInside)
            return button
        }()
        
        gameOverView.addSubview(winLabel)
        gameOverView.addSubview(matchAttemptsLabel)
        gameOverView.addSubview(newGameButton)
        mainView.addSubview(gameOverView)
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.isEnabled = false
        }
    }
    
    @objc func newGame() {
        game = MemoryMatching(numberOfPairsOfCards: cardButtons.count / 2)
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.isEnabled = true
            button.layer.cornerRadius = 4
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.layer.borderWidth = 2
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
        }
        
        for subview in mainView.subviews {
            if subview.tag == 2 {
                subview.removeFromSuperview()
            }
        }
        
        matchAttempts = 0
        matchedCards = 0
    }
}
