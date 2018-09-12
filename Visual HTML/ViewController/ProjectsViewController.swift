//
//  ProjectsViewController.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/2.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class ProjectsViewController:UIViewController{
    
   
    @IBOutlet var projectCreate: UIView!
    @IBOutlet var scrollView: UIScrollView!
     var contentsOfPath: [String]!
     @IBOutlet var containerView:UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.frame.size.width = 200
        containerView.frame.size.height = 500
        containerView.center = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        projectCreate.center = self.view.center
       load()
    }
    func load(){
        do{
            contentsOfPath = try! FileManager.default.contentsOfDirectory(atPath: Constant.MY_DIRECTORY)
            //load view
            if contentsOfPath.count > 0{
                let count:Int = Int((Constant.ScreenX-100)/(100+20))
                var index:Int = 0
                for name in contentsOfPath{
                    let line = index/count
                    let row = (index) % (count) + 1
                    print("index\(index)")
                    print("count\(count)")
                    print("row\(row)")
                    let originX = CGFloat(row * 120)
                    print("x\(originX)")
                    let originY:CGFloat = CGFloat(95 + line * 170)
                    let cellView:ProjectCellView = ProjectCellView(frame:  CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width:100,height:150)), name: name)
                    cellView.center = CGPoint(x: originX, y: originY)
                    cellView.parentController = self
                    index += 1
                    scrollView.addSubview(cellView)
                }
            }
        }catch let error as Error{
            print(error)
        }
    }
    
    @objc func presentCoding(_ sender:
        UIButton){
        self.performSegue(withIdentifier: "presentCoding", sender: self)
        ProjectName = (sender.superview as! ProjectCellView).name
        ProjectUrl = Constant.MY_DIRECTORY + ProjectName + "/"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func clear(){
        for view in self.scrollView.subviews{
            view.removeFromSuperview()
        }
    }
    
    @objc func exit(){
        projectCreate.isHidden = true
    }
    
    @IBAction func createProject(){
        projectCreate.isHidden = false
    }
}
