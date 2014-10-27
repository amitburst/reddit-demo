//
//  BrowserViewController.swift
//  Reddit
//
//  Created by Amit Burstein on 10/26/14.
//  Copyright (c) 2014 Amit Burstein. All rights reserved.
//

import Foundation
import UIKit

class BrowserViewController : UIViewController {
    
    var postTitle: String?
    var postUrl: String?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = postTitle
        
        // load url request
        let url = NSURL(string: postUrl!)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
}