//
//  DetailViewController.swift
//  AssignmentTask
//
//  Created by Vignesh on 30/09/21.
//

import UIKit
import WebKit

class DetailViewController:  UIViewController, WKNavigationDelegate {
    
    var finalUrl = ""
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    private func loadWebView() {
        webView.navigationDelegate = self
        view = webView
        if let url = URL(string: self.finalUrl) {
            webView.load(URLRequest(url: url))
        }
        webView.allowsBackForwardNavigationGestures = true
    }
    
    
}

extension DetailViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.view.activityStopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.view.activityStartAnimating(activityColor: .red, backgroundColor: .clear)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.view.activityStopAnimating()
    }
}



