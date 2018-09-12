//
//  FTPViewController.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/15.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit
import RebekkaTouch

class FTPViewController:UIViewController,UIScrollViewDelegate{
    var parentController:ViewController!
    var manager:FTPManager?
    var url:String = ""
    var lasturl:String = ""
    var scrollView: UIScrollView = UIScrollView()
    var name:String = ""
    override func viewWillAppear(_ animated: Bool) {
        scrollView.delegate = self
        scrollView.frame = CGRect(x:0,y:40,width:self.view.frame.width,height:self.view.frame.height-40)
       // scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.clipsToBounds = true
        self.view.addSubview(scrollView)
        loadFTP()
    }
    func addFTP(name:String,host:String, username:String, password:String){
        let ftp:FTPManager = FTPManager(name:name, host: host, username: username, password: password)
        var array:Array<FTPManager> = UserDefaults.standard.array(forKey: Constant.FTP.FTP_STORAGE_KEY) as! Array<FTPManager>
        array.append(ftp)
        UserDefaults.standard.set(array, forKey: Constant.FTP.FTP_STORAGE_KEY)
    }
    
    func loadFTP(){
        if let dataRead = try? Data(contentsOf:URL(fileURLWithPath:Constant.FTP.FTP_STORAGE_URL)) {
            //将数据转换为Person实例
            var array = try? JSONDecoder().decode([FTPManager].self, from: dataRead)
            print("FTPARRAY\(array)")
            var cumulatedHeight:Int = 0
            var index = 0
            for item in array!{
                let ftpCell = FileViewWithFTP(index:index,manager: item, frame: CGRect(x:0,y:cumulatedHeight,width:Int(self.view.frame.width),height:30))
                ftpCell.touchButton.addTarget(self, action: #selector(selectFTPfile), for: UIControlEvents.touchDown)
               
                cumulatedHeight += 30
                ftpCell.parentController = self
                self.scrollView.addSubview(ftpCell)
                self.scrollView.contentSize = CGSize(width:self.view.frame.width,height:CGFloat(cumulatedHeight))
                index += 1
            }
           
        } else {
            print("文件不存在，读取本地文件失败")
        }
        
    }
    
    func loadFTPuploadView(manager:FTPManager,url:String){
        clear()
        self.manager = manager
        manager.connectServer()
        var cumulatedHeights = 30
        let arrayList = manager.list(url:url)
        let fileview:FileView = FileView(name: "...", frame: CGRect(x:0,y:cumulatedHeights,width:Int(self.view.frame.width),height:30))
        fileview.touchButton.addTarget(self, action: #selector(goBackToLastLevel), for: UIControlEvents.touchDown)
        self.scrollView.addSubview(fileview)
        for item in arrayList{
            let fileview:FileView = FileView(name: item.name, frame: CGRect(x:0,y:cumulatedHeights,width:Int(self.view.frame.width),height:30))
            fileview.type = item.type.rawValue
            fileview.parentController = self
            fileview.url = item.path
            switch item.type.rawValue{
            case "Directory":
                fileview.touchButton.addTarget(self, action: #selector(selectFile), for: UIControlEvents.touchDown)
                fileview.touchButton.addTarget(self, action: #selector(fileview.enterNextLevel), for: UIControlEvents.touchDown)
                break
            case "RegularFile":
                fileview.touchButton.addTarget(self, action: #selector(selectFile), for: UIControlEvents.touchDown)
                break
            default:
                fileview.touchButton.addTarget(self, action: #selector(selectFile), for: UIControlEvents.touchDown)
            }
            self.scrollView.addSubview(fileview)
            cumulatedHeights += 30
        }
        self.scrollView.contentSize = CGSize(width:self.view.frame.width,height:CGFloat(cumulatedHeights))
    }
    
    func loadFTPuploadView(url:String){
        self.manager?.connectServer()
         print("connectServer")
            manager?.session.list(url) { [unowned self]
            (resources, error) -> Void in
            print("List directory with result:\n\(String(describing: resources)), error: \(String(describing: error))\n\n")
            self.clear()
           var cumulatedHeights = 30
            let fileview:FileView = FileView(name: "...", frame: CGRect(x:0,y:0,width:Int(self.view.frame.width),height:30))
            fileview.touchButton.addTarget(self, action: #selector(self.goBackToLastLevel), for: UIControlEvents.touchDown)
            self.scrollView.addSubview(fileview)
                if resources != nil{
            for item in resources!{
            print("name:" + item.name)
            let fileview:FileView = FileView(name: item.name, frame: CGRect(x:0,y:cumulatedHeights,width:Int(self.view.frame.width),height:30))
            fileview.type = item.type.rawValue
            fileview.parentController = self
            fileview.url = item.path
            fileview.touchButton.addTarget(self, action: #selector(self.selectFile), for: UIControlEvents.touchDown)
                let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.downloadSetting))
                leftGesture.direction = .left
            fileview.addGestureRecognizer(leftGesture)
            switch item.type.rawValue{
            case "Directory":
                fileview.touchButton.addTarget(self, action: #selector(self.enterNextLevel), for: UIControlEvents.touchDown)
                break
            case "RegularFile":
                break
            default:
                break
            }
            
            self.scrollView.addSubview(fileview)
            cumulatedHeights += 30
            }
                }
                self.scrollView.contentSize = CGSize(width:self.view.frame.width,height:CGFloat(cumulatedHeights))
        }
        
    }
    
    @objc func downloadSetting(_ sender: UISwipeGestureRecognizer){
         let view = (sender.view as! FileView)
         view.downloadSetting()
         view.setting()
    }
    
    @objc func downloadRestore(_ sender: UISwipeGestureRecognizer)
    {
        let view = (sender.view as! FileView)
        view.restoreSetting()
    }
    
    @objc func selectFTPfile(_ sender:UIButton){
        (sender.superview as! FileView).selectFile()
        manager = (sender.superview as! FileViewWithFTP).manager
        loadFTPuploadView(url: "/")
        url = "/"
    }
    
    @objc func selectFile(_ sender:UIButton){
        (sender.superview as! FileView).selectFile()
        self.name = (sender.superview as! FileView).name
    }
    
    @objc func enterNextLevel(_ sender:UIButton){
     lasturl = url
    (sender.superview as! FileView).enterNextLevel()
     url = (sender.superview as! FileView).url
    }
    
    @objc func goBackToLastLevel(_sender:UIButton){
        clear()
        print(url)
        var index = url.count-1
        var countOfincline:Int = 0
        for c in url{
            if url[url.index(url.startIndex, offsetBy: index)] == "/"
            {
                countOfincline += 1
                if countOfincline <= 1{
                    for i in index...url.count-1{
                    url.remove(at: url.index(before: url.endIndex))
                    }
                }
               break
            }
            
            
            index-=1
        }
        print(url)
        loadFTPuploadView(url: url + "/")
      
    }
    
   
    
    @IBAction func addFTP(){
    self.parentController.FTPConfigurationView.isHidden = false
    self.parentController.FTPConfigurationController.initiate(title: "add", index: 0, manager: nil)
    }
    
    func clear(){
        for view in self.scrollView.subviews{
            view.removeFromSuperview()
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
