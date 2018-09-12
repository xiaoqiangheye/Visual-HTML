//
//  BlockViewWithNoEndTag.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/12.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class BlockViewWithNoEndTag:BlockView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(frame: CGRect,wordTag:String) {
        super.init(frame: frame)
        self.wordTag = wordTag
        cumulatedY = -10
        cumulatedX = 20
        textField = UITextField(frame: CGRect(x:20,y:0,width:self.frame.width - 40,height:20))
        textField.placeholder = "Tag"
        textField.text = wordTag
        textField.isHidden = true
        textField.delegate = self
        label = UILabel(frame: CGRect(x:20,y:0,width:self.frame.width - 20,height:20))
        label.text = wordTag
        
        let blockAbove = UIButton()
        blockAbove.setImage(#imageLiteral(resourceName: "blockWithNoEndTag"), for: UIControlState())
        blockAbove.frame.size.width = self.bounds.size.width
        blockAbove.frame.size.height = 20
        blockAbove.frame.origin = CGPoint(x:0,y:0)
        blockAbove.addTarget(self, action: #selector(revealTextField)
            , for: UIControlEvents.touchDown)
        self.addSubview(blockAbove)
        
        let deleteButton = UIButton()
        deleteButton.setImage(#imageLiteral(resourceName: "delete"), for: UIControlState())
        deleteButton.frame.size.width = 20
        deleteButton.frame.size.height = 20
        deleteButton.frame.origin = CGPoint(x:self.bounds.size.width-30,y:0)
        self.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(removefromParent), for: UIControlEvents.touchDown)
        self.addSubview(deleteButton)
        self.addSubview(label)
        self.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
