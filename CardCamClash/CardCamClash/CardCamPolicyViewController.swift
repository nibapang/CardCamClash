//
//  CardCamPolicyViewController.swift
//  CardCamClash
//
//  Created by Card Cam Clash on 2025/3/6.
//

import UIKit
import Adjust
import WebKit

class CardCamPolicyViewController: UIViewController, WKNavigationDelegate , WKUIDelegate, WKScriptMessageHandler {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indView: UIActivityIndicatorView!
    @objc var urlStr: String?
    let ads: [String] = UserDefaults.standard.object(forKey: "ADSdatas") as? [String] ?? Array.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.backBtn.isHidden = self.urlStr != nil
        self.indView.hidesWhenStopped = true
        
        camInitWebView()
    }
    
    func camInitWebView() {
        view.backgroundColor = .black
        self.webView.backgroundColor = .black
        self.webView.scrollView.backgroundColor = .black
        webView.isOpaque = false
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        if ads.count > 3 {
            let userContentC = self.webView.configuration.userContentController
            let trackStr = ads[1]
            let trackScript = WKUserScript(source: trackStr, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentC.addUserScript(trackScript)
            userContentC.add(self, name: ads[2])
            userContentC.add(self, name: ads[3])
        }
        
        
        self.indView.startAnimating()
        if let adurl = urlStr {
            if let urlRequest = URL(string: adurl) {
                let request = URLRequest(url: urlRequest)
                webView.load(request)
            }
        } else {
            if let urlRequest = URL(string: "https://www.termsfeed.com/live/e7f4467f-f9ea-4491-914f-d0c96294f417") {
                let request = URLRequest(url: urlRequest)
                webView.load(request)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.indView.stopAnimating()
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.indView.stopAnimating()
        }
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return nil
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if ads.count < 4 {
            return
        }
        
        if message.name == ads[2] {
            if let data = message.body as? String {
                if let url = URL(string: data) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } else if message.name == ads[3] {
            if let data = message.body as? [String : Any] {
                if let evTok = data["eventToken"] as? String, !evTok.isEmpty {
                    print("eventToken：\(evTok)")
                    Adjust.trackEvent(ADJEvent(eventToken: evTok))
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
