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
    var option:String = "html"
    
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
        htmlButton.backgroundColor = UIColor.blue
        htmlButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        restore()
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
        case "Create"?:
            create()
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    func create(){
        let file:URL = URL(fileURLWithPath: ProjectUrl).appendingPathComponent(text.text! + "." + option)
        print(file)
        let exist = FileManager.default.fileExists(atPath: file.path)
        if !exist{
            let createSuccess = FileManager.default.createFile(atPath: file.path, contents: nil, attributes: nil)
            print("If Success\(createSuccess)")
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
    }
    
}
