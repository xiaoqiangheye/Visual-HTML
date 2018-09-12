//
//  Constant.swift
//  Visual HTML
//
//  Created by 强巍 on 2018/2/2.
//  Copyright © 2018年 WeiQiang. All rights reserved.
//

import Foundation
import UIKit
public class Constant{
    static let WEB_SEGUE:String! = "webSegue"
    static let VISUAL_SEGUE:String! = "visualSegue"
    static let EDITOR_SEGUE:String! = "editorSegue"
    static let PROJECT_SEGUE:String! = "projectSegue"
    static let File_CREATOR_SEGUE:String! = "fileCreator"
    static let FTP_VIEWER_SEGUE:String! = "FTPViewerSegue"
    static let FTP_CONFIGURATION_SEGUE:String! = "FTPConfigurationSegue"
    static let MY_DIRECTORY:String! = NSHomeDirectory() + "/Documents/Projects/"
    static var ScreenX:CGFloat!
    static var ScreenY:CGFloat!
    static let IF_LAUCHED_STRING:String = "everLauched"
    
    struct HTML {
    static let PROPERTIES_KEY:String = "propertiesKey"
    }
    
    struct FTP {
    static let FTP_STORAGE_KEY:String = "FTPStorageArray"
    static let FTP_STORAGE_URL:String = NSHomeDirectory() + "/Documents/FTP/ftpList.txt"
    }
    

    struct ParserMode {
        static let TAG_START_MODE = "tagStart"
        static let TAG_END_MODE = "tagEnd"
        static let ENDTAG_STARD_MODE = "endTagStart"
        static let TEXT_MODE = "text"
        static let TAG_TEXT_MODE = "tagText"
        static let ENDTAG_TEXT_MODE = "endTagText"
        static let ENDTAG_END_MODE = "endTagEnd"
        static let PROPERTIES_START_MODE = "propertiesStart"
        static let PROPERTIES_KEY_START_MODE = "propertiesKeyStart"
        static let PROPERTIES_KEY_MODE = "propertiesKey"
        static let PROPERTIES_KEY_END_MODE = "propertiesKeyEnd"
        static let PROPERTIES_VALUE_START_MODE = "propertiesValueStartMode"
        static let PROPERTIES_VALUE_MODE = "propertiesValueMode"
        static let PROPERTIES_VALUE_END_MODE = "propertiesValueEndMode"
        static let PROPERTIES_END_MODE = "propertiesEnd"
        static let FILTER_MODE = "fileter"
    }
    
    struct JSParserMode{
        //;
        static let LINE_END_MODE = "lineEndMode"
        //keyword
        static let KEYWORD_START_MODE = "keyWordStartMode"
        static let KEYWORD_END_MODE = "keyWordEndMode"
        static let KEYWORD_MODE = "keyWordMode"
        
         //var
        static let VAR_NAME_MODE = "varNameMode"
        static let VAR_NAME_END_MODE = "varNameEndMode"
        
        //xiao.xiaoqiang
        static let VARIABLE_MODE = "variableMode"
       
        //"dsfs"
        static let STRING_MODE = "stringMode"
        //=0.25
        static let NUMBER_MODE = "numberMode"
        ///=true
        static let BOOL_MODE = "boolMode"
        
        ////[]
        static let BIG_BRANKET_MODE = "bigBranketMode"
        static let BIG_BRANKET_START_MODE = "bigBranketStartMode"
        static let BIG_BRANKET_END_MODE = "bigBranketEndMode"
        
        ///{}
        static let MIDDLE_BRANKET_MODE  = "middleBranketMode"
        static let MIDDLE_BRANKET_START_MODE = "middleBranketStartMode"
        static let MIDDLE_BRANKET_END_MODE = "middleBranketEndMode"
        
        
        
        
        struct Function {
            static let FUNCTION_START_MODE = "functionStartMode"
            static let FUNCTION_END_MODE = "functionEndMode"
            static let FUNCTION_MODE = "functionMode"
            
            //Parameter
            static let PARAMETER_START_MODE = "parameterStartMode"
            static let PARAMETER_MODE = "parameterMode"
            static let PARAMETER_END_MODE = "parameterEndMode"
        }
        struct Global{
            static let GLOBAL_MODE = "globalMode"
        }
        
        
    }
    
}
