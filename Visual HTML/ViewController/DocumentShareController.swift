//
//  DocumentShareController.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/23.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit
class DocumentShareController:UIViewController,UIDocumentInteractionControllerDelegate,UIScrollViewDelegate{
    var path:URL?
    var topath:URL = URL(fileURLWithPath: Constant.MY_DIRECTORY)
    var scrollView:UIScrollView!
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
    self.view.backgroundColor = UIColor.white
        scrollView = UIScrollView(frame: CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height))
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        self.view.addSubview(scrollView)
        let contentsOfPath = try! FileManager.default.contentsOfDirectory(atPath: topath.path)
        var cumulatedHeight:CGFloat = 20
        for item in contentsOfPath{
            let fileview = FileView(name: item, frame: CGRect(x:CGFloat(0), y: cumulatedHeight, width: self.view.frame.width, height: CGFloat(20)))
            fileview.touchButton.addTarget(self, action: #selector(addPathComponent), for: UIControlEvents.touchDown)
            scrollView.addSubview(fileview)
            cumulatedHeight += 20
        }
        var importButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.midY, width: self.view.frame.width, height: 20))
        importButton.backgroundColor = UIColor.blue
        importButton.setTitle("Import", for: UIControlState())
        importButton.setTitleColor(UIColor.white, for: UIControlState())
        importButton.addTarget(self, action: #selector(importFile), for: UIControlEvents.touchDown)
        importButton.layer.cornerRadius = 10
       // self.view.addSubview(scrollView)
        self.view.addSubview(importButton)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @objc func addPathComponent(_ sender:UIButton){
        topath = URL(fileURLWithPath:topath.path + "/" + (sender.superview as! FileView).name + "/")
        print(topath.path)
        
        for view in scrollView.subviews{
            if view.isKind(of: FileView.self){
                view.removeFromSuperview()
            }
        }
        let contentsOfPath = try! FileManager.default.contentsOfDirectory(atPath: topath.path)
        var cumulatedHeight:CGFloat = 20
        for item in contentsOfPath{
            let fileview = FileView(name: item, frame: CGRect(x:CGFloat(0), y: cumulatedHeight, width: self.view.frame.width, height: CGFloat(20)))
            if !item.contains("."){
            fileview.touchButton.addTarget(self, action: #selector(addPathComponent), for: UIControlEvents.touchDown)
            }
            scrollView.addSubview(fileview)
            cumulatedHeight += 20
        }
    }
    
    @objc func importFile(){
       // topath = URL(fileURLWithPath: "file:///private" + topath.path)
        topath.appendPathComponent((path?.lastPathComponent)!, isDirectory: false)
        if (path != nil){
          
            try? FileManager.default.copyItem(at: path!, to: topath)
          topath.deleteLastPathComponent()
           let contents = try? FileManager.default.contentsOfDirectory(atPath: topath.path)
           print(contents)
        }
    }
    
    func share(){
        print("path is \(path)")
        var doc = UIDocumentInteractionController(url: path!)
        doc.delegate = self
        let canOpen = doc.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
        
    }
    
    func preview(){
        var doc = UIDocumentInteractionController(url: path!)
        doc.delegate = self
        doc.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        self.dismiss(animated: true, completion: nil)
    }
}
