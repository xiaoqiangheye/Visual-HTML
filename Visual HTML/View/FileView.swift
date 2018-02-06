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
    var parentController:StackFileViewer!
    var name:String = ""
    init(name:String,frame:CGRect,Stanza:Int,Type:String) {
        print(name)
        super.init(frame:frame)
        self.name = name
        let label:UILabel = UILabel()
        label.frame = CGRect(x: CGFloat(Stanza) * 20, y: 0, width: self.frame.width, height: 20)
        label.font = UIFont(name: "System", size:20)
        label.text = name
        label.textColor = UIColor.black
       
       
        
        let button:UIButton = UIButton()
        button.frame.size = self.frame.size
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action:#selector(openfile), for: UIControlEvents.touchDown)
      
        button.center = CGPoint(x:self.frame.width/2,y:self.frame.height/2)
        self.addSubview(button)
        self.addSubview(label)
       
        
        //self.backgroundColor = UIColor.blue
    }
    
    @objc func openfile(){
        parentController.restore()
        parentController.parentController.fileSelected = name
        self.backgroundColor = UIColor.blue
        //load data
        var data:NSString! = ""
        do{
            data = try NSString(contentsOf: NSURL(fileURLWithPath: ProjectUrl + name) as URL, encoding: String.Encoding.utf8.rawValue)
            print(data)
            parentController.parentController.editorController.load(fileName:name)
            parentController.parentController.load()
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

