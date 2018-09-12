//
//  AlertView.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/3/15.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class AlertView:UIView{
    var title:String = ""
    var button1Title:String = ""
    var button2Title:String = ""
    var button1:UIButton!
    var button2:UIButton!
    
    init(button1:String,button2:String,title:String,content:String){
        let frame = CGRect(x: 0, y: 0, width: 400, height: 200)
        super.init(frame:frame)
        self.layer.cornerRadius = 10
       // self.layer.borderWidth = 1
       // self.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        self.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        self.button1Title = button1
        self.button2Title = button2
        self.title = title
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.black
        titleLabel.center = CGPoint(x:self.frame.width/2,y:50)
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.adjustsFontForContentSizeCategory = true
        
        self.addSubview(titleLabel)
        
        self.button1 = UIButton()
        self.button1.setTitle(self.button1Title, for: UIControlState())
        self.button1.setTitleColor(UIColor.white, for: UIControlState())
        self.button1.frame.size = CGSize(width:50,height:25)
        self.button1.center = CGPoint(x:self.frame.width/4,y:150)
        self.button1.titleLabel?.adjustsFontForContentSizeCategory = true
        self.button1.backgroundColor = UIColor.blue
        self.button1.layer.cornerRadius = 10
        self.addSubview(self.button1)
        
        self.button2 = UIButton()
        self.button2.setTitle(self.button2Title, for: UIControlState())
        self.button2.setTitleColor(UIColor.white, for: UIControlState())
        self.button2.titleLabel?.adjustsFontForContentSizeCategory = true
        self.button2.frame.size = CGSize(width:50,height:25)
         self.button2.center = CGPoint(x:self.frame.width/4*3,y:150)
        self.button2.backgroundColor = UIColor.blue
        self.button2.layer.cornerRadius = 10
        self.addSubview(self.button2)
        self.addSubview(self.button2)
        
        let contentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        contentLabel.font = UIFont.systemFont(ofSize: 18)
        contentLabel.textColor = UIColor.black
        contentLabel.center = CGPoint(x:self.frame.width/2,y:self.frame.height/2)
        contentLabel.textAlignment = .center
        contentLabel.text = content
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.adjustsFontForContentSizeCategory = true
        self.addSubview(contentLabel)
        
    }
    
    func success(){
        
    }
    
    func fail(){
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
