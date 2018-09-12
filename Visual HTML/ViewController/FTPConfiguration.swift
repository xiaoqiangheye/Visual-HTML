//
//  FTPConfiguration.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/16.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class FTPConfiguration:UIViewController{
    var parentController:ViewController!
    @IBOutlet var name:UITextField!
    @IBOutlet var host:UITextField!
    @IBOutlet var username:UITextField!
    @IBOutlet var password:UITextField!
    var index:Int = 0
    @IBOutlet var configurationButton: UIButton!
    
    func initiate(title:String,index:Int, manager:FTPManager?){
        
        
        configurationButton.setTitle(title, for: UIControlState())
        
        switch title {
        case "save":
            configurationButton.addTarget(self, action: #selector(save), for: UIControlEvents.touchDown)
            self.index = index
            name.text = manager?.name
            host.text = manager?.host
            username.text = manager?.username
            password.text = manager?.password
        case "add":
            configurationButton.addTarget(self, action: #selector(add), for: UIControlEvents.touchDown)
        default:
            configurationButton.addTarget(self, action: #selector(save), for: UIControlEvents.touchDown)
        }
    }
    
    @objc func save(_ sender:UIButton){
        if let dataRead = try? Data(contentsOf: URL(fileURLWithPath:Constant.FTP.FTP_STORAGE_URL)) {
            var array = try? JSONDecoder().decode([FTPManager].self,from:dataRead)
            array![index].name = name.text!
            array![index].username = username.text!
            array![index].password = password.text!
            array![index].host = host.text!
            
            let dataWrite = try? JSONEncoder().encode(array)
            do {
                try? dataWrite?.write(to:URL(fileURLWithPath:Constant.FTP.FTP_STORAGE_URL))
            } catch{
                print("保存到本地文件失败")
            }
            
            self.view.isHidden = true
        } else {
            print("文件不存在，读取本地")
            
        }
        self.view.isHidden = true
    }
    
    @objc func add(){
        if let dataRead = try? Data(contentsOf: URL(fileURLWithPath:Constant.FTP.FTP_STORAGE_URL)) {
            var array = try? JSONDecoder().decode([FTPManager].self,from:dataRead)
            let ftp:FTPManager = FTPManager(name: name.text!, host: host.text!, username: username.text!, password: password.text!)
            array?.append(ftp)
            let dataWrite = try? JSONEncoder().encode(array)
            do {
                try? dataWrite?.write(to:URL(fileURLWithPath:Constant.FTP.FTP_STORAGE_URL))
            } catch{
                print("保存到本地文件失败")
            }
            self.view.isHidden = true
        } else {
            print("文件不存在，读取本地文件失败")
        }
        
       
        
    }
    
}
