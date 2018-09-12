//
//  FTPManager.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/14.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import RebekkaTouch

class FTPManager:Codable{
    var name:String = ""
    var host:String = ""
    var username:String = ""
    var password:String = ""
    var session:Session!
    init(name:String,host:String,username:String,password:String) {
        self.host = host
        self.username = username
        self.password = password
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case host
        case username
        case password
        // or: case hobbies = "customHobbiesKey" if you want to encode to a different key
    }
    
    func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(host, forKey: .host)
            try container.encode(username, forKey: .username)
            try container.encode(password, forKey: .password)
        } catch {
            print(error)
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
       
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let host = try container.decode(String.self, forKey: .host)
        let username = try container.decode(String.self, forKey: .username)
        let password = try container.decode(String.self, forKey: .password)
        self.init(name: name, host: host, username: username, password: password)
    }
    
    func connectServer(){
        var configuration = SessionConfiguration()
        configuration.host = self.host
        configuration.username = self.username
        configuration.password = self.password
        session = Session(configuration: configuration)
    }
    
    func createDirectory(path: String) {
        session.createDirectory(path) {
            (result, error) -> Void in
            if result {
                print("文件夹创建成功!")
            }else {
                print("文件夹创建失败: \(error)")
            }
        }
    }
    
    func uploadFile(url:URL, path:String){
            self.session.upload(url, path: path) {
                (result, error) -> Void in
                print("Upload file with result:\n\(result), error: \(String(describing: error))\n\n")
                if result{
                    
                }
            }
    }
    
    func downloadFile(path:String, fileurl:URL) {
        self.session.download(fileurl, path, progressHandler:  { progress in
            DispatchQueue.main.async {
                print("progress", progress)
            }
        }) {
            (fileURL, error) -> Void in
            print("Download file with result:\n\(String(describing: fileURL)), error: \(String(describing: error))\n\n")
            
        }
    }
    
    func list(url:String)->[ResourceItem]{
        var resourcesArray:Array<ResourceItem> = []
        self.session.list(url) { [unowned self]
            (resources, error) -> Void in
            print("List directory with result:\n\(String(describing: resources)), error: \(String(describing: error))\n\n")
            resourcesArray = resources!
            print(resourcesArray)
        }
       
        return resourcesArray
    }
    
}
