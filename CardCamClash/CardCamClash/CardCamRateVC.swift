//
//  RateVC.swift
//  CardCamClash
//
//  Created by Card Cam Clash on 2025/3/6.
//


import UIKit
import StoreKit

class CardCamRateVC: UIViewController {
    
    @IBOutlet var btnsRate: [UIButton]!
    @IBOutlet weak var fieldInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnSendFeed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "THANK YOU FOR YOUR FEEDBACK!", message: "WE WILL APRECIATE YOUR FEEDBACK & TIME.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "BACK", style: .default, handler: { alert -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnsRate(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.5, y: 1.5).rotated(by: .pi/6)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        }
        
        for b in btnsRate {
            b.isSelected = b.tag <= sender.tag
        }
        
    }
    
    @IBAction func btnRate(_ sender: Any) {
        
        SKStoreReviewController.requestReview()
        
    }
    
}
