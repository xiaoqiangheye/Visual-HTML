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
        let view = FileView(name: ProjectName, frame: CGRect(x:0,y:cumulatedHeight,width:Int(self.view.frame.width),height:30), Stanza: 0, Type: "")
        view.parentController = self
        cumulatedHeight += 30
        view.center.x = self.stackView.frame.width/2
        self.scrollView.addSubview(view)
        
        print("stackView")
        dealNode(path:URL(fileURLWithPath:ProjectUrl).path,paths: try! FileManager.default.contentsOfDirectory(atPath: URL(fileURLWithPath:ProjectUrl).path),node:parentNode)
        load(node:parentNode,stanza:1)
}
    
    func dealNode(path:String,paths:[String],node:Node){
        print(paths)
        for name in paths{
            let child = Node(name:name,storage:nil)
            node.addChildNode(child: child)
            if !name.contains(".") && !FileManager.default.isWritableFile(atPath:path + name + "/"){
                let subPaths = try? FileManager.default.contentsOfDirectory(atPath: path + name + "/")
                if subPaths != nil{
                dealNode(path: path + name + "/",paths: subPaths!,node: child)
                }
            }
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
                    let view = FileView(name: locationNode.name, frame: CGRect(x:0,y:cumulatedHeight,width:Int(self.view.frame.width),height:30), Stanza: stanza, Type: "")
                    cumulatedHeight += 30
                    self.scrollView.addSubview(view)
                    view.parentController = self
                    if locationNode.hasChild(){
                        stanza += 1
                        load(node:locationNode,stanza:stanza)
                    }
                    //load Stanza 2
                 
                }
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
