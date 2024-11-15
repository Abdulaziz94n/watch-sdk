//
//  ABHBackgroundMonitoring.swift
//  blesdk3
//
//  Created by SMA-IOS on 2022/3/28.
//  Copyright © 2022 szabh. All rights reserved.
//

import Foundation
import CoreLocation
import AVFoundation

class ABHBackgroundMonitoring :NSObject{
    
    static let share = ABHBackgroundMonitoring()
    private var monitor: BeaconMonitor?
    var player : AVAudioPlayer?
    var monitorUUID = ""
    private var isPlayingFindphone = false
    override init() {
        super.init()
        BleConnector.shared.addBleHandleDelegate(String(obj: self), self)
        //监听进入后台
        NotificationCenter.default.addObserver(self as Any, selector: #selector(enterBackgroundiBeacon(notification:)), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackgroundiBeacon(notification:)), name:UIApplication.didEnterBackgroundNotification,object: nil)
        //监测程序被激活
        NotificationCenter.default.addObserver(self, selector: #selector(enterBecomeActiveiBeacon(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
   
    @objc func enterBecomeActiveiBeacon(notification:Notification){
        bleLog("enterBecomeActiveiBeacon")
        locationManagerLog("enterBecomeActiveiBeacon")
        isPlayingFindphone = true
    }
    
    @objc func enterBackgroundiBeacon(notification:Notification){
        bleLog("enterBackgroundiBeacon")
        locationManagerLog("enterBackgroundiBeacon")
        isPlayingFindphone = false
    }
}
// MARK: BeaconMonitor
extension ABHBackgroundMonitoring{
    
    func asciiStringToByte(_ str:String)-> String{
        var uuidStr = ""
        var index = 0
        let bleStr = BleCache.shared.mBleAddress
        let endStr = bleStr.replacingOccurrences(of: ":", with: "")
        bleLog("ABHBackgroundMonitoring mBleAddress - \(endStr)")
        for character in  str.unicodeScalars{
            index += 1
            let newUint = UInt8(character.value)
            let newStr = String.init(format: "%02x", newUint)
            
            if index == 4 || index == 6 || index == 8 || index == 10{
                uuidStr += newStr+"-"
                if index == 10 && endStr.count>0{
                    uuidStr += endStr
                    return uuidStr
                }
            }else{
                uuidStr += newStr
            }
        }
        return uuidStr
    }
    func startListening(_ uuidString:String = "CodingV0.1000000"){

        let uuidStr = self.asciiStringToByte(uuidString)
        bleLog("ABHBackgroundMonitoring UUID - \(String(describing: UUID(uuidString: uuidStr)))")
        monitor = BeaconMonitor(uuid: UUID(uuidString: uuidStr)!)
        monitor!.delegate = self
        monitor!.startListening()
        /**
         locationManager log 需要可以打开
         */
        let str = UserDefaults.standard.string(forKey: "locationManager")
        bleLog("iBeacon log - \(String(describing: str))")
        UserDefaults.standard.removeObject(forKey: "locationManager")

    }
    
    func stopListening(_ uuidString:String = "CodingV0.1000000"){
        bleLog("stopListening")
        locationManagerLog("stopListening")
        let uuidStr = self.asciiStringToByte(uuidString)
        if monitor != nil{
            monitor!.stopListening()
        }else{
            monitor = BeaconMonitor(uuid: UUID(uuidString: uuidStr)!)
            monitor!.stopListening()
        }
        
    }
    
    func closeIBeaconControl(){
        if BleConnector.shared.sendInt8(.IBEACON_CONTROL, .UPDATE, 0){
            bleLog("close the current ibeacon broadcast")
            locationManagerLog("close the current ibeacon broadcast")
        }
    }
    
    func setTime(){

        if !BleConnector.shared.isAvailable() {
            bleLog("device not connected")
            locationManagerLog("device not connected - setTime")
            return
        }
        locationManagerLog("device connected - setTime")
        _ = BleConnector.shared.sendObject(.TIME, .UPDATE, BleTime.local())
        _ = BleConnector.shared.sendObject(.TIME_ZONE,.UPDATE, BleTimeZone())
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            //iBeacon 1s广播一次,延迟 规避关闭广播后ble指令同步失败
            self.closeIBeaconControl()
        }
        
    }
    
    func locationManagerLog(_ msgStr:String){
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = dateFormatter.string(from: Date())
        let str = UserDefaults.standard.string(forKey: "locationManager") ?? "*"
        var newStr = str+" \n "+strDate+" " //记录后台运行log,可删除
        newStr += "-- "+String(describing: msgStr)+" --"
        UserDefaults.standard.set(newStr, forKey: "locationManager")
        UserDefaults.standard.synchronize()
    }
}

extension ABHBackgroundMonitoring: BeaconMonitorDelegate {
    
    @objc func receivedAllBeacons(_ monitor: BeaconMonitor, beacons: [CLBeacon]) {
        
        if beacons.first?.minor == 1{
            // Find phone
            bleLog("receivedAllBeacons - Find phone \(isPlayingFindphone)")
            //if isPlayingFindphone == false{
            //    ABHAudioManager.share.responseFindphone()
            //}
        }else if beacons.first?.minor == 2{
            // connect ble
            bleLog("receivedAllBeacons - connect ble")
            setTime()
        }
        //log 需要时打开
        locationManagerLog("receivedAllBeaconsLog - minor:\(String(describing: beacons.first?.minor)) major:\(String(describing: beacons.first?.major))")
        
    }
    
}


extension ABHBackgroundMonitoring: BleHandleDelegate{
    
    //func onFindPhone(_ start: Bool) {
    //    
    //    if start == false && isPlayingFindphone == false{
    //        bleLog("ABHBackgroundMonitoring - onFindPhone")
    //        isPlayingFindphone = true
    //        DispatchQueue.main.asyncAfter(deadline: .now()+1.8) {
    //            self.isPlayingFindphone = false
    //        }
    //        ABHAudioManager.share.stopFindphone()
    //    }
    //}
}
