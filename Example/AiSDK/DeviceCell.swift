//
//  DeviceCell.swift
//  AiSDK_Example
//
//  Created by HuaWo on 2025/1/9.
//  Copyright © 2025 hulala1210. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {

    static func ID() -> String {
        return "DeviceCellID"
    }
    
    static func Height() -> CGFloat {
        return 60
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var macLbl: UILabel!
    
    @IBOutlet weak var rssiLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(_ device: HwBluetoothDevice) {
        self.nameLbl.text = device.name
        self.macLbl.text = device.macAddress
        self.rssiLbl.text = "\(device.rssi ?? 0)"
    }
}
