//
//  Function.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/3/7.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation


class JSFunction{
    private var variables:[String]
    private var constants:[String]
    
    init(_ variables:[String], _ constants:[String]) {
        self.variables = variables
        self.constants = constants
    }
    
    init() {
        self.variables = []
        self.constants = []
    }
    
    func addVariavles(_ variable:String){
        variables.append(variable)
    }
    
    func addConstants(_ const: String){
        constants.append(const)
    }
    
    func updateVariables(_ variables: [String]){
        self.variables = variables
    }
    
    func updateConstants(_ constants: [String]){
         self.constants = constants
    }
    
}
