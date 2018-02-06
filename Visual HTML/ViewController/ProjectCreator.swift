//
//  ProjectCreator.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/2.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class ProjectCreator:UIViewController{
    @IBAction func createProject(){
        if text.text == ""{
            alert.isHidden = false
            alert.text = "Name can not be empty!"
            alert.textColor = UIColor.red
        }
        //TODO: normal expression
        createFile(name:text.text!)
    }
    
    func createFile(name:String)
    {
        let myDirectory:String = Constant.MY_DIRECTORY + name
        print(myDirectory)
        do{
            try! FileManager.default.createDirectory(atPath: myDirectory, withIntermediateDirectories: true, attributes: nil)
            print("Success")
        }
        catch let error as Error{
            print(error)
        }
    }
    
    @IBOutlet var text:UITextField!
    @IBOutlet var alert:UILabel!
    
}
