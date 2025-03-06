//
//  GetStartedVC.swift
//  CardCamClash
//
//  Created by Card Cam Clash on 2025/3/6.
//


import UIKit
import Reachability

class CardCamGetStartedVC: UIViewController {
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var reachability: Reachability!
    
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startAnimations()
        }
        
        self.activityView.hidesWhenStopped = true
        camPokerLoadAdsData()
    }
    
    private func camPokerLoadAdsData() {
        guard camPokerNeedLoadAdBannData() else { return }
        
        do {
            reachability = try Reachability()
        } catch {
            print("Unable to create Reachability: \(error)")
            return
        }
        
        if reachability.connection == .unavailable {
            reachability.whenReachable = { [weak self] _ in
                self?.reachability.stopNotifier()
                self?.camPokerGetLoadAdsData()
            }
            reachability.whenUnreachable = { _ in }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier: \(error)")
            }
        } else {
            camPokerGetLoadAdsData()
        }
    }

    private func camPokerGetLoadAdsData() {
        activityView.startAnimating()
        
        guard let bundleId = Bundle.main.bundleIdentifier else {
            activityView.stopAnimating()
            return
        }
        
        let hostUrl = camPokerHostUrl()
        let endpoint = "https://open.ma\(hostUrl)/open/camPokerGetLoadAdsData"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL: \(endpoint)")
            activityView.stopAnimating()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "appSystemName": UIDevice.current.systemName,
            "appModelName": UIDevice.current.model,
            "appKey": "703437ac33194393a5125773d22ccc1d",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            activityView.stopAnimating()
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    self.activityView.stopAnimating()
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        if let dataDic = dictionary {
                            if let adsData = dataDic["jsonObject"] as? [String] {
                                UserDefaults.standard.set(adsData, forKey: "ADSdatas")
                                self.camPokerShowAdView(adsData[0])
                                return
                            }
                        }
                    }
                    self.activityView.stopAnimating()
                
                } catch {
                    self.activityView.stopAnimating()
                 
                }
            }
        }
        
        task.resume()
    }
    
    private func setupInitialState() {
        // Initial states for animations
        imgLogo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        imgLogo.alpha = 0
        
        imgBg.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        imgBg.alpha = 0
    }
    
    private func startAnimations() {
        animateBackground()
        animateLogo()
    }
    
    private func animateBackground() {
        // Background fade in with zoom effect
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.imgBg.transform = .identity
            self.imgBg.alpha = 1
        }
        
        // Start continuous background animation
        startBackgroundPulse()
        startBackgroundShimmer()
    }
    
    private func startBackgroundPulse() {
        UIView.animate(withDuration: 3.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut]) {
            self.imgBg.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    private func startBackgroundShimmer() {
        let shimmerView = UIView(frame: imgBg.bounds)
        shimmerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        shimmerView.alpha = 0
        imgBg.addSubview(shimmerView)
        
        UIView.animate(withDuration: 2.5, delay: 0, options: [.repeat, .curveEaseInOut]) {
            shimmerView.alpha = 0.4
            shimmerView.frame.origin.x = self.imgBg.frame.width
        } completion: { _ in
            shimmerView.frame.origin.x = -self.imgBg.frame.width
        }
    }
    
    private func animateLogo() {
        // Initial pop-in animation
        UIView.animate(withDuration: 1.2, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.imgLogo.transform = .identity
            self.imgLogo.alpha = 1
        } completion: { _ in
            self.startLogoFloatingAnimation()
            self.startLogoRotationAnimation()
            self.startLogoGlowEffect()
        }
    }
    
    private func startLogoFloatingAnimation() {
        // Floating animation
        let floatAnimation = CABasicAnimation(keyPath: "position.y")
        floatAnimation.duration = 2.0
        floatAnimation.fromValue = self.imgLogo.center.y
        floatAnimation.toValue = self.imgLogo.center.y - 10
        floatAnimation.autoreverses = true
        floatAnimation.repeatCount = .infinity
        floatAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.imgLogo.layer.add(floatAnimation, forKey: "floatingAnimation")
    }
    
    private func startLogoRotationAnimation() {
        // Subtle rotation animation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = -0.05
        rotationAnimation.toValue = 0.05
        rotationAnimation.duration = 2.5
        rotationAnimation.autoreverses = true
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.imgLogo.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func startLogoGlowEffect() {
        // Glow effect
        let glowView = UIView(frame: imgLogo.frame)
        glowView.backgroundColor = .clear
        glowView.layer.shadowColor = UIColor.white.cgColor
        glowView.layer.shadowOffset = .zero
        glowView.layer.shadowRadius = 10
        glowView.layer.shadowOpacity = 0
        view.insertSubview(glowView, belowSubview: imgLogo)
        
        UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut]) {
            glowView.layer.shadowOpacity = 0.8
        }
    }
    
    // MARK: - Memory Management
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove animations when view disappears
        imgLogo.layer.removeAllAnimations()
        imgBg.layer.removeAllAnimations()
    }
    
}
