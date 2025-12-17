//
//  LogCell.swift
//  AiSDK_Example
//
//  Created by HuaWo on 2025/1/9.
//  Copyright © 2025 hulala1210. All rights reserved.
//

import UIKit

@objc class LogCell: UITableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    
    @objc static func ID() -> String {
        return "LogCellID"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func update(_ log: LogLine) {
        timeLbl.text = log.timeText
        msgLbl.text = log.message
        msgLbl.textColor = log.color
        print("LogCell, time: \(log.timeText), message: \(log.message)")
    }
    
}
