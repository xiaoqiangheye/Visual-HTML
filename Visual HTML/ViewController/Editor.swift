//
//  Editor.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/2.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit
var sp = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
class Editor:UIViewController,UITextViewDelegate{
    @IBOutlet var scripts: UITextView!
    var name:String!
    var updatedRecorder:String = ""
    var ifWordsRemindOn:Bool = false
    var attributedString:NSMutableAttributedString!
    var lastlocation:Int!
    var remindView:Reminder!
    override func viewDidLoad() {
        super.viewDidLoad()
        remindView = Reminder(frame: CGRect(x: self.view.center.x, y:self.view.center.y, width:100, height: 100), remindedWords: [""])
        remindView.parentController = self
        scripts.delegate = self
        self.scripts.typingAttributes[NSAttributedStringKey.font.rawValue] = UIFont.systemFont(ofSize: 14)
        self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1)
        attributedString = NSMutableAttributedString(string: scripts.text)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1), range:NSRange.init(location:0, length: scripts.text.count))
        scripts.attributedText = attributedString
            }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print("did change selection\(textView.selectedTextRange)")
       print (textView.selectedRange)
       
    }
    
    

    func textViewDidChange(_ textView: UITextView) {
        remindView.clear()
        remindView.removeFromSuperview()
        let attributedString = NSMutableAttributedString(attributedString: scripts.attributedText)
        let currentlocation = textView.selectedRange.location
        updatedRecorder = ""
       // scripts.attributedText = attributedString
        
        if sp.count > 0{
            let url = NSURL(fileURLWithPath: "\(sp[0])/test.html")
           
            let data = NSMutableData()
            if name != nil{
            data.append(NSData(data:scripts.text.data(using: String.Encoding.utf8)!) as Data)
                data.write(toFile: ProjectUrl + name, atomically: true)}
           // print("char\(textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-1)])")
            if textView.selectedRange.location >= 2{
                if textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-2)] == "<"{
                    ifWordsRemindOn = false
                    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.red, range:NSRange.init(location:textView.selectedRange.location-1, length: 1))
                    self.scripts.attributedText = attributedString
                    self.scripts.selectedRange.location = currentlocation
                    self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor.red
                }
            }
            if textView.selectedRange.location != 0{
            if textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-1)] == ">"{
                ifWordsRemindOn = false
                updatedRecorder = ""
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1), range:NSRange.init(location:textView.selectedRange.location-1, length: 1))
                self.scripts.attributedText = attributedString
                self.scripts.selectedRange.location = currentlocation
                self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1)
            }
            }
            var ifHasLeftBound = false
            var ifHasBounds = false
            var index:Int = 2
            var remindedWords:[String] = []
            while(ifHasBounds == false && textView.selectedRange.location-index > 1){
                if textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-index+1)] == "<"{
                    ifHasLeftBound = true
                    ifHasBounds = true
                    ifWordsRemindOn = true
                    if textView.selectedRange.location-index+2 <= textView.selectedRange.location - 1{
                    for i in textView.selectedRange.location-index+2...textView.selectedRange.location-1{
                        updatedRecorder.append(textView.text[textView.text.index(textView.text.startIndex, offsetBy: i)])
                        
                    }
                    }
                    let array:Array<String> = Bundle.main.infoDictionary!["HtmlReference"] as! Array
                    for item in array{
                        if item.contains(updatedRecorder) && item[item.startIndex] == updatedRecorder[updatedRecorder.startIndex]{
                            remindedWords.append(item)
                        }
                    }
                    if !remindedWords.isEmpty{
                        remind(words: remindedWords)
                    }
                    
                }else if textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-index+1)] == ">"
                {
                    ifHasLeftBound = false
                    ifHasBounds = true
                    updatedRecorder = ""
                }
                index+=1
            }
            
           print("updatedRecoder\(updatedRecorder)")
            
            /*
            if (ifWordsRemindOn){
                
                updatedRecorder.append(textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-1)])
                print("updatedRecoder\(updatedRecorder)")
                //遍历词库
                let array:Array<String> = Bundle.main.infoDictionary!["HtmlReference"] as! Array
                
                for item in array{
                   // print("item" + item)
                    
                    if item == updatedRecorder{
                        //变色
                        print("变色")
                        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.red, range:NSRange.init(location:textView.selectedRange.location-updatedRecorder.count, length: updatedRecorder.count))
                        self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1)
                        let location = textView.selectedRange.location
                        textView.attributedText = attributedString
                        self.scripts.selectedRange.location = location
                    }
 
 /* else if !(item.range(of: updatedRecorder)?.isEmpty)!{
                        //提醒
                    }
 */
                }
            }
 */
            if textView.selectedRange.location != 0{
            if textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-1)] == "<"{
                ifWordsRemindOn = true
                 self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor.red
            }
            }
        }
        
        do{
            let data = try NSString(contentsOf: NSURL(fileURLWithPath: "\(sp[0])/test.html") as URL, encoding: String.Encoding.utf8.rawValue)
            print(data)
        }catch let error as NSError{
            print(error)
        }
        
        lastlocation = textView.selectedRange.location
    }
    
    func load(fileName:String){
        var fontColor = "green"
        attributedString = NSMutableAttributedString(string: "")
        let dicred = [NSAttributedStringKey.foregroundColor : UIColor.red]
        let dicgreen = [NSAttributedStringKey.foregroundColor : UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1)]
        do{
            let data = try NSString(contentsOf: NSURL(fileURLWithPath: ProjectUrl + fileName) as URL, encoding: String.Encoding.utf8.rawValue)
            print(data)
            scripts.text = String(data)
            for i in String(data){
                
               if i == ">"{
                    fontColor = "green"
                }
                switch fontColor{
                case "red":
                    attributedString.append(NSMutableAttributedString(string: String(i), attributes: dicred))
                    
                default:
                    break
                }
                 switch fontColor{
                case "green":
                attributedString.append(NSMutableAttributedString(string: String(i), attributes: dicgreen))
                 default:
                    break
                }
                if i == "<"{
                    fontColor = "red"
                }
            }
            scripts.attributedText = attributedString
            self.name = fileName
        }catch let error as NSError{
            print(error)
        }
    }
    
    func remind(words:[String]){
        //计算行数
        print("remind\(words)")
        remindView = Reminder(frame: CGRect(x: self.view.center.x, y:self.view.center.y, width:100, height: 100), remindedWords: words)
        remindView.parentController = self
          self.view.addSubview(remindView)
          remindView.center = self.view.center
        //scripts.isSelectable = false
    }
    
    func addWord(name:String){
        let attributeString = NSMutableAttributedString(string: name)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange.init(location:0, length: name.count))
      //  let range = UITextRange()
        print(scripts.text)
        for i in updatedRecorder{
            
          scripts.text.remove(at: scripts.text.index(before: scripts.text.endIndex))
          
        }
        scripts.text.append(name + ">")
        
        
        let data = NSMutableData()
        if name != nil{
            data.append(NSData(data:scripts.text.data(using: String.Encoding.utf8)!) as Data)
            data.write(toFile: ProjectUrl + self.name, atomically: true)}
         
        load(fileName: self.name)
          self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1)
        scripts.isSelectable = true
        remindView.removeFromSuperview()
    }
 
    }



