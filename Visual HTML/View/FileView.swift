//
//  FileView.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/3.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

//Stanza: [O,N)
class FileView:UIView{
    let STANZA_DISTANCE = 20
    var parentController: UIViewController!
    var name:String = ""
    var deleteButton:UIButton!
    var type:String = ""
    var url:String = ""
    var touchButton:UIButton!
    var nameLabel:UILabel!
    var isSelected:Bool = false
    var upLoadButton:UIButton!
    var downLoadButton:UIButton!
    
    init(name:String,frame:CGRect){
        super.init(frame: frame)
        self.name = name
        self.frame = frame
        deleteButton = UIButton()
        deleteButton.frame.size.width = 20
        deleteButton.frame.size.height = 20
        self.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 20, y: 0, width: self.frame.width, height: 20)
        nameLabel.font = UIFont(name: "SF Mono Regular", size: 15)
        nameLabel.text = name
        nameLabel.textColor = UIColor.black
        touchButton = UIButton()
        touchButton.frame.size = self.frame.size
        touchButton.backgroundColor = UIColor.clear
        
        touchButton.center = CGPoint(x:self.frame.width/2,y:self.frame.height/2)
        self.addSubview(touchButton)
        self.addSubview(nameLabel)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(setting))
        swipeLeftGesture.direction = .left
        self.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(restoreSetting))
        swipeRightGesture.direction = .right
        self.addGestureRecognizer(swipeRightGesture)
    }
    
    init(name:String,frame:CGRect,Stanza:Int,Type:String,url:String) {
        print(name)
        super.init(frame:frame)
        self.name = name
        self.type = Type
        self.url = url
        deleteButton = UIButton()
        deleteButton.frame.size.width = 20
        deleteButton.frame.size.height = 20
        
        nameLabel = UILabel()
        nameLabel.frame = CGRect(x: CGFloat(Stanza) * 20, y: 0, width: self.frame.width, height: 20)
        nameLabel.font = UIFont(name: "SF Mono Regular", size: 15)
        nameLabel.text = name
        nameLabel.textColor = UIColor.black
       
        touchButton = UIButton()
        touchButton.frame.size = self.frame.size
        touchButton.backgroundColor = UIColor.clear
        touchButton.addTarget(self, action: #selector(changeColor), for: UIControlEvents.touchDown)
        touchButton.center = CGPoint(x:self.frame.width/2,y:self.frame.height/2)
        self.addSubview(touchButton)
        self.addSubview(nameLabel)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(setting))
        swipeLeftGesture.direction = .left
        self.addGestureRecognizer(swipeLeftGesture)
       
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(restoreSetting))
        swipeRightGesture.direction = .right
        self.addGestureRecognizer(swipeRightGesture)
        //self.backgroundColor = UIColor.blue
    }
    
    @objc func setting(){
        deleteButton.setImage(#imageLiteral(resourceName: "delete"), for: UIControlState())
        deleteButton.frame.origin.x = self.bounds.width
        deleteButton.frame.origin.y = 10
        deleteButton.center.y = 15
        deleteButton.addTarget(self, action: #selector(deleteFile), for: UIControlEvents.touchDown)
        deleteButton.clipsToBounds = true
        self.addSubview(deleteButton)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        deleteButton.center.x = self.bounds.width-20
        UIView.commitAnimations()
        
    }
    
    @objc func uploadSetting(){
        upLoadButton = UIButton()
        upLoadButton.frame.size.width = 20
        upLoadButton.frame.size.height = 20
        upLoadButton.setImage(#imageLiteral(resourceName: "upload"), for: UIControlState())
        upLoadButton.frame.origin.x = self.bounds.width
        upLoadButton.frame.origin.y = 10
        upLoadButton.center.y = 15
        upLoadButton.clipsToBounds = true
        upLoadButton.addTarget(self, action: #selector(uploadFile), for: .touchDown)
        self.addSubview(upLoadButton)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        upLoadButton.center.x = self.bounds.width-50
        UIView.commitAnimations()
    }
    
    @objc func uploadFile(){
        print("start to upload File")
        let fileViewer = (parentController as! StackFileViewer)
        
        if  fileViewer.parentController.FTPViewerController.url != ""{
 fileViewer.parentController.FTPViewerController.manager?.uploadFile(url: URL(fileURLWithPath:url), path: fileViewer.parentController.FTPViewerController.url + "/" + name)
        print("from\(url)")
        print("to:\(fileViewer.parentController.FTPViewerController.url)")
        fileViewer.parentController.FTPViewerController.loadFTPuploadView(url: fileViewer.parentController.FTPViewerController.url)
        }else{
        fileViewer.parentController.FTPView.isHidden = false
        }
    }
    
    
    @objc func downloadSetting(){
        downLoadButton = UIButton()
        downLoadButton.frame.size.width = 20
        downLoadButton.frame.size.height = 20
        downLoadButton.setImage(#imageLiteral(resourceName: "download"), for: UIControlState())
        downLoadButton.frame.origin.x = self.bounds.width
        downLoadButton.frame.origin.y = 10
        downLoadButton.center.y = 15
        downLoadButton.clipsToBounds = true
        downLoadButton.addTarget(self, action: #selector(downloadFile), for: .touchDown)
        self.addSubview(downLoadButton)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        downLoadButton.center.x = self.bounds.width-80
        UIView.commitAnimations()
    }
    
    @objc func downloadFile(){
        
        if (parentController as! FTPViewController).url != "" && (parentController as! FTPViewController).url != nil{
            (parentController as! FTPViewController).manager?.downloadFile(path: (parentController as! FTPViewController).url + "/" +  (parentController as! FTPViewController).name,fileurl:URL(fileURLWithPath:(parentController as! FTPViewController).parentController.projectController.fileSelected + name))
        }
    }
    
    @objc func restoreSetting(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        deleteButton.frame.origin.x = self.bounds.width
        if upLoadButton != nil{
        upLoadButton.frame.origin.x = self.bounds.width
        }
        if downLoadButton != nil{
        downLoadButton.frame.origin.x = self.bounds.width
        }
        UIView.commitAnimations()
    }
    
    
    
    @objc func deleteFile(){
        let manager = FileManager.default
        try! manager.removeItem(atPath: url)
        self.removeFromSuperview()
    }
    
    @objc func changeColor(){
    (parentController as! StackFileViewer).fileSelected = self.url
    (parentController as! StackFileViewer).restore()
    self.backgroundColor = UIColor.blue
    }
    
    @objc func selectFile(){
        isSelected = true
        (parentController as! FTPViewController).restore()
        self.backgroundColor = UIColor.blue
    }
    
    @objc func enterNextLevel(){
        let url:String = self.url + "/"
        (parentController as! FTPViewController).clear()
        (parentController as! FTPViewController).loadFTPuploadView(url: url)
    }
    
    @objc func goBackTotheLastLevel(){
        
    }
    
    @objc func openfile(){
       
        if type != "folder"{
        (parentController as! StackFileViewer).parentController.fileSelected = name
        //load data
        var data:NSString! = ""
        do{
            data = try NSString(contentsOf: NSURL(fileURLWithPath: url) as URL, encoding: String.Encoding.utf8.rawValue)
            print(data)
            if name.contains(".html"){
            (parentController as! StackFileViewer).parentController.editorController.load(url:url,filename:name)
            }else if name.contains(".js"){
                 (parentController as! StackFileViewer).parentController.editorController.loadJs(url:url,filename:name)
            }
       (parentController as! StackFileViewer).parentController.editorController.nameLabel.text = name
            let node:Node = HtmlParser.htmlToBlock(code: data as! String)
            node.name = name
                (parentController as! StackFileViewer).parentController.visualController.clear()
            let block = (parentController as! StackFileViewer).parentController.visualController.loadBlocks(parentNode: node)
            let width = block.frame.width
            let height = block.frame.height
            
            (parentController as! StackFileViewer).parentController.visualController.view.addSubview(block)
            
            (parentController as! StackFileViewer).parentController.load()
        }catch let error as NSError{
            print(error)
        }
        }else
        {
            (parentController as! StackFileViewer).parentController.fileCreatorController.currentURL =  url
            
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

