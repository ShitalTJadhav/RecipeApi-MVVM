//
//  WebviewViewController.swift
//  RecipeApp
//
//  Created by Tushar  Jadhav on 2019-01-19.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import UIKit
import WebKit

class WebviewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var urlString : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Recipe View"
        
        if let url = URL(string: self.urlString ) {
            let requestObj = URLRequest(url: url)
            webView.load(requestObj)
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
