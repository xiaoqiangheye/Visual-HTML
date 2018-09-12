//
//  ProjectCellView.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/2.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class ProjectCellView:UIView{
    var name:String! = "Untitled"
    var parentController: ProjectsViewController!
    init(frame:CGRect,name:String){
        super.init(frame:frame)
        self.name = name
        let pic = UIButton()
        pic.setImage(#imageLiteral(resourceName: "projectIcon"), for: UIControlState())
        pic.frame.size = CGSize(width:100,height:100)
        pic.center.x = 50
        pic.center.y = 50
        pic.addTarget(parentController, action: #selector(parentController.presentCoding), for: UIControlEvents.touchDown)
        
        print(ProjectName)
        print(ProjectUrl)
        self.addSubview(pic)
        let lable = UILabel()
        lable.text = name
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.frame = CGRect(x: 50, y: 125, width: 100, height: 50)
        lable.center = CGPoint(x:50,y:125)
        lable.textColor = UIColor.black
        lable.textAlignment = .center
        self.addSubview(lable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

