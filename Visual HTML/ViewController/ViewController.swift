//
//  ViewController.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/2.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var fileCreator: UIView!
    var ifWebViewHidden:Bool = false
    var ifProjectViewHidden:Bool = false
    var fileSelected:String = ""
    var webController:WebView!
    var projectController:StackFileViewer!
    @IBOutlet var projectView: UIView!
    var editorController:Editor!
    @IBOutlet var webView: UIView!
    @IBOutlet var editorView: UIView!
    @IBOutlet var visualEditor: UIButton!
    @IBOutlet var codeButton: UIButton!
    @IBAction func codeVIew(_ sender: Any) {
        webView.isHidden = true
        editorView.isHidden = false
    }
    @IBOutlet var preView: UIButton!
    @IBOutlet var visualView: UIView!
    @IBAction func preView(_ sender: Any) {
        if fileSelected != ""{
        webController.loadview(fileName: fileSelected)
        }
        webViewRestore()
    }
    
    func load(){
        if fileSelected != ""{
            webController.loadview(fileName: fileSelected)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        visualEditor.center.x = self.view.center.x
        codeButton.center.x = visualEditor.center.x - 50
        preView.center.x = visualEditor.center.x + 50
        webView.frame.size.width = self.view.frame.size.width/8*3
        webView.frame.size.height = self.view.frame.size.height-40
        webView.center = CGPoint(x:view.frame.size.width/16*13,y:self.view.center.y+20)
        webViewHide()
        editorView.frame.size.width = self.view.frame.size.width/4*3
        editorView.frame.size.height = self.view.frame.size.height-40
        editorView.center = CGPoint(x:view.frame.size.width/16*7,y:self.view.center.y+20)
        projectView.frame.size.width = self.view.frame.size.width/4
        projectView.frame.size.height = self.view.frame.size.height-40
        projectView.center = CGPoint(x:self.view.center.x/4,y:self.view.center.y+20)
        fileCreator.center = self.view.center
        visualView.frame.size.width = self.view.frame.size.width/4*3
        visualView.frame.size.height = self.view.frame.size.height-40
        visualView.center = CGPoint(x:self.view.bounds.width/8*5,y:self.view.center.y+20)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeGesture.direction = .left
        // Do any additional setup after loading the view, typically from a nib.
        let swipeGesture2 =  UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        swipeGesture2.direction = .right
        
        let swipeGesture3 =  UISwipeGestureRecognizer(target: self, action: #selector(viewGesture(_:)))
        swipeGesture3.direction = .right
        let swipeGesture4 =  UISwipeGestureRecognizer(target: self, action: #selector(viewGesture(_:)))
        swipeGesture4.direction = .left
        
       
        self.projectView.addGestureRecognizer(swipeGesture)
        self.webView.addGestureRecognizer(swipeGesture2)
        self.view.addGestureRecognizer(swipeGesture3)
        self.view.addGestureRecognizer(swipeGesture4)
    }
    
    @objc func viewGesture(_ sender:UISwipeGestureRecognizer){
        
    }
    
    @objc func swipeGesture(_ sender: UISwipeGestureRecognizer){
        switch sender.direction {
        case .left:
            print("Swiped left")
            switch sender.view{
            case projectView?:
            print("project View Swiped")
            if ifProjectViewHidden == false{
                projectViewHide()
                ifProjectViewHidden = true
                }
                /*
            case view?:
                if sender.location(in: view).x > self.view.frame.width/16*13{
                    if ifWebViewHidden{
                    webViewRestore()
                    ifWebViewHidden = false
                    }
                }
 */
            case .none:
                break
            case .some(_):
                break
            }
        case .right:
            switch sender.view{
            case webView?:
                print("WebView Swiped")
                if ifWebViewHidden == false{
               webViewHide()
                  ifWebViewHidden = true
                }
                /*
            case view?:
                if sender.location(in: view).x < self.view.frame.width/4{
                    if ifProjectViewHidden{
                    projectViewRestore()
                    ifProjectViewHidden = false
                    }
                }
            */
            case .none:
                break
            case .some(_):
                break
            }
        default:
            break
        }
    }
    
    func projectViewHide(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        projectView?.transform = CGAffineTransform(translationX: -self.view.frame.size.width/4, y: 0)
        UIView.commitAnimations()
    }
    
    func projectViewRestore(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        projectView?.transform = CGAffineTransform(translationX: self.view.frame.size.width/4, y: 0)
        UIView.commitAnimations()
    }
    
    func webViewHide()
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        webView?.transform = CGAffineTransform(translationX: self.view.frame.size.width/8*3, y: 0)
        UIView.commitAnimations()
    }
    
    func webViewRestore(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        webView?.transform = CGAffineTransform(translationX: -self.view.frame.size.width/8*3, y: 0)
        UIView.commitAnimations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constant.WEB_SEGUE?:
             webController = segue.destination as! WebView
        case Constant.EDITOR_SEGUE?:
             editorController = segue.destination as! Editor
        case Constant.PROJECT_SEGUE?:
             projectController = segue.destination as! StackFileViewer
             projectController.parentController = self
        default:
            break
        }
        
    }
}

