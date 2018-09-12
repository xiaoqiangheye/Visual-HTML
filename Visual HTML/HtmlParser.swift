//
//  HtmlParser.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/7.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit

class HtmlParser{
    static var mode:String = ""
    static func htmlToBlock(code:String)->Node{
        var updatedRecoder = ""
        var emptydic = Dictionary<String,Any>()
        emptydic[Constant.HTML.PROPERTIES_KEY] = Dictionary<String,Any>()
        emptydic["withEndTag"] = "true"
        var dic = emptydic[Constant.HTML.PROPERTIES_KEY] as! Dictionary<String,Any>
        emptydic[Constant.HTML.PROPERTIES_KEY] = dic
        var parentNode = Node(name: "", storage: emptydic)
        var key:String = ""
        var value:String = ""
        for character in code {
            switch character{
                case "<":
                    if mode == Constant.ParserMode.TEXT_MODE{
                        var emptyDic = Dictionary<String,Any>()
                        emptyDic[Constant.HTML.PROPERTIES_KEY] = Dictionary<String,Any>()
                        //let rangeindex:Range<String.Index> = updatedRecoder.range(of: "^[^\r\\\t\n]*", options: .regularExpression, range: updatedRecoder.startIndex..<updatedRecoder.endIndex, locale:Locale.current)!
                        updatedRecoder = updatedRecoder.trimmingCharacters(in: NSCharacterSet.newlines)
                        var dic = emptyDic[Constant.HTML.PROPERTIES_KEY] as! Dictionary<String,Any>
                        dic["text"] = updatedRecoder
                        emptyDic[Constant.HTML.PROPERTIES_KEY] = dic
                        //let substring = updatedRecoder.substring(with: rangeindex)
                        if updatedRecoder != ""{
                        parentNode.addChildNode(child:Node(name:"text",storage:emptyDic))
                        }
                        updatedRecoder = ""
                    }
                    mode = Constant.ParserMode.TAG_START_MODE
                break
                case ">":
                    if mode == Constant.ParserMode.TAG_TEXT_MODE{
                 mode = Constant.ParserMode.TAG_END_MODE
                var emptyDic = Dictionary<String,Any>()
                  emptyDic[Constant.HTML.PROPERTIES_KEY] = Dictionary<String,Any>()
                    parentNode.addChildNode(child: Node(name:updatedRecoder,storage:emptyDic))
                updatedRecoder = ""
                    }else if mode == Constant.ParserMode.ENDTAG_TEXT_MODE{
                        mode = Constant.ParserMode.ENDTAG_END_MODE
                        let currentCount = parentNode.childNode.endIndex-1
                        for index in parentNode.childNode.startIndex...currentCount{
                            var i = parentNode.childNode.endIndex - 1 - index
                            if parentNode.childNode[i].name == updatedRecoder{
                                var dic = parentNode.childNode[i].storage as! Dictionary<String,Any>
                                var properties = dic[Constant.HTML.PROPERTIES_KEY] as! Dictionary<String,Any>
                                dic["withEndTag"] = "true"
                                dic[Constant.HTML.PROPERTIES_KEY] = properties
                                parentNode.childNode[i].storage = dic
                                if i < parentNode.childNode.endIndex - 1{
                                for index2 in i+1...parentNode.childNode.endIndex-1{
                                    parentNode.childNode[i].addChildNode(child: parentNode.childNode[index2])
                                }
                                for index2 in i+1...parentNode.childNode.endIndex-1{
                                    parentNode.childNode.remove(at: parentNode.childNode.endIndex - 1)
                                }
                                }
                                break
                            }
                        }
                        updatedRecoder = ""
                    }else if mode == Constant.ParserMode.PROPERTIES_VALUE_END_MODE{
                        mode = Constant.ParserMode.TAG_END_MODE
                       
                    }else if mode == Constant.ParserMode.PROPERTIES_VALUE_MODE{
                        mode = Constant.ParserMode.TAG_END_MODE
                       
                    }else if mode == Constant.ParserMode.PROPERTIES_KEY_MODE{
                        mode = Constant.ParserMode.TAG_END_MODE
                       
                    }else if mode == Constant.ParserMode.ENDTAG_STARD_MODE{
                        mode = Constant.ParserMode.TAG_END_MODE
                        var emptyDic = Dictionary<String,Any>()
                        emptyDic[Constant.HTML.PROPERTIES_KEY] = Dictionary<String,Any>()
                        parentNode.addChildNode(child: Node(name:updatedRecoder,storage:emptyDic))
                        updatedRecoder = ""
                    }
                    
                break
                case "/":
                    if mode == Constant.ParserMode.TAG_START_MODE{
                        mode = Constant.ParserMode.ENDTAG_STARD_MODE
                    }
                break
                case " ":
                    if mode == Constant.ParserMode.TAG_TEXT_MODE
                    {
                        var emptyDic = Dictionary<String,Any>()
                        emptyDic[Constant.HTML.PROPERTIES_KEY] = Dictionary<String,Any>()
                        parentNode.addChildNode(child: Node(name:updatedRecoder,storage:emptyDic))
                        updatedRecoder = ""
                        mode = Constant.ParserMode.PROPERTIES_KEY_START_MODE
                    }else if mode == Constant.ParserMode.PROPERTIES_VALUE_END_MODE{
                        mode = Constant.ParserMode.PROPERTIES_KEY_START_MODE
                    }
                    else if mode == Constant.ParserMode.PROPERTIES_KEY_MODE{
                        mode = Constant.ParserMode.PROPERTIES_KEY_END_MODE
                        key = updatedRecoder
                        updatedRecoder = ""
                }
                break
              case "=":
                if mode == Constant.ParserMode.PROPERTIES_KEY_MODE{
                    mode = Constant.ParserMode.PROPERTIES_VALUE_START_MODE
                }
                break
               case "\"":
                if mode == Constant.ParserMode.PROPERTIES_KEY_END_MODE{
                    mode = Constant.ParserMode.PROPERTIES_VALUE_START_MODE
                }else if mode == Constant.ParserMode.PROPERTIES_VALUE_MODE{
                    mode = Constant.ParserMode.PROPERTIES_VALUE_END_MODE
                    value = updatedRecoder
                    var dic = parentNode.childNode[parentNode.childNode.count - 1].storage as! Dictionary<String,Any>
                    var properties = dic[Constant.HTML.PROPERTIES_KEY] as! Dictionary<String,Any>
                    properties[key] = value
                    dic[Constant.HTML.PROPERTIES_KEY] = properties
                    parentNode.childNode[parentNode.childNode.count - 1].storage = dic
                    updatedRecoder = ""
                }
                break
            case "'":
                if mode == Constant.ParserMode.PROPERTIES_KEY_END_MODE{
                    mode = Constant.ParserMode.PROPERTIES_VALUE_START_MODE
                }else if mode == Constant.ParserMode.PROPERTIES_VALUE_MODE{
                    mode = Constant.ParserMode.PROPERTIES_VALUE_END_MODE
                    value = updatedRecoder
                    var dic = parentNode.childNode[parentNode.childNode.count - 1].storage as! Dictionary<String,Any>
                    var properties = dic[Constant.HTML.PROPERTIES_KEY] as! Dictionary<String,Any>
                    properties[key] = value
                    dic[Constant.HTML.PROPERTIES_KEY] = properties
                    parentNode.childNode[parentNode.childNode.count - 1].storage = dic
                    updatedRecoder = ""
                }
                default:
                    
                    if mode == Constant.ParserMode.TAG_START_MODE{
                        mode = Constant.ParserMode.TAG_TEXT_MODE
                    }else if mode == Constant.ParserMode.TAG_END_MODE{
                        mode = Constant.ParserMode.TEXT_MODE
                    }else if mode == Constant.ParserMode.ENDTAG_STARD_MODE{
                        mode = Constant.ParserMode.ENDTAG_TEXT_MODE
                    }else if mode == Constant.ParserMode.PROPERTIES_KEY_START_MODE{
                        mode = Constant.ParserMode.PROPERTIES_KEY_MODE
                    }else if mode == Constant.ParserMode.PROPERTIES_VALUE_START_MODE{
                        mode = Constant.ParserMode.PROPERTIES_VALUE_MODE
                    }else if mode == Constant.ParserMode.ENDTAG_END_MODE{
                        mode = Constant.ParserMode.TEXT_MODE
                }
            }
            if mode == Constant.ParserMode.TAG_TEXT_MODE{
                updatedRecoder.append(character)
            }else if mode == Constant.ParserMode.ENDTAG_TEXT_MODE{
                updatedRecoder.append(character)
            }else if mode == Constant.ParserMode.PROPERTIES_KEY_MODE{
                updatedRecoder.append(character)
            }else if mode == Constant.ParserMode.PROPERTIES_VALUE_MODE{
                updatedRecoder.append(character)
            }else if mode == Constant.ParserMode.TEXT_MODE{
                updatedRecoder.append(character)
            }
            print(mode)
        }
        
       print(parentNode)
        
        /*
        for character in code{
            switch character{
            case "<":
                mode = Constant.ParserMode.TAG_START_MODE
                break
            case ">":
                if mode == Constant.ParserMode.TAG_TEXT_MODE{
                mode = Constant.ParserMode.TAG_END_MODE
                
                }else if mode == Constant.ParserMode.ENDTAG_TEXT_MODE
                {
                mode = Constant.ParserMode.ENDTAG_END_MODE
                    let currentCount = parentNode.childNode.endIndex-1
                    for index in parentNode.childNode.startIndex...currentCount{
                        var i = parentNode.childNode.endIndex - 1 - index
                        if parentNode.childNode[i].name == updatedRecoder{
                            for index2 in i+1...parentNode.childNode.endIndex-1{
                                parentNode.childNode[i].addChildNode(child: parentNode.childNode[index2])
                               
                            }
                            for index2 in i+1...parentNode.childNode.endIndex-1{
                             parentNode.childNode.remove(at: parentNode.childNode.endIndex - 1)
                            }
                            break
                        }
                    }
                updatedRecoder = ""
                }
                break
            case "/":
                if mode == Constant.ParserMode.TAG_START_MODE{
                mode = Constant.ParserMode.ENDTAG_STARD_MODE
                    
                }
                break
            default:
                if mode == Constant.ParserMode.TAG_START_MODE{
                    mode = Constant.ParserMode.TAG_TEXT_MODE
                    
                }else if mode == Constant.ParserMode.TAG_END_MODE{
                    mode = Constant.ParserMode.TEXT_MODE
                   
                }else if mode == Constant.ParserMode.ENDTAG_STARD_MODE{
                    mode = Constant.ParserMode.ENDTAG_TEXT_MODE
                    updatedRecoder.append(character)
                }
                else if mode == Constant.ParserMode.ENDTAG_TEXT_MODE{
                    updatedRecoder.append(character)
                }
         }
        }
 */
  //print(parentNode)
        return parentNode
    }

}
