//
//  PropertiesView.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/7.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class PropertiesView:UIView,UITextViewDelegate{
    var key:String = ""
    var value:Any!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(frame: CGRect,key:String,value:Any){
        super.init(frame: frame)
        self.key = key
        self.value = value
        let keyTextView = UITextView()
        keyTextView.frame.size.width = self.frame.width/3
        keyTextView.frame.size.height = 20
        keyTextView.center.x = self.frame.width/4
        keyTextView.frame.origin.y = 0
        keyTextView.text = key
        
        let valueTextView = UITextView()
        valueTextView.frame.size.width = self.frame.width/3
        valueTextView.frame.size.height = 20
        valueTextView.center.x = self.frame.width/4*3
        valueTextView.frame.origin.y = 0
        valueTextView.text = value as! String
        self.addSubview(keyTextView)
        self.addSubview(valueTextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
