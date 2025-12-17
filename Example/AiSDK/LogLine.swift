//
//  LogLine.swift
//  AiSDK_Example
//
//  Created by HuaWo on 2025/1/9.
//  Copyright © 2025 hulala1210. All rights reserved.
//

import UIKit

@objc class LogLine: NSObject {
    
    @objc var height: CGFloat = 0
    @objc var color: UIColor = UIColor.green
    @objc var date: Date = Date()
    @objc var message: String = ""
    private var logLevel = 0
    @objc var timeText = ""
    
    @objc init(msg: String, level: Int) {
        super.init()
        message = msg
        logLevel = level
        if logLevel == 0 {
            color = UIColor.white
        }
        else if logLevel == 1 {
            color = UIColor.green
        }
        else if logLevel == 2 {
            color = UIColor.orange
        }
        else {
            color = UIColor.red
        }
        
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss.sss"
        timeText = "\(format.string(from: date)) >> ";
     
        let width = UIScreen.main.bounds.width - 16 * 2 - 20 - 100 - 5
        let constrainedSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = (msg as NSString).boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 12)], context: nil)
        height = boundingRect.height + 10
    }
    
}
