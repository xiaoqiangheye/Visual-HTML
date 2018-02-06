//
//  Tree.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/3.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation


class Node{
    var childNode:[Node] = [Node]()
    var storage:Any?
    var name:String
    var parentNode:Node? = nil
    init(name:String,storage:Any?) {
        self.name = name
        self.storage = storage
    }
    
    func getChildNode() -> [Node]{
        return childNode
    }
    func addChildNode(child:Node){
        childNode.append(child)
        child.parentNode = self
    }
    func addChildNode(children:[Node]){
        childNode.append(contentsOf: children)
        for child in children
        {
            child.parentNode = self
        }
    }
    
    func getParentNode() -> Node{
        return parentNode!
    }
    func hasChild() -> Bool{
        if (self.childNode.count == 0){
            return false
        }else if(self.childNode.count > 0)
        {
            return true
        }else{
            return false
        }
    }
}
