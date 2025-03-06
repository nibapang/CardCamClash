//
//  AllCardsVC.swift
//  CardCamClash
//
//  Created by Card Cam Clash on 2025/3/6.
//


import UIKit

class CardCamAllCardsVC: UIViewController {

    @IBOutlet weak var cv: UICollectionView!
    
    var arrCards: [[UIImage]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preLoadCardImages()
        
        cv.delegate = self
        cv.dataSource = self
        
    }
    
    
    func preLoadCardImages(){
        let columns = 13
        let rows = 4
        
        var imagePieces: [[UIImage]] = []
        
        for i in ["Image 1","Image 2","Image 3"]{
            guard let image = UIImage(named: i) else{
                return
            }
            guard let cgImage = image.cgImage else { return }
            
            let imageWidth = CGFloat(cgImage.width)
            let imageHeight = CGFloat(cgImage.height)
            
            let tileWidth = imageWidth / CGFloat(columns)
            let tileHeight = imageHeight / CGFloat(rows)
            
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
            
        }
        
        arrCards = imagePieces
    }
    
}


extension CardCamAllCardsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCards[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardsCell", for: indexPath)as! CardCamCardsCell
        cell.img.image = arrCards[indexPath.section][indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.size.width/10
        return CGSize(width: w, height: w * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: 30, height: 30)
    }
    
}
