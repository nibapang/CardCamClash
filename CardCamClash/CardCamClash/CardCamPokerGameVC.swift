//
//  PokerGameVC.swift
//  CardCamClash
//
//  Created by Card Cam Clash on 2025/3/6.
//


import UIKit

class CardCamPokerGameVC: UIViewController {
    
    @IBOutlet weak var imgQueCard: UIImageView!
    @IBOutlet weak var imgPreCard: UIImageView!
    @IBOutlet weak var imgMainCard: UIImageView!
    @IBOutlet weak var imgNexCard: UIImageView!
    @IBOutlet weak var stckCards: UIStackView!
    @IBOutlet weak var progTimer: UIProgressView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblScoreMax: UILabel!
    
    var arrCards: [[UIImage]] = []
    var maxScore = 0{
        didSet{
            UserDefaults.standard.setValue(maxScore, forKey: "max")
            lblScoreMax.text = "MAX SCORE: \(maxScore)"
        }
    }
    
    var cardType = 0{
        didSet{
            
            let isIncrease = oldValue < cardType
            
            cardType = cardType < 0 ? 3 : cardType > 3 ? 0 : cardType
            
            cardId = cardId < 0 ? 12 : cardId > 12 ? 0 : cardId
            
            let transition1 = CATransition()
            transition1.duration = 0.1
            transition1.type = CATransitionType.fade
            transition1.subtype = isIncrease ? CATransitionSubtype.fromTop : CATransitionSubtype.fromBottom
            
            imgMainCard.layer.add(transition1, forKey: kCATransition)
            imgPreCard.layer.add(transition1, forKey: kCATransition)
            imgNexCard.layer.add(transition1, forKey: kCATransition)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                
                let transition = CATransition()
                transition.duration = 0.1
                transition.type = CATransitionType.push
                transition.subtype = isIncrease ? CATransitionSubtype.fromBottom : CATransitionSubtype.fromTop
                
                self.imgMainCard.layer.add(transition, forKey: kCATransition)
                self.imgPreCard.layer.add(transition, forKey: kCATransition)
                self.imgNexCard.layer.add(transition, forKey: kCATransition)
                
                self.imgMainCard.image = self.arrCards[self.cardType][self.cardId]
                self.imgPreCard.image = self.arrCards[self.cardType][self.cardId-1 < 0 ? 12 : self.cardId-1]
                self.imgNexCard.image = self.arrCards[self.cardType][self.cardId+1 > 12 ? 0 : self.cardId+1]
                
            }
            
        }
    }
    
    var cardId = 0{
        didSet{
            
            let isIncrease = oldValue < cardId
            
            cardId = cardId < 0 ? 12 : cardId > 12 ? 0 : cardId
            
            let transition1 = CATransition()
            transition1.duration = 0.1
            transition1.type = CATransitionType.fade
            transition1.subtype = isIncrease ? CATransitionSubtype.fromLeft : CATransitionSubtype.fromRight
            
            imgMainCard.layer.add(transition1, forKey: kCATransition)
            imgPreCard.layer.add(transition1, forKey: kCATransition)
            imgNexCard.layer.add(transition1, forKey: kCATransition)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                
                let transition = CATransition()
                transition.duration = 0.1
                transition.type = CATransitionType.push
                transition.subtype = isIncrease ? CATransitionSubtype.fromRight : CATransitionSubtype.fromLeft
                
                self.imgMainCard.layer.add(transition, forKey: kCATransition)
                self.imgPreCard.layer.add(transition, forKey: kCATransition)
                self.imgNexCard.layer.add(transition, forKey: kCATransition)
                
                self.imgMainCard.image = self.arrCards[self.cardType][self.cardId]
                self.imgPreCard.image = self.arrCards[self.cardType][self.cardId-1 < 0 ? 12 : self.cardId-1]
                self.imgNexCard.image = self.arrCards[self.cardType][self.cardId+1 > 12 ? 0 : self.cardId+1]
                
            }
            
        }
    }
    
    var score = 0{
        didSet{
            maxScore = score > maxScore ? score : maxScore
        }
    }
    
    var timer: Timer?
    var timeLeft: Float = 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let m = UserDefaults.standard.value(forKey: "max")as? Int{
            maxScore = m
        }
        
        preLoadCardImages()
        cardId = 1
        setupGestures()
        setRandomQueCard()
        updateScoreLabel()
        
        let alert = UIAlertController(
            title: "WELCOME",
            message: """
                    YOU HAVE TO SWIPE LEFT, RIGHT, TOP AND BOTTOM TO CHANGE CARDS INDEX AND TYPE
                    MATCH THE MIDDLE CARD GET SCORE
                    ALSO KEEP EYE ON TIME LINE GET HIGHEST SCORE AS POSSIBLE
                    ALL THE BEST
                    PRESS OK TO START
                    """,
            preferredStyle: .alert
        )
        alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
        let bg = UIImageView(image: UIImage(named: "bg"))
        bg.alpha = 0.5
        alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.first?.insertSubview(bg,at: 0)
        alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.last?.subviews.first?.backgroundColor = .black
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.startTimer()
        }))
        present(alert, animated: true)

    }
    
    func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    func setRandomQueCard() {
        let randomType = Int.random(in: 0...3)
        let randomId = Int.random(in: 0...12)
        imgQueCard.image = arrCards[randomType][randomId]
        imgQueCard.tag = randomType * 100 + randomId
    }
    
    func updateScoreLabel() {
        lblScore.text = "Score: \(score)"
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            cardId -= 1
        case .left:
            cardId += 1
        case .up:
            cardType -= 1
        case .down:
            cardType += 1
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let queCardType = self.imgQueCard.tag / 100
            let queCardId = self.imgQueCard.tag % 100
            
            if self.cardType == queCardType && self.cardId == queCardId {
                self.score += 1
                self.updateScoreLabel()
                self.setRandomQueCard()
            }
        }
    }
    
    func preLoadCardImages(){
        let columns = 13
        let rows = 4
        
        guard let image = UIImage(named: "Image \((1...3).randomElement()!)") else{
            return
        }
        guard let cgImage = image.cgImage else { return }
        
        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)
        
        let tileWidth = imageWidth / CGFloat(columns)
        let tileHeight = imageHeight / CGFloat(rows)
        
        var imagePieces: [[UIImage]] = []
        
        for row in 0..<rows {
            var rowImages: [UIImage] = []
            for col in 0..<columns {
                let x = CGFloat(col) * tileWidth
                let y = CGFloat(row) * tileHeight
                let rect = CGRect(x: x, y: y, width: tileWidth, height: tileHeight)
                
                if let croppedCgImage = cgImage.cropping(to: rect) {
                    let croppedImage = UIImage(cgImage: croppedCgImage, scale: image.scale, orientation: image.imageOrientation)
                    rowImages.append(croppedImage)
                }
            }
            imagePieces.append(rowImages)
        }
        
        arrCards = imagePieces
    }
    
    func startTimer() {
        progTimer.progress = 1.0
        timeLeft = 60.0
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.timeLeft -= 0.1
            self.progTimer.progress = self.timeLeft / 60.0
            
            if self.timeLeft <= 0 {
                self.gameOver()
            }
        }
    }
    
    func gameOver() {
        timer?.invalidate()
        timer = nil
        
        let alert = UIAlertController(title: "Game Over!", 
                                    message: "Your score: \(score)", 
                                    preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.score = 0
            self?.updateScoreLabel()
            self?.setRandomQueCard()
            self?.startTimer()
        }
        
        alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
        let bg = UIImageView(image: UIImage(named: "bg"))
        bg.alpha = 0.5
        alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.first?.insertSubview(bg,at: 0)
        alert.view.subviews.first?.subviews.first?.subviews.first?.subviews.last?.subviews.first?.backgroundColor = .black
        
        alert.addAction(restartAction)
        present(alert, animated: true)
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
