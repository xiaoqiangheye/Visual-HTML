//
//  PropertiesController.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/6.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class PropertiesController:UIViewController{
    var cumulatedHeight:CGFloat = 0
    var targetBlock:BlockView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func changeValue(key:String, value:Any, properties:Dictionary<String,Any>)->Dictionary<String,Any>{
        var dic = properties
        dic[key] = value
        return dic
    }
    
    func loadProperties(properties:Dictionary<String, Any>){
        for (key,value) in properties{
            let subview = PropertiesView(frame: CGRect(x:0,y:cumulatedHeight,width:self.view.frame.width,height:20), key: key, value: value)
            cumulatedHeight += subview.frame.height
            self.view.addSubview(subview)
        }
    }
    
}
