//
//  HomeVC.swift
//  CardCamClash
//
//  Created by Card Cam Clash on 2025/3/6.
//


import UIKit
import StoreKit

class CardCamHomeVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var scrl: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrl.delegate = self
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        img.transform = CGAffineTransform(rotationAngle: scrollView.contentOffset.y/scrollView.bounds.height * .pi/2)
    }
    
    @IBAction func btnRate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction func btnShareApp(_ sender: Any) {
        let appID = "YOUR_APP_ID"
        let appURL = "https://apps.apple.com/app/id\(appID)"
        let message = "Check out Card Cam Clash on the App Store!"
        
        let items = [message, appURL]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        
        present(activityVC, animated: true)
    }
}
