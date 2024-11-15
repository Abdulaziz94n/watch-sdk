//
// Created by Best Mafen on 2019/10/9.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

let BLE_OK: UInt8 = 0
let BLE_ERROR: UInt8 = 1

public let ID_ALL = 0xff
let DATA_EPOCH = 946684800 // 1970/1/1 00:00:00距离2000/1/1 00:00:00的秒数

class BleState {
    /**
     * 设备已断开
     */
    static let DISCONNECTED = -1

    /**
     * 设备已连接，但还未执行发现服务，通知矢能，设置MTU，还不能收发指令
     */
    static let CONNECTED = 0

    /**
    * 设备已就绪，已执行发现服务，通知矢能，设置MTU，可以正常收发发送指令
    */
    static let READY = 1
}

public class CameraState {
    public static let EXIT = 0
    public static let ENTER = 1
    public static let CAPTURE = 2
    public static let FLIP = 3

    public static func getState(_ state: Int) -> String {
        switch (state) {
        case EXIT:
            return "Exit"
        case ENTER:
            return "Enter"
        case CAPTURE:
            return "Capture"
        case FLIP:
            return "Flip"
        default:
            return "Unknown"
        }
    }
}

public class SyncState {
    public static let DISCONNECTED = -2 // 同步过程中，连接断开
    public static let TIMEOUT = -1 // 同步超时
    public static let COMPLETED = 0 // 同步完成
    public static let SYNCING = 1 // 同步中

    public static func getState(_ state: Int) -> String {
        switch (state) {
        case DISCONNECTED:
            return "Disconnected"
        case TIMEOUT:
            return "Timeout"
        case COMPLETED:
            return "Complete"
        case SYNCING:
            return "Syncing"
        default:
            return "Unknown"
        }
    }
}

public class WorkoutState {
    public static let START = 1
    public static let ONGOING = 2
    public static let PAUSE = 3
    public static let END = 4

    public static func getState(_ state: Int) -> String {
        switch (state) {
        case START:
            return "Start"
        case ONGOING:
            return "Ongoing"
        case PAUSE:
            return "Pause"
        case END:
            return "End"
        default:
            return "Unknown"
        }
    }
}
