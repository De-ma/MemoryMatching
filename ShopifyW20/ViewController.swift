import UIKit
import Moya

class ViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var matchedCardsLabel: UILabel!
    
    lazy var game = MemoryMatching(numberOfPairsOfCards: cardButtons.count / 2)
    var matchedCards = 0 {
        didSet {
            matchedCardsLabel.text = "Matched Cards: \(matchedCards)"
            if (matchedCards == cardButtons.count / 2) {
                gameOver()
            }
        }
    }
    
    var emoji = [Int: String]()
    var matchAttempts = 0.0
    static var collection: ShopifyProduct?

    @IBAction func ShuffleCards(_ sender: UIButton) {
        
        game.shuffleCards()
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.backgroundColor = game.cards[index].isMatched ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0) : #colorLiteral(red: 0.3607843137, green: 0.4156862745, blue: 0.768627451, alpha: 1)
            button.layer.borderWidth = game.cards[index].isMatched ? 0 : 2
            button.setBackgroundImage(nil, for: .normal)
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            let matchedCard = game.chooseCard(at: cardNumber)
            
            updateViewFromModel()

            if (matchedCard) {
                matchedCards += 1
            }
            matchAttempts += 0.5 //two cards to make 1 attempt
        }
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp, let url = URL(string: emoji(for: card)), let data = try? Data(contentsOf: url) {
                button.setBackgroundImage(UIImage(data: data), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0) : #colorLiteral(red: 0.3607843137, green: 0.4156862745, blue: 0.768627451, alpha: 1)
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
            button.layer.shadowOpacity = 0.4
            button.layer.shadowRadius = 2
            button.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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
            button.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.4156862745, blue: 0.768627451, alpha: 1)
            button.setBackgroundImage(nil, for: .normal)
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
