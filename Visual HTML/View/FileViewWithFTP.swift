//
//  FileViewWithFTP.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/15.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class FileViewWithFTP:FileView{
    var manager:FTPManager!
    var parent: FTPViewController!
    var index:Int!
    init(index:Int, manager:FTPManager,frame:CGRect){
        super.init(name: manager.name, frame: frame)
        self.manager = manager
        self.index = index
        touchButton.addTarget(self, action:#selector(openFTPConfiguration), for: UIControlEvents.touchDown)
        touchButton.center = CGPoint(x:self.frame.width/2,y:self.frame.height/2)
    }
    
    @objc func openFTPConfiguration(){
    (self.parentController as! FTPViewController).parentController.FTPConfigurationView.isHidden = false
 (self.parentController as! FTPViewController).parentController.FTPConfigurationController.initiate(title:"save",index:self.index,manager: self.manager)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
