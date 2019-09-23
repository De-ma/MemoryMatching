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

    lazy var game = MemoryMatching(numberOfPairsOfCards: cardButtons.count / 2)
    var flipCount: Int = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    static var collection: ShopifyProduct?
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                
//                button.setTitle(emoji(for: card), for: .normal)
                
                let url = URL(string: emoji(for: card))
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//                imageView.image =
                button.setImage(UIImage(data: data!), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.setImage(nil, for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0) : #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
        }
    }
    
    var emojiChoices = ["🐶", "🐹", "🐻", "🐱", "🐸", "🐨", "🐼", "🦊", "🐯", "🐵", "🐭", "🐮", "🐷"]
    var emoji = [Int: String]()
    
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
    

    
}

