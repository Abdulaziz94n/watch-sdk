//
//  BleScanner.swift
//  blesdk3
//
//  Created by Best Mafen on 2019/9/17.
//  Copyright © 2019 szabh. All rights reserved.
//

import UIKit
import CoreBluetooth
import os.log

open class BleScanner: NSObject {
    
    //MARK: - 公开的方法
    public var mBleScanDelegate: BleScanDelegate? = nil // 扫描事件回调
    public var mBleScanFilter: BleScanFilter? = nil // 扫描过滤器
    
    static let DEFAULT_DURATION = 10.0 // 秒

    var mServiceUuids: [CBUUID]? = nil // 扫描时指定的服务

    public var mCentralManager: CBCentralManager! = nil
    var mCentralManagerDelegate: CBCentralManagerDelegate? = nil
    public var isScanning = false // 当前是否正在扫描

    // 扫描持续时间（单位：秒），到期后扫描会自动停止，并触发BleScanDelegate.onScan(false)
    public var mScanDuration = DEFAULT_DURATION

    var mStopScanTimer: Timer? = nil // 扫描开启后，到期时自动停止的定时器

    

    public init(_ serviceUuids: [CBUUID]? = nil) {
        super.init()
        mCentralManager = CBCentralManager.init(delegate: self, queue: nil)
        mServiceUuids = serviceUuids
    }

    // MARK: - Public Method
    public func scan(_ scan: Bool) {
        bleLog("flag == 003, BleScanner(\(mIdentifier)) scan \(scan) -> isScanning=\(isScanning), state=\(mCentralManager.state.mDescription)")
        if isScanning == scan {
            return
        }

        if scan {
            if mCentralManager.state != .poweredOn {
                mBleScanDelegate?.onBluetoothDisabled()
                return
            }

            mCentralManager.scanForPeripherals(withServices: mServiceUuids, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
            stopScanDelay()
        } else {
            mCentralManager.stopScan()
            removeStop()
        }
        isScanning = scan
        mBleScanDelegate?.onScan(isScanning)
    }

    public func exit() {
        scan(false)
        mBleScanDelegate = nil
    }
    
    public func getConnectedDevices() -> [BleDevice] {
        var devices = [BleDevice]()
        let connectedPeripherals = mCentralManager.retrieveConnectedPeripherals(withServices: [CBUUID(string: BLE_MAIN_SERVICE)])
        for peripheral in connectedPeripherals {
            devices.append(BleDevice(peripheral, ["": ""], -10))
        }
        return devices
    }

    // MARK: - Private Method
    private func stopScanDelay() {
        bleLog("BleScanner(\(mIdentifier)) -> stopScanDelay")
        mStopScanTimer = Timer.scheduledTimer(withTimeInterval: mScanDuration, repeats: false, block: {[weak self] _ in
            self?.scan(false)
        })
    }

    private func removeStop() {
        bleLog("BleScanner(\(mIdentifier)) -> removeStop")
        mStopScanTimer?.invalidate()
        mStopScanTimer = nil
    }
}


// MARK: - CBCentralManagerDelegate
extension BleScanner: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bleLog("BleScanner(\(mIdentifier) centralManagerDidUpdateState -> state=\(central.state.mDescription)")
        if central.state == .poweredOn {
            mBleScanDelegate?.onBluetoothEnabled()
        }else if central.state == .unauthorized{
            bleLog("Bluetooth authorization is not turned on")
        }
        mCentralManagerDelegate?.centralManagerDidUpdateState(central)
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        let bleDevice = BleDevice(peripheral, advertisementData, RSSI)
        if RSSI != 127 && (mBleScanFilter == nil || mBleScanFilter!.match(bleDevice)) {
            bleLog("BleScanner(\(mIdentifier)) onDeviceFound -> \(bleDevice))")
            mBleScanDelegate?.onDeviceFound(bleDevice)
        }
        mCentralManagerDelegate?.centralManager?(central, didDiscover: peripheral, advertisementData: advertisementData,
            rssi: RSSI)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        mCentralManagerDelegate?.centralManager?(central, didConnect: peripheral)
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        mCentralManagerDelegate?.centralManager?(central, didFailToConnect: peripheral, error: error)
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        mCentralManagerDelegate?.centralManager?(central, didDisconnectPeripheral: peripheral, error: error)
    }
    
    @available(iOS 13.0, *)
    public func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        mCentralManagerDelegate?.centralManager?(central, didUpdateANCSAuthorizationFor: peripheral)
    }
}
