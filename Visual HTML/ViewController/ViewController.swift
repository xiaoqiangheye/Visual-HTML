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
    var ifVisualViewHidden:Bool = false
    var ifEditorViewHidden:Bool = false
    var fileSelected:String = ""
    var webController:WebView!
    var projectController:StackFileViewer!
    var fileCreatorController:FileCreator!
    var visualController:VisualController!
    var FTPViewerController:FTPViewController!
    var FTPConfigurationController:FTPConfiguration!
    @IBOutlet var projectView: UIView!
    var editorController:Editor!
    @IBOutlet var webView: UIView!
    @IBOutlet var editorView: UIView!
    @IBOutlet var visualEditor: UIButton!
    @IBOutlet var codeButton: UIButton!
    @IBAction func codeVIew(_ sender: Any) {
        if !ifWebViewHidden{
        webViewHide()
        }
        if !ifVisualViewHidden{
        visualViewHide()
        }
        if ifEditorViewHidden{
            editorViewRestore()
        }
    }
    @IBOutlet var preView: UIButton!
    @IBOutlet var visualView: UIView!
    @IBAction func preView(_ sender: Any) {
        if fileSelected != ""{
        webController.loadview(fileName: fileSelected)
        }
        if ifWebViewHidden{
        webViewRestore()
        }
    }
    
    @IBAction func VisualView(_ sender: Any) {
        visualController.clear()
        let block = HtmlParser.htmlToBlock(code:editorController.scripts.text)
        let blockView = visualController.loadBlocks(parentNode: block)
        visualController.view.addSubview(blockView)
        if !ifWebViewHidden{
        webViewHide()
        }
        if !ifEditorViewHidden{
        editorViewHide()
        }
        if ifVisualViewHidden{
        visualViewRestore()
        }
    }
    
    @IBOutlet var FTPConfigurationView: UIView!
    @IBOutlet var FTPView: UIView!
    
    @IBAction func FTP(_ sender: Any) {
        if FTPView.isHidden{
        FTPView.isHidden = false
        self.view.bringSubview(toFront: FTPView)
        }else{
        FTPView.isHidden = true
        }
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
        editorView.center = CGPoint(x:self.view.bounds.width/8*5,y:self.view.center.y+20)
        projectView.frame.size.width = self.view.frame.size.width/4
        projectView.frame.size.height = self.view.frame.size.height-40
        projectView.center = CGPoint(x:self.view.center.x/4,y:self.view.center.y+20)
        
        fileCreator.frame.size.width = 400
        fileCreator.frame.size.height = 400
        fileCreator.center = self.view.center
       
        visualView.frame.size.width = self.view.frame.size.width/4*3
        visualView.frame.size.height = self.view.frame.size.height-40
        visualView.center = CGPoint(x:self.view.bounds.width/8*5,y:self.view.center.y+20)
        visualViewHide()
        
        FTPView.frame.size.width = self.view.frame.size.width/4*3
        FTPView.frame.size.height = self.view.frame.size.height-40
        FTPView.center = CGPoint(x:self.view.bounds.width/8*5,y:self.view.center.y+20)
        FTPConfigurationView.center = self.view.center
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
        ifProjectViewHidden = true
    }
    
    func projectViewRestore(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        projectView?.transform = CGAffineTransform(translationX: self.view.frame.size.width/4, y: 0)
        UIView.commitAnimations()
        ifProjectViewHidden = false
    }
    
    func webViewHide()
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        webView?.transform = CGAffineTransform(translationX: self.view.frame.size.width/8*3, y: 0)
        UIView.commitAnimations()
        ifWebViewHidden = true
    }
    
    func webViewRestore(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        webView?.transform = CGAffineTransform(translationX: -self.view.frame.size.width/8*3, y: 0)
        UIView.commitAnimations()
        ifWebViewHidden = false
    }
    
    func visualViewHide(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
       
        visualView.center.x = visualView.center.x + self.view.frame.size.width/4*3
        UIView.commitAnimations()
        ifVisualViewHidden = true
    }
    
    func visualViewRestore(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
         visualView.center.x = visualView.center.x - self.view.frame.size.width/4*3
        UIView.commitAnimations()
        ifVisualViewHidden = false
    }
    
    func editorViewHide(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        editorView.center.x = editorView.center.x + self.view.frame.size.width/4*3
        UIView.commitAnimations()
        ifEditorViewHidden = true
    }
    
    func editorViewRestore(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        editorView.center.x = editorView.center.x - self.view.frame.size.width/4*3
        UIView.commitAnimations()
        ifEditorViewHidden = false
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
        case Constant.VISUAL_SEGUE?:
             visualController = segue.destination as! VisualController
        case Constant.File_CREATOR_SEGUE?:
             fileCreatorController = segue.destination as! FileCreator
        case Constant.FTP_CONFIGURATION_SEGUE?:
             FTPConfigurationController = segue.destination as! FTPConfiguration
           FTPConfigurationController.parentController = self
        case Constant.FTP_VIEWER_SEGUE?:
            FTPViewerController = segue.destination as! FTPViewController
            FTPViewerController.parentController = self
        default:
            break
        }
        
    }
}

