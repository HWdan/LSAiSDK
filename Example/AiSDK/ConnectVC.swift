//
//  ConnectVC.swift
//  AiSDK_Example
//
//  Created by HuaWo on 2025/1/9.
//  Copyright © 2025 hulala1210. All rights reserved.
//

import UIKit

@objc protocol ConnectVCDelegate: NSObjectProtocol {
    func didConnect(device: HwBluetoothDevice)
}
 
@objc public class ConnectVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var devices: [HwBluetoothDevice] = []
    @objc weak var delegate: ConnectVCDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "连接设备";
        
        let btn = UIButton(type: .custom)
        btn.setTitle("扫描", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(scan), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.frame = CGRect(x: 0, y: 0, width: 54, height: 44)
        
        let btnItem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = btnItem
        
        let btn2 = UIButton(type: .custom)
        btn2.setTitle("取消", for: .normal)
        btn2.setTitleColor(.gray, for: .normal)
        btn2.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn2.frame = CGRect(x: 0, y: 0, width: 54, height: 44)
        
        let btnItem2 = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = btnItem2
                
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "DeviceCell", bundle: nil), forCellReuseIdentifier: DeviceCell.ID())
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scan()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HwBluetoothSDK.sharedInstance().stopScan()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeviceCell.ID(), for: indexPath) as! DeviceCell
        cell.update(devices[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeviceCell.Height()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        connect(devices[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func scan() {
        self.devices = []
        self.tableView.reloadData()
        HwBluetoothSDK.sharedInstance().scan(callback: { deviceArr, err in
            if let arr = deviceArr {
                self.devices = arr
                self.tableView.reloadData()
            }
        }, stopAfter: 10) {
            self.tableView.reloadData()
        }
    }
    
    func connect(_ device: HwBluetoothDevice) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "连接中...")
        HwBluetoothSDK.sharedInstance().connect(with: device) { error in
            if let err = error {
                SVProgressHUD.showError(withStatus: "连接失败：\(err.localizedDescription)")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "连接成功")
            SVProgressHUD.dismiss(withDelay: 2)
            self.navigationController?.dismiss(animated: true)
            self.delegate?.didConnect(device: device)
        }
    }
    
    @objc func cancel() {
        self.navigationController?.dismiss(animated: true)
    }
}
