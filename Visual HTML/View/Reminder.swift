//
//  Reminder.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/5.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class Reminder:UIView,UIScrollViewDelegate{
    var remindedWords:[String]!
    var cumulatedHeight:Int = 0
    var parentController: Editor!
    var scrollView:UIScrollView = UIScrollView()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame:CGRect, remindedWords:[String]) {
        super.init(frame: frame)
        self.remindedWords = remindedWords
       // self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 15
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.center = CGPoint(x:50,y:50)
        scrollView.alwaysBounceVertical = true
        scrollView.layer.cornerRadius = 15
        scrollView.backgroundColor = UIColor.white
        scrollView.isScrollEnabled = true
        scrollView.clipsToBounds = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.delegate = self.parentController
        self.addSubview(scrollView)
        addWords()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addWords(){
        for item in remindedWords{
            let wordsView:WordsView = WordsView(name: item, frame: CGRect(x: 0, y: cumulatedHeight, width: Int(self.frame.width), height: 20))
            cumulatedHeight += 20
            self.scrollView.addSubview(wordsView)
            scrollView.contentSize = CGSize(width:self.bounds.width,height:CGFloat(cumulatedHeight))
           // self.scrollView.frame.size.height += 20
        }
    }
    
    func clear(){
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
}
