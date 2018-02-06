//
//  BlockView.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/6.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class BlockView:UIView,UITextFieldDelegate{
    var childs:[BlockView] = []
    var parent:BlockView!
    var wordTag:String = ""
    var properties = Dictionary<String,String>()
    var cumulatedHeight:Int = 0
    var cumulatedX:Int = 20
    var cumulatedY:Int = 20
    var blockMid:UIImageView = UIImageView()
    var blockBelow:UIButton = UIButton()
    var label:UILabel = UILabel()
    var textField = UITextField()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect,wordTag:String) {
        super.init(frame: frame)
        textField = UITextField(frame: CGRect(x:20,y:0,width:self.frame.width - 40,height:20))
        textField.placeholder = "Tag"
        textField.text = wordTag
        textField.isHidden = true
        textField.delegate = self
        
        
        label = UILabel(frame: CGRect(x:20,y:0,width:self.frame.width - 20,height:20))
        label.text = wordTag
        
        let blockAbove = UIButton()
        blockAbove.setImage(#imageLiteral(resourceName: "拼图上"), for: UIControlState())
        blockAbove.frame.size.width = self.bounds.size.width
        blockAbove.frame.size.height = 20
        blockAbove.frame.origin = CGPoint(x:0,y:0)
        blockAbove.addTarget(self, action: #selector(revealTextField)
        , for: UIControlEvents.touchDown)
        self.addSubview(blockAbove)
        blockMid = UIImageView()
        blockMid.image = #imageLiteral(resourceName: "拼图中")
        blockMid.frame.size.width = 20
        blockMid.frame.size.height = 30
        blockMid.frame.origin = CGPoint(x:0,y:10)
        self.addSubview(blockMid)
        cumulatedHeight = 30
        blockBelow = UIButton()
        blockBelow.setImage(#imageLiteral(resourceName: "拼图上"), for: UIControlState())
        blockBelow.frame.size.width = self.bounds.size.width
        blockBelow.frame.size.height = 20
        blockBelow.frame.origin = CGPoint(x:0,y:cumulatedHeight)
        self.addSubview(blockBelow)
        
        let addButton = UIButton()
        addButton.setImage(#imageLiteral(resourceName: "add"), for: UIControlState())
        addButton.frame.size.width = 20
        addButton.frame.size.height = 20
        addButton.frame.origin = CGPoint(x:0,y:0)
        self.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addBlock), for: UIControlEvents.touchDown)
        
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
    
    @objc func revealTextField(){
        textField.isHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.wordTag = textField.text!
        self.label.text = textField.text!
        self.textField.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
   
    
    @objc func addBlock(){
        let blockview = BlockView(frame: CGRect(x:cumulatedX,y:cumulatedY,width:200,height:200), wordTag: "")
        blockview.parent = self
        //cumulatedX += 20
        cumulatedY += 50
        blockMid.frame.size.height += 50
        blockBelow.center.y += 50
        self.frame.size.width += 20
        self.frame.size.height += 50
        var locationView:BlockView = self
        while (locationView.hasParent()){
            locationView.parent.blockMid.frame.size.height += 50
            locationView.parent.blockBelow.center.y += 50
            locationView.parent.cumulatedY += 50
            locationView.parent.frame.size.height += 50
            locationView.parent.frame.size.width += 20
            let index:Int =  locationView.parent.childs.index(of: locationView)!
            if index >= 0 && index < locationView.parent.childs.endIndex-1{
                for i in index+1...locationView.parent.childs.endIndex-1{
                    locationView.parent.childs[i].frame.origin.y += 50
                }
            }
            locationView = locationView.parent
        }
                self.addSubview(blockview)
        addChild(child: blockview)
    }
    
    @objc func removefromParent(){
        var locationView = self
        if self.hasParent(){
        while locationView.hasParent(){
            locationView.parent.blockMid.frame.size.height -= CGFloat(self.cumulatedY+30)
            locationView.parent.blockBelow.center.y -= CGFloat(self.cumulatedY+30)
            locationView.parent.cumulatedY -= (self.cumulatedY+30)
            let index:Int =  locationView.parent.childs.index(of: locationView)!
            
            if index >= 0 && index < locationView.parent.childs.endIndex-1{
                for i in index+1...locationView.parent.childs.endIndex-1{
                    locationView.parent.childs[i].frame.origin.y -= CGFloat(cumulatedY+30)
                }
            }
            locationView = locationView.parent
        }
         let index:Int =  self.parent.childs.index(of: self)!
         self.parent.childs.remove(at: index)
            self.removeFromSuperview()
            
        }
    }
    
    func addChild(child:BlockView){
        childs.append(child)
    }
    
    func addChildren(children:[BlockView]){
        childs.append(contentsOf: children)
    }
    
    func getChildren()->[BlockView]{
        return childs
    }
    
    func getChildsByClass(classname:String)->[BlockView]
    {
        var returnChilds:[BlockView] = []
        if childs.count > 0{
            for i in childs{
                if i.properties["class"] == classname{
                    returnChilds.append(i)
                }
            }
        }
        return returnChilds
    }
    
    func hasChildren()->Bool{
        if childs.count > 0{
            return true
        }else{
            return false
        }
    }
    
    func hasParent()->Bool{
        if parent != nil{
            return true
        }else{
            return false
        }
    }
    
    func getChildsById(id:String)->[BlockView]{
        var returnChilds:[BlockView] = []
        if childs.count > 0{
            for i in childs{
                if i.properties["id"] == id{
                    returnChilds.append(i)
                }
            }
        }
        return returnChilds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
