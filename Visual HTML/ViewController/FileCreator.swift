//
//  FileCreator.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/3.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class FileCreator:UIViewController{
    @IBOutlet var text:UITextField!
    @IBOutlet var jsButton:UIButton!
    @IBOutlet var htmlButton:UIButton!
    @IBOutlet var cssButton:UIButton!
    @IBOutlet var phpButton:UIButton!
    @IBOutlet var folderButton: UIButton!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var importPictureButton: UIButton!
    @IBOutlet var exitButton: UIButton!
    var option:String = "html"
    var currentURL:String = ProjectUrl
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layer.cornerRadius = 10
        jsButton.layer.cornerRadius = 10
        htmlButton.layer.cornerRadius = 10
        cssButton.layer.cornerRadius = 10
        phpButton.layer.cornerRadius = 10
        folderButton.layer.cornerRadius = 10
        htmlButton.backgroundColor = UIColor.blue
        htmlButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        createButton.layer.cornerRadius = 10
        importPictureButton.layer.cornerRadius = 10
        createButton.frame.origin.x = self.view.frame.width/4
        createButton.frame.origin.y = self.view.frame.height - 100
        importPictureButton.frame.origin.x = self.view.frame.width/2*3
        importPictureButton.frame.origin.y = self.view.frame.height - 100
       // restore()
    }
    
    @IBAction func buttonChoiced(_ sender:UIButton){
       
        switch sender.title(for: UIControlState()){
        case "js"?:
          restore()
          jsButton.backgroundColor = UIColor.blue
          jsButton.setTitleColor(UIColor.white, for: UIControlState())
             option = sender.title(for: UIControlState())!
        case "html"?:
            restore()
            htmlButton.backgroundColor = UIColor.blue
        htmlButton.setTitleColor(UIColor.white, for: UIControlState())
             option = sender.title(for: UIControlState())!
        case "css"?:
            restore()
        cssButton.backgroundColor = UIColor.blue
        cssButton.setTitleColor(UIColor.white, for: UIControlState())
             option = sender.title(for: UIControlState())!
        case "php"?:
            restore()
        phpButton.backgroundColor = UIColor.blue
        phpButton.setTitleColor(UIColor.white, for: UIControlState())
             option = sender.title(for: UIControlState())!
        case "Folder"?:
            restore()
        folderButton.backgroundColor = UIColor.blue
        folderButton.setTitleColor(UIColor.white, for: UIControlState())
            option = "folder"
        case "Create"?:
            create()
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    func create(){
        if option != "folder"{
        let file:URL = URL(fileURLWithPath: ProjectUrl).appendingPathComponent(text.text! + "." + option)
        print(file.path)
        let exist = FileManager.default.fileExists(atPath: file.path)
        if !exist{
            let createSuccess = FileManager.default.createFile(atPath: file.path, contents: nil, attributes: nil)
            print("If Success\(createSuccess)")
           
           
            if createSuccess == true{
                let parentController = (self.parent as! ViewController).projectController
                parentController?.clearViews()
                parentController?.cumulatedHeight = 0
                print("projectName:\(ProjectName)")
                let view = FileView(name: ProjectName, frame: CGRect(x:0,y: (parentController?.cumulatedHeight)!,width:Int((parentController?.view.frame.width)!),height:30), Stanza: 0, Type: "project",url:ProjectUrl)
                view.parentController = parentController
                parentController?.cumulatedHeight += 30
                view.center.x =  (parentController?.stackView.frame.width)!/2
                parentController?.scrollView.addSubview(view)
                
                var parentNode:Node = Node(name: ProjectName, storage: nil)
                parentController?.dealNode(path: URL(fileURLWithPath:ProjectUrl).path, paths: try! FileManager.default.contentsOfDirectory(atPath: URL(fileURLWithPath:ProjectUrl).path), node: parentNode)
                  parentController?.load(node:parentNode,stanza:1)
               
            }
        }
        }else if (option == "folder")
        {
            try! FileManager.default.createDirectory(atPath: currentURL + text.text!, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func restore(){
        jsButton.backgroundColor = UIColor.white
        jsButton.setTitleColor(UIColor.blue, for: UIControlState())
        jsButton.layer.borderWidth = 2
        htmlButton.backgroundColor = UIColor.white
        htmlButton.setTitleColor(UIColor.blue, for: UIControlState())
        htmlButton.layer.borderWidth = 2
        cssButton.backgroundColor = UIColor.white
        cssButton.setTitleColor(UIColor.blue, for: UIControlState())
        cssButton.layer.borderWidth = 2
        phpButton.backgroundColor = UIColor.white
        phpButton.setTitleColor(UIColor.blue, for: UIControlState())
        phpButton.layer.borderWidth = 2
        folderButton.layer.borderWidth = 2
        folderButton.setTitleColor(UIColor.blue, for: UIControlState())
        folderButton.backgroundColor = UIColor.white
    }
    
}
