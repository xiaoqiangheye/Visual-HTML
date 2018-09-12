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
    @IBOutlet var propertiesView: UIView!
    @IBAction func printCode(_ sender: Any) {
        //Ask if sync to The editor
        let alertView:AlertView = AlertView(button1: "Yes", button2: "No", title: "Sync",content:"Do you want to sync and save the codes?")
        alertView.button1.addTarget(self, action: #selector(syncAndSave), for: .touchDown)
        alertView.button2.addTarget(self, action: #selector(cancel), for: .touchDown)
        alertView.center = self.view.center
        self.view.addSubview(alertView)
    }
    
    @objc func syncAndSave(_ sender: UIButton){
        print("Start to Sync")
        let url =  (self.parent as! ViewController).editorController.url
        print("url\(url)")
        print("code\(loadCode())")
        let data = NSMutableData()
        data.append(NSData(data:loadCode().data(using: String.Encoding.utf8)!) as Data)
        data.write(toFile: url, atomically: true)
        (self.parent as! ViewController).editorController.scripts.text = loadCode()
         (self.parent as! ViewController).editorController.textViewDidChange((self.parent as! ViewController).editorController.scripts)
         (sender.superview as! AlertView).removeFromSuperview()
    }
    
    @objc func cancel(_ sender: UIButton){
        (sender.superview as! AlertView).removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 15
        let panGesgure = UIPanGestureRecognizer(target: self, action: #selector(dealPangesture(_:)))
        //subView = BlockView(frame: CGRect(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2,width:200,height:200), wordTag: "")
       // subView.center = self.view.center
       // self.view.addSubview(subView)
        view.addGestureRecognizer(panGesgure)
    }
    
    @objc func dealPangesture(_ sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        for view in self.view.subviews{
            if view.isKind(of: BlockView.self){
        view.center.x += translation.x
        view.center.y += translation.y
        sender.setTranslation(CGPoint(x:0,y:0), in: self.view)
            }
        }
    }
    
    func loadProperties(block:BlockView){
        var cumulatedHeights:Int = 20
        let properties = block.properties
        for (key,value) in properties{
            let propertyCell:PropertiesView = PropertiesView(frame: CGRect(x:20,y:CGFloat(cumulatedHeights),width:self.propertiesView.bounds.width,height:self.view.bounds.height), key: key, value: value)
            self.propertiesView.addSubview(propertyCell)
            cumulatedHeights += 20
        }
    }
    
    func loadCode()->String{
        var parentBlockView:BlockView!
        for view in self.view.subviews{
            if view.isKind(of: BlockView.self){
                let blockview = view as! BlockView
                if !blockview.hasParent(){
                    parentBlockView = blockview
                }
            }
        }
     print("parentNode\(parentBlockView.wordTag)")
       let string = dealwithparentBlock(parent: parentBlockView,code:"")
        
       return string
        }
    
    
    func loadBlocks(parentNode:Node)->BlockView{
        let locationNode = parentNode
        var block:BlockView!
        if parentNode.name != "text"{
            if ((parentNode.storage as! [String:Any])["withEndTag"] != nil){
        block = BlockView(frame: CGRect(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2,width:200,height:50), wordTag: parentNode.name)
        block.parentController = self
        block.properties = (parentNode.storage as! Dictionary<String,Any>)[Constant.HTML.PROPERTIES_KEY] as! [String : Any]
            }else{
        block = BlockViewWithNoEndTag(frame: CGRect(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2,width:200,height:20), wordTag: parentNode.name)
        block.parentController = self
        block.properties = (parentNode.storage as! Dictionary<String,Any>)[Constant.HTML.PROPERTIES_KEY] as! [String : Any]
            }
        }else if parentNode.name == "text"{
            let dic = (parentNode.storage as! Dictionary<String,Any>)[Constant.HTML.PROPERTIES_KEY] as! [String:Any]
        let wordTag = dic["text"]
            block = TextBlock(frame: CGRect(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2,width:200,height:20), wordTag: wordTag as! String)
        block.parentController = self
        block.properties = dic
        }
        if locationNode.hasChild(){
            for child in locationNode.childNode{
                block.addBlockwithBlock(block: loadBlocks(parentNode: child))
            }
        }
        
        return block
    }
    
    func dealwithparentBlock(parent:BlockView, code:String)->String{
    var string:String = code
    if parent.isKind(of: TextBlock.self)
    {
    string.append(parent.properties["text"] as! String)
    string.append("\n")
    }else if parent.isKind(of: BlockViewWithNoEndTag.self){
    string.append("<" + parent.wordTag)
    var properties = parent.properties
    for (key,value) in properties{
    string.append(" ")
    string.append(key)
    string.append("=")
    string.append(value as! String)
    }
    string.append(">")
    string.append("\n")
    }
    else if parent.isKind(of: BlockView.self){
        if parent.wordTag != "" && parent.hasParent(){
        string.append("<" + parent.wordTag)
        var properties = parent.properties
            for (key,value) in properties{
                string.append(" ")
                string.append(key)
                string.append("=")
                string.append(value as! String)
            }
        string.append(">")
        string.append("\n")
        
            }
        
        if parent.hasChildren(){
            for child in parent.childs{
                let str = dealwithparentBlock(parent: child, code: "")
                string.append(str)
                print(string)
            }
            }
        if parent.wordTag != "" && parent.hasParent(){
        string.append("</" + parent.wordTag + ">")
        string.append("\n")
        }
        }
        
        return string
    }
    
    func clear(){
        for view in self.view.subviews{
            if view.isKind(of: BlockView.self){
                view.removeFromSuperview()
            }
        }
    }
    
    

}
