//
//  VisualController.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/6.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class VisualController:UIViewController,UIScrollViewDelegate{
    var code:String = ""
    var subView:BlockView!
    @IBAction func printCode(_ sender: Any) {
        loadCode()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 15
        let panGesgure = UIPanGestureRecognizer(target: self, action: #selector(dealPangesture(_:)))
      
        
        subView = BlockView(frame: CGRect(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2,width:200,height:200), wordTag: "")
        subView.center = self.view.center
        self.view.addSubview(subView)
        
        view.addGestureRecognizer(panGesgure)
    }
    
    @objc func dealPangesture(_ sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        subView.center.x += translation.x
        subView.center.y += translation.y
        sender.setTranslation(CGPoint(x:0,y:0), in: self.view)
    }
    
    func loadCode(){
        var parentBlockView:BlockView!
        for view in self.view.subviews{
            if view.isKind(of: BlockView.self){
                let blockview = view as! BlockView
                if !blockview.hasParent(){
                    parentBlockView = blockview
                }
            }
        }
       let string = dealwithparentBlock(parent: parentBlockView,code:"")
        print(string)
        }
    
    
    
    func dealwithparentBlock(parent:BlockView, code:String)->String{
        var string:String = code
        string.append("<" + parent.wordTag + ">")
        string.append("\r")
        if parent.hasChildren(){
            for child in parent.childs{
        let str = dealwithparentBlock(parent: child, code: "")
        string.append(str)
        print(string)
            }
        
        }
        string.append("</" + parent.wordTag + ">")
        string.append("\r")
        return string
    }
    
    

}
