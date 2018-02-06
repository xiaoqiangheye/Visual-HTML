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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       load()
    }
    func load(){
        do{
            contentsOfPath = try! FileManager.default.contentsOfDirectory(atPath: Constant.MY_DIRECTORY)
            //load view
            if contentsOfPath.count > 0{
                let count:Int = Int(Constant.ScreenX/(100+20))
                var index:Int = 0
                for name in contentsOfPath{
                    let line = index/count
                    let row = (index+1) % count
                    print("index\(index)")
                    print("count\(count)")
                    print("row\(row)")
                    let originX = CGFloat(Constant.ScreenX/CGFloat(count)*CGFloat(row))
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
    
    @objc func presentCoding(){
        self.performSegue(withIdentifier: "presentCoding", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createProject(){
        projectCreate.isHidden = false
    }
}
