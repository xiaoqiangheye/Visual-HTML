//
//  WordsView.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/5.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation

import UIKit
class WordsView:UIView{
    var word:String!
init(name:String,frame:CGRect) {
    super.init(frame:frame)
    self.word = name
    self.backgroundColor = UIColor.white
    let label:UILabel = UILabel()
    label.frame = CGRect(x: 20, y: 0, width: self.frame.width, height: 20)
    label.font = UIFont(name: "System", size:20)
    label.text = name
    label.textColor = UIColor.black
    
    let button:UIButton = UIButton()
    button.frame.size = self.frame.size
    button.backgroundColor = UIColor.clear
    button.addTarget(self, action:#selector(addWordToEditor), for: UIControlEvents.touchDown)
    
    button.center = CGPoint(x:self.frame.width/2,y:self.frame.height/2)
    self.addSubview(button)
    self.addSubview(label)
    self.clipsToBounds = true
    //self.layer.cornerRadius = 5
    
    
    //self.backgroundColor = UIColor.blue
}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addWordToEditor(){
        let reminderView = self.superview?.superview as! Reminder
        reminderView.parentController.addWord(name:self.word)
        reminderView.parentController.scripts.isSelectable = true
    }
}
