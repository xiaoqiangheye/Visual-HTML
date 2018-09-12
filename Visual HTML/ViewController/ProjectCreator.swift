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
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let exitButton:UIButton = UIButton()
        exitButton.setTitle("X", for: UIControlState())
        exitButton.bounds.size.width = 20
        exitButton.bounds.size.height = 20
        exitButton.center = CGPoint(x:self.view.frame.width - 20,y:20)
        exitButton.addTarget(self, action: #selector(exit), for: .touchDown)
        self.view.addSubview(exitButton)
    }
    
    @objc func exit(){
    let parentController = parent as! ProjectsViewController
    parentController.exit()
    }
    
    @IBAction func createProject(){
        if text.text == ""{
            alert.isHidden = false
            alert.text = "Name can not be empty!"
            alert.textColor = UIColor.red
        }else{
        //TODO: normal expression
        createFile(name:text.text!)
        }
    }
    
    func createFile(name:String)
    {
        let myDirectory:String = Constant.MY_DIRECTORY + name
        print(myDirectory)
        do{
           try FileManager.default.createDirectory(atPath: myDirectory, withIntermediateDirectories: true, attributes: nil)
            let parentController = parent as! ProjectsViewController
            parentController.clear()
            parentController.load()
            exit()
        }
        catch{
            print(error)
        }
    }
    
    @IBOutlet var text:UITextField!
    @IBOutlet var alert:UILabel!
    
}
