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
    var temporaryRemindRecorder:String = ""
    var name:String!
    var updatedRecorder:String = ""
    var ifWordsRemindOn:Bool = false
    var attributedString:NSMutableAttributedString!
    var lastlocation:Int!
    var remindView:Reminder!
    var url:String = ""
    var mode:String = ""
    var currentLines:Int = 0
    var lineRecorder:String = ""
    var currentMode:String = ""
    @IBOutlet var nameLabel: UILabel!
    //Text
    func remind(words:[String]){
        //计算行数
        print("remind\(words)")
        let rectX = lineRecorder.size().width
        let rectY = lineRecorder.size().height
        let string = NSString(string: lineRecorder)
       
         let range = NSRange.init(location: 0, length: 1)
        let pointer = NSRangePointer.allocate(capacity: range.length)
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let attribute = [NSAttributedStringKey.font: scripts.attributedText.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: pointer)]
        let size = string.boundingRect(with: CGSize(width:UIScreen.main.bounds.width - 60, height:CGFloat(MAXFLOAT)), options:option , attributes: attribute, context: nil).size
        
        print("line\(lineRecorder)")
        print("X\(size.width)")
        print("y\(size.height)")
        remindView = Reminder(frame: CGRect(x: size.width, y:CGFloat(currentLines+1) * (size.height)/2+40, width:100, height: 100), remindedWords: words)
        remindView.parentController = self
        self.view.addSubview(remindView)
        //remindView.center = self.view.center
        //scripts.isSelectable = false
    }
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scripts.backgroundColor = UIColor(red: 30/255, green: 32/255, blue: 40/255, alpha: 1)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        /*
        if name != nil{
        let currentlocation = textView.selectedRange.location
        if self.name.contains(".html"){
            load(url: self.url, filename: self.name)
        }else if self.name.contains(".js"){
            loadJs(url: self.url, filename: self.name)
        }
            textView.selectedRange.location = currentlocation
        }
 */
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
                data.write(toFile: self.url, atomically: true)}
           
            if name.contains(".html"){
                load(url: self.url, filename: self.name)
            }else if name.contains(".js"){
                loadJs(url: self.url, filename: self.name)
            }
            textView.selectedRange.location = currentlocation
           // print("char\(textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-1)])")
            print("currentlines:\(currentLines)")
            //检测前两个是否为<
            /*deprecated
            if textView.selectedRange.location >= 2{
                if textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-2)] == "<"{
                    ifWordsRemindOn = false
                    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.red, range:NSRange.init(location:textView.selectedRange.location-1, length: 1))
                    self.scripts.attributedText = attributedString
                    self.scripts.selectedRange.location = currentlocation
                    self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor.red
                }
            }
           */
            //进入< mode
            /* deprecated
            if textView.selectedRange.location != 0{
            if textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-1)] == ">"{
                if mode == Constant.ParserMode.TEXT_MODE{
                    mode = Constant.ParserMode.TAG_END_MODE
                }
                ifWordsRemindOn = false
                updatedRecorder = ""
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1), range:NSRange.init(location:textView.selectedRange.location-1, length: 1))
                self.scripts.attributedText = attributedString
                self.scripts.selectedRange.location = currentlocation
                self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1)
            }
            }
            */
            if name.contains(".html"){
            var ifHasLeftBound = false
            var ifHasBounds = false
            var index:Int = 2
            var remindedWords:[String] = []
            while(ifHasBounds == false && textView.selectedRange.location-index > 1){
                if textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-index+1)] == "<" || (textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-index+1)] == "/" && textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-index)] == "<"){
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
            }
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
            
            /* deprecated
            if textView.selectedRange.location != 0{
            if textView.text[textView.text.index(textView.text.startIndex, offsetBy: textView.selectedRange.location-1)] == "<"{
                ifWordsRemindOn = true
                 self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor.red
            }
            }
        }
 */
        }
        
        lastlocation = textView.selectedRange.location
    }
    
    func load(url:String,filename:String){
        let data = try! NSString(contentsOf: NSURL(fileURLWithPath: url) as URL, encoding: String.Encoding.utf8.rawValue)
       
        let dicred = [NSAttributedStringKey.foregroundColor : UIColor(red: 178/255, green: 24/255, blue: 137/255, alpha: 1)]
        let dicgreen = [NSAttributedStringKey.foregroundColor : UIColor(red: 0/255, green: 160/255, blue: 190/255, alpha: 1)]
        let dicOrange = [NSAttributedStringKey.foregroundColor : UIColor.orange]
        
        var updatedRecoder:String = ""
        var attributedString = NSMutableAttributedString(string: "")
        var index = 0
        currentLines = 0
        
        for character in String(data){
        switch character{
        case "<":
            mode = Constant.ParserMode.TAG_START_MODE
            attributedString.append(NSMutableAttributedString(string: String(character), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]))
            break
        case ">":
            if mode == Constant.ParserMode.TAG_TEXT_MODE{
                mode = Constant.ParserMode.TAG_END_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]))
                updatedRecoder = ""
            }else if mode == Constant.ParserMode.ENDTAG_TEXT_MODE{
                mode = Constant.ParserMode.ENDTAG_END_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]))
                updatedRecoder = ""
            }else if mode == Constant.ParserMode.PROPERTIES_VALUE_END_MODE{
                mode = Constant.ParserMode.TAG_END_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]))
            }else if mode == Constant.ParserMode.PROPERTIES_VALUE_MODE{
                mode = Constant.ParserMode.TAG_END_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]))
            }else if mode == Constant.ParserMode.PROPERTIES_KEY_MODE{
                mode = Constant.ParserMode.TAG_END_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]))
            }else if mode == Constant.ParserMode.PROPERTIES_KEY_START_MODE{
                mode = Constant.ParserMode.TAG_END_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white]))
            }
            break
        case "/":
            if mode == Constant.ParserMode.TAG_START_MODE{
                mode = Constant.ParserMode.ENDTAG_STARD_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: dicred))
            }
            break
        case " ":
            if mode == Constant.ParserMode.TAG_TEXT_MODE
            {
               
                updatedRecoder = ""
                mode = Constant.ParserMode.PROPERTIES_KEY_START_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: dicOrange))
            }else if mode == Constant.ParserMode.PROPERTIES_VALUE_END_MODE{
                mode = Constant.ParserMode.PROPERTIES_KEY_START_MODE
                 attributedString.append(NSMutableAttributedString(string: String(character), attributes: dicOrange))
            }
            else if mode == Constant.ParserMode.PROPERTIES_KEY_MODE{
                mode = Constant.ParserMode.PROPERTIES_KEY_END_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: dicOrange))
                updatedRecoder = ""
            }
            else if mode == Constant.ParserMode.PROPERTIES_VALUE_MODE{
                mode = Constant.ParserMode.PROPERTIES_KEY_START_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: dicOrange))
                updatedRecoder = ""
            }else if mode == Constant.ParserMode.PROPERTIES_KEY_MODE{
                mode = Constant.ParserMode.PROPERTIES_KEY_START_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes: dicOrange))
                updatedRecoder = ""
            }
            break
        case "=":
            if mode == Constant.ParserMode.PROPERTIES_KEY_MODE{
                mode = Constant.ParserMode.PROPERTIES_VALUE_START_MODE
               attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            }else if mode == Constant.ParserMode.PROPERTIES_KEY_END_MODE{
                mode = Constant.ParserMode.PROPERTIES_VALUE_START_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            }
            
            break
        case "\"":
            if mode == Constant.ParserMode.PROPERTIES_KEY_END_MODE{
                mode = Constant.ParserMode.PROPERTIES_VALUE_START_MODE
                 attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.red]))
            }else if mode == Constant.ParserMode.PROPERTIES_VALUE_MODE{
                mode = Constant.ParserMode.PROPERTIES_VALUE_END_MODE
                attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.red]))
                updatedRecoder = ""
            }else{
                attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.red]))
            }
            break
            /*
        case "\n":
            if index <= scripts.selectedRange.location{
             currentLines += 1
            }
            lineRecorder = ""
            //attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
 */
        default:
            if mode == Constant.ParserMode.TAG_START_MODE{
                mode = Constant.ParserMode.TAG_TEXT_MODE
             //attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.red]))
            }else if mode == Constant.ParserMode.TAG_END_MODE{
                mode = Constant.ParserMode.TEXT_MODE
              //attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            }else if mode == Constant.ParserMode.ENDTAG_STARD_MODE{
            //attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.red]))
                mode = Constant.ParserMode.ENDTAG_TEXT_MODE
            }else if mode == Constant.ParserMode.PROPERTIES_KEY_START_MODE{
            //attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.orange]))
                mode = Constant.ParserMode.PROPERTIES_KEY_MODE
            }else if mode == Constant.ParserMode.PROPERTIES_VALUE_START_MODE{
                mode = Constant.ParserMode.PROPERTIES_VALUE_MODE
                 //attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.red]))
            }else if mode == Constant.ParserMode.ENDTAG_END_MODE{
                mode = Constant.ParserMode.TEXT_MODE
            }
        }
            
            if character == "\n"{
                if index < scripts.selectedRange.location{
                 currentLines += 1
                 lineRecorder = ""
                }
            }
         if index < scripts.selectedRange.location{
            lineRecorder.append(character)
            }
            
            
        if mode == Constant.ParserMode.TAG_TEXT_MODE{
            attributedString.append(NSMutableAttributedString(string: String(character), attributes:dicred))
            updatedRecoder.append(character)
            
        }else if mode == Constant.ParserMode.ENDTAG_TEXT_MODE{
            attributedString.append(NSMutableAttributedString(string: String(character), attributes:dicred))
            updatedRecoder.append(character)
            
        }else if mode == Constant.ParserMode.PROPERTIES_KEY_MODE{
            attributedString.append(NSMutableAttributedString(string: String(character), attributes:dicgreen))
            updatedRecoder.append(character)
            
        }else if mode == Constant.ParserMode.PROPERTIES_VALUE_MODE{
            attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.red]))
            updatedRecoder.append(character)
            
        }else if mode == Constant.ParserMode.TEXT_MODE{
            attributedString.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            
            }
            
            index += 1
    }
        scripts.attributedText = attributedString
        self.name = filename
        self.url = url
    
        /*
        var fontColor = "green"
        attributedString = NSMutableAttributedString(string: "")
        let dicred = [NSAttributedStringKey.foregroundColor : UIColor.red]
        let dicgreen = [NSAttributedStringKey.foregroundColor : UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1)]
        do{
            let data = try NSString(contentsOf: NSURL(fileURLWithPath: url) as URL, encoding: String.Encoding.utf8.rawValue)
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
            self.name = filename
            self.url = url
        }catch let error as NSError{
            print(error)
        }
 */
    }
    
    func loadJs(url:String,filename:String){
        temporaryRemindRecorder = ""
        updatedRecorder = ""
        lineRecorder = ""
        var ifRemind:Bool = false
        var jsFunctionRecorder:Array<String> = []
        let data = try! NSString(contentsOf: NSURL(fileURLWithPath: url) as URL, encoding: String.Encoding.utf8.rawValue)
        let dicred = [NSAttributedStringKey.foregroundColor : UIColor(red: 178/255, green: 24/255, blue: 137/255, alpha: 1)]
        let dicgreen = [NSAttributedStringKey.foregroundColor : UIColor(red: 0/255, green: 160/255, blue: 190/255, alpha: 1)]
        let dicOrange = [NSAttributedStringKey.foregroundColor : UIColor.orange]
        var attributed = NSMutableAttributedString(string: "")
        var index:Int = 0
        currentLines = 0
        var bigMode:String = ""
        var smallMode:String = ""
        for character in data as! String{
            switch character{
            case ";":
                smallMode = Constant.JSParserMode.LINE_END_MODE
                if index == scripts.selectedRange.location-1{
                    currentMode = smallMode
                }
                updatedRecorder = ""
                attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            case "{":
                smallMode = Constant.JSParserMode.MIDDLE_BRANKET_START_MODE
                if index == scripts.selectedRange.location-1{
                    currentMode = smallMode
                }
                 attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            case "}":
                smallMode = Constant.JSParserMode.MIDDLE_BRANKET_END_MODE
                if index == scripts.selectedRange.location-1{
                    currentMode = smallMode
                }
                updatedRecorder = ""
                attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            case "[":
                smallMode = Constant.JSParserMode.BIG_BRANKET_START_MODE
                if index == scripts.selectedRange.location-1{
                    currentMode = smallMode
                }
                 attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            case "]":
                smallMode = Constant.JSParserMode.BIG_BRANKET_END_MODE
                if index == scripts.selectedRange.location-1{
                    currentMode = smallMode
                }
                updatedRecorder = ""
                 attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            case " ":
                if updatedRecorder == "function"{
                    smallMode = Constant.JSParserMode.Function.FUNCTION_START_MODE
                    if index == scripts.selectedRange.location-1{
                        currentMode = smallMode
                    }
                }
                let array = Bundle.main.infoDictionary!["JSKeyWords"] as! Array<String>
                for item in array{
                    if item == updatedRecorder{
                        attributed.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange.init(location:attributed.string.count-updatedRecorder.count, length: updatedRecorder.count))
                        updatedRecorder = ""
                        break
                    }
                }
                if smallMode != Constant.JSParserMode.STRING_MODE{
                    updatedRecorder = ""
                }
                 attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
            case "\n":
                smallMode = Constant.JSParserMode.LINE_END_MODE
                attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
                 updatedRecorder = ""
                if index < scripts.selectedRange.location{
                    currentLines += 1
                    lineRecorder = ""
                }
            case "(":
                 attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
                 if smallMode == Constant.JSParserMode.Function.FUNCTION_MODE{
                    jsFunctionRecorder.append(updatedRecorder)
                    smallMode = Constant.JSParserMode.Function.PARAMETER_START_MODE
                    if index == scripts.selectedRange.location-1{
                        currentMode = smallMode
                    }
                }
            case ")":
                 attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
                 if smallMode == Constant.JSParserMode.Function.PARAMETER_MODE{
                    smallMode = Constant.JSParserMode.Function.PARAMETER_END_MODE
                    if index == scripts.selectedRange.location-1{
                        currentMode = smallMode
                    }
                }
               
            default:
                if smallMode == Constant.JSParserMode.Function.FUNCTION_START_MODE{
                    smallMode = Constant.JSParserMode.Function.FUNCTION_MODE
                    if index == scripts.selectedRange.location-1{
                        currentMode = smallMode
                    }
                }else if smallMode == Constant.JSParserMode.Function.PARAMETER_START_MODE{
                    smallMode = Constant.JSParserMode.Function.PARAMETER_MODE
                    if index == scripts.selectedRange.location-1{
                        currentMode = smallMode
                    }
                }
                    attributed.append(NSMutableAttributedString(string: String(character), attributes:[NSAttributedStringKey.foregroundColor:UIColor.white]))
                    updatedRecorder.append(character)
                    print(updatedRecorder)
            }
            
            print("Functions Contain\(jsFunctionRecorder)")
            print("index\(index)")
            print("location\(scripts.selectedRange.location)")
            print("updatedRecorder\(updatedRecorder)")
            print("currentMode\(currentMode)")
            if currentMode != Constant.JSParserMode.Function.FUNCTION_MODE && currentMode != Constant.JSParserMode.Function.FUNCTION_START_MODE && currentMode != Constant.JSParserMode.Function.FUNCTION_END_MODE && currentMode != Constant.JSParserMode.Function.PARAMETER_MODE && currentMode != Constant.JSParserMode.Function.PARAMETER_START_MODE && currentMode != Constant.JSParserMode.Function.PARAMETER_END_MODE && currentMode != Constant.JSParserMode.BIG_BRANKET_MODE && currentMode != Constant.JSParserMode.BIG_BRANKET_START_MODE && currentMode != Constant.JSParserMode.BIG_BRANKET_END_MODE && scripts.selectedRange.location-1 == index{
                print("start to remind")
                ifRemind = true
               temporaryRemindRecorder = updatedRecorder
            }
            if index < scripts.selectedRange.location{
                lineRecorder.append(character)
            }
            index += 1
        }
        
        //Remind
        var remindedWords = [String]()
        for item in jsFunctionRecorder{
            if item.contains(temporaryRemindRecorder){
                remindedWords.append(item)
            }
        }
        if remindedWords.count > 0{
        remind(words: remindedWords)
        }
        
        scripts.attributedText = attributed
        self.name = filename
        self.url = url
    }
    
    func loadPhp(url:String,filename:String){
        
    }
    
    func loadCss(url:String,filename:String){
        
    }
    
    func addWord(name:String){
        //let attributeString = NSMutableAttributedString(string: name)
        //attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:NSRange.init(location:0, length: name.count))
      //  let range = UITextRange()
       // print(scripts.text)
        if self.name.contains(".js"){
        for i in temporaryRemindRecorder{
         let location = scripts.selectedRange.location
            scripts.text.remove(at: scripts.text.index(scripts.text.startIndex, offsetBy: scripts.selectedRange.location - 1))
            scripts.selectedRange.location = location - 1
        }
        }
        else if self.name.contains(".html"){
            for i in updatedRecorder{
                let location = scripts.selectedRange.location
                scripts.text.remove(at: scripts.text.index(scripts.text.startIndex, offsetBy: scripts.selectedRange.location - 1))
                scripts.selectedRange.location = location - 1
            }
        }
        let location = scripts.selectedRange.location
        //scripts.text.append(name + ">")
       scripts.text.insert(contentsOf: name, at: scripts.text.index(scripts.text.startIndex, offsetBy: scripts.selectedRange.location))
        let data = NSMutableData()
        if name != nil{
            data.append(NSData(data:scripts.text.data(using: String.Encoding.utf8)!) as Data)
            data.write(toFile: self.url, atomically: true)}
        print("url\(self.url)")
        print("name\(self.name)")
        if self.name.contains(".html"){
        load(url:self.url,filename: self.name)
        }else if self.name.contains(".js"){
        loadJs(url:self.url, filename: self.name)
        }
        scripts.selectedRange.location = location + name.count
          //self.scripts.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor(red: 165/255, green: 240/255, blue: 184/255, alpha: 1)
        scripts.isSelectable = true
        remindView.removeFromSuperview()
    }
}
