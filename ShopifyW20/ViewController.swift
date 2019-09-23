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
    var playerOneScore = 0 {
        didSet {
            playerOneLabel.text = "Player 1: \(playerOneScore)"
            if (playerOneScore >= 10) {
                someoneWon(player: 1)
            }
        }
    }
    var playerTwoScore = 0 {
        didSet {
            playerTwoLabel.text = "Player 2: \(playerTwoScore)"
            if (playerTwoScore >= 10) {
                someoneWon(player: 2)
            }
        }
    }
    
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    static var collection: ShopifyProduct?
    var emoji = [Int: String]()
    var playerOnePlaying = true //lets have player one go first!
    var twoCardTouched = 0
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            let matchedCard = game.chooseCard(at: cardNumber, player: playerOnePlaying)
            updateViewFromModel()
            if (playerOnePlaying) {
                if (matchedCard) {
                    playerOneScore += 1
                }
                
                playerOneLabel.highlightedTextColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                playerOneLabel.isHighlighted = true
                playerTwoLabel.isHighlighted = false
            } else if (!playerOnePlaying) {
                //p2 playing
                if (matchedCard) {
                    playerTwoScore += 1
                }
                playerTwoLabel.highlightedTextColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                playerTwoLabel.isHighlighted = true
                playerOneLabel.isHighlighted = false
            }
            twoCardTouched += 1
            if (twoCardTouched == 2) {
                twoCardTouched = 0
                playerOnePlaying = !playerOnePlaying
            }
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                let url = URL(string: emoji(for: card))
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                button.setBackgroundImage(UIImage(data: data!), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0) : #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
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
    
    
    func someoneWon(player: Int) {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        let subView = UIView(frame: CGRect(x: screenWidth * 0.15, y: screenHeight * 0.25 , width: 300, height: 200))
        subView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        subView.layer.cornerRadius = 20
        
        
        view.addSubview(subView)
        let winLabel: UILabel = {
            let label = UILabel()
            label.frame = CGRect(x: screenWidth * 0.115, y: screenHeight * 0.1, width: 300, height: 20)
            label.text = "Player \(player) won! 🎉"
            label.textColor = .black
            label.font = UIFont(name: "Helvetica", size: 30)
            return label
        }()
        
        subView.addSubview(winLabel)
        mainView.addSubview(subView)
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.isEnabled = false
        }
   
    }

    
}

