//
//  WebView.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/2.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class WebView:UIViewController{
    var webView:WKWebView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        conf.allowsInlineMediaPlayback = true
       // conf.userContentController.add(self as! WKScriptMessageHandler, name: "msgBridge")
        webView = WKWebView()
        webView.frame.size.width = self.view.frame.width-20
        webView.frame.size.height = self.view.frame.height-30
        webView.center = self.view.center
        webView.layer.cornerRadius = 20
        self.view.layer.cornerRadius = 20
        /*
        var data:NSString! = ""
        do{
             data = try NSString(contentsOf: NSURL(fileURLWithPath: "\(sp[0])/test.html") as URL, encoding: String.Encoding.utf8.rawValue)
            print(data)
        }catch let error as NSError{
            print(error)
        }
        webView.loadHTMLString(data as String, baseURL: Bundle.main.bundleURL)
 */
        
        view.addSubview(webView)
        
    }
    
    func loadview(fileName:String){
        var data:NSString! = ""
        do{
            data = try NSString(contentsOf: NSURL(fileURLWithPath: ProjectUrl + fileName) as URL, encoding: String.Encoding.utf8.rawValue)
            print(data)
        }catch let error as NSError{
            print(error)
        }
        //webView.loadHTMLString(data as String, baseURL: URL(fileURLWithPath: ProjectUrl))
        
       webView.loadFileURL(URL(fileURLWithPath: ProjectUrl + fileName), allowingReadAccessTo: URL(fileURLWithPath: ProjectUrl))
        //print(ProjectUrl + fileName)
        //let urlStr = NSURL.fileURL(withPath: ProjectUrl + fileName)
        //print(urlStr)
        //webView.load(URLRequest(url: urlStr))
    }
 
}
