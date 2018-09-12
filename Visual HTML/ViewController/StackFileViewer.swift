//
//  StackFileViewer.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/3.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class StackFileViewer:UIViewController{
    
    @IBOutlet var scrollView: UIScrollView!
    var cumulatedHeight:Int = 0
    var parentController:ViewController!
    var fileSelected:String = ""
    var urlSelected:String = ""
    @IBOutlet var stackView: UIStackView!
    let parentNode = Node(name: ProjectName, storage: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addFile(_ sender: Any) {
        parentController.fileCreator.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layer.cornerRadius = 20
        self.view.layer.borderWidth = 0.5
        //self.view.layer.borderColor = CGColor.
        stackView.center.x = self.view.frame.width/2
        stackView.center.y = self.view.frame.height/2 + 40
        stackView.frame.size = CGSize(width:self.view.frame.width,height: self.view.frame.height-40)
       print("ProjectName\(ProjectName)")
        let view = FileView(name: ProjectName, frame: CGRect(x:0,y:cumulatedHeight,width:Int(self.view.frame.width),height:30), Stanza: 0, Type: "project",url:ProjectUrl)
        view.parentController = self
        cumulatedHeight += 30
        view.center.x = self.stackView.frame.width/2
        self.scrollView.addSubview(view)
        
        print("stackView")
        
        print(URL(fileURLWithPath:ProjectUrl).path)
        dealNode(path:URL(fileURLWithPath:ProjectUrl).path,paths: try! FileManager.default.contentsOfDirectory(atPath: URL(fileURLWithPath:ProjectUrl).path),node:parentNode)
        load(node:parentNode,stanza:1)
}
    
    func dealNode(path:String,paths:[String],node:Node){
        print(paths)
        for name in paths{
            var emptydic = Dictionary<String,Any>()
            let child = Node(name:name,storage:emptydic)
            
            if name.contains(".html"){
            var dic = child.storage as! Dictionary<String,Any>
            dic["type"] = "html"
            dic["url"] = path + "/" + name
            child.storage = dic
            }else if name.contains(".php"){
                var dic = child.storage as! Dictionary<String,Any>
                dic["type"] = "php"
                dic["url"] = path + "/" + name
                child.storage = dic
            }else if name.contains(".css"){
                var dic = child.storage as! Dictionary<String,Any>
                dic["type"] = "css"
                dic["url"] = path + "/" + name
                child.storage = dic
            }else if name.contains(".js"){
                var dic = child.storage as! Dictionary<String,Any>
                dic["type"] = "js"
                dic["url"] = path + "/" + name
                child.storage = dic
            }else if name.contains(".")
            {
                var dic = child.storage as! Dictionary<String,Any>
                dic["type"] = "other"
                dic["url"] = path + "/" + name
                child.storage = dic
            }
            if !name.contains("."){
                let subPaths = try? FileManager.default.contentsOfDirectory(atPath: path + "/" + name + "/")
                var dic = child.storage as! Dictionary<String,Any>
                dic["type"] = "folder"
                dic["url"] = path + "/" + name + "/"
               child.storage = dic
                if subPaths != nil{
                dealNode(path: path + "/" + name,paths: subPaths!,node: child)
                }
            }
            node.addChildNode(child: child)
        }
        
    }
    
    func load(node:Node,stanza:Int){
        var locationNode:Node = node
        var stanza = stanza
        for node in locationNode.getChildNode()
                {
                     print(node.name)
                    locationNode = node
                    //load Stanza 1
                    let dic = locationNode.storage as! Dictionary<String,Any>
                    let type:String = dic["type"] as! String
                    let url:String = dic["url"] as! String
                    let view = FileView(name: locationNode.name, frame: CGRect(x:0,y:cumulatedHeight,width:Int(self.view.frame.width),height:30), Stanza: stanza, Type: type, url:url)
                     let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(uploadSetting))
                    swipeLeftGesture.direction = .left
                     view.addGestureRecognizer(swipeLeftGesture)
                     view.touchButton.addTarget(self, action:#selector(openfile), for: UIControlEvents.touchDown)
                    cumulatedHeight += 30
                    self.scrollView.addSubview(view)
                    view.parentController = self
                    if locationNode.hasChild(){
                        stanza += 1
                        load(node:locationNode,stanza:stanza)
                        stanza -= 1
                    }
                    //load Stanza 2
                }
    }
    
    @objc func uploadSetting(_ sender: UISwipeGestureRecognizer){
        
        (sender.view as! FileView).uploadSetting()
         (sender.view as! FileView).setting()
        
    }
    
    func clearViews(){
        for view in self.scrollView.subviews{
            if view.isKind(of: FileView.self){
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func openfile(_ sender:UIButton){
        (sender.superview as! FileView).openfile()
    }
    
   @objc func restore(){
        for view in self.scrollView.subviews{
            if view.isKind(of: FileView.self)
           {
             view.backgroundColor = UIColor.clear
            }
        }
    }
    


}
