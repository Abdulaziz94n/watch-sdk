//
//  BleNaviInfo.swift
//  SmartV3
//
//  Created by 叩鼎科技 on 2023/8/15.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit

/// 导航状态
public enum BleNavigationState: Int {

    /// 开始导航
    case NAVI_START = 0
    /// 导航数据更新
    case NAVI_GOING = 1
    /// 暂停导航
    case NAVI_PAUSE = 2
    /// 继续导航
    case NAVI_RESUME = 3
    /// 结束导航
    case NAVI_END = 4
}

/// 转向标类型
/// 具体查看下面的链接
/// https://lbsyun.baidu.com/index.php?title=vehicle-opencontrol/guide/datatransmission
public enum BleNavTurnType: Int {
    
    case TURN_ALONG = 0
    case TURN_BACK = 1
    case TURN_BACK_2BRANCH_LEFT = 2
    case TURN_BACK_2BRANCH_RIGHT = 3
    case TURN_BACK_3BRANCH_CENTER = 4
    case TURN_BACK_3BRANCH_LEFT = 5
    case TURN_BACK_3BRANCH_RIGHT = 6
    case TURN_BRANCH_CENTER = 7
    case TURN_BRANCH_LEFT = 8
    case TURN_BRANCH_LEFT_STRAIGHT = 9
    case TURN_BRANCH_RIGHT = 10
    case TURN_BRANCH_RIGHT_STRAIGHT = 11
    case TURN_DEST = 12
    case TURN_FRONT = 13
    case TURN_INFERRY = 14
    case TURN_LB_2BRANCH_LEFT = 15
    case TURN_LB_2BRANCH_RIGHT = 16
    case TURN_LB_3BRANCH_CENTER = 17
    case TURN_LB_3BRANCH_LEFT = 18
    case TURN_LB_3BRANCH_RIGHT = 19
    case TURN_LEFT = 20
    case TURN_LEFT_BACK = 21
    case TURN_LEFT_FRONT = 22
    case TURN_LEFT_SIDE = 23
    case TURN_LEFT_SIDE_IC = 24
    case TURN_LEFT_SIDE_MAIN = 25
    case TURN_LF_2BRANCH_LEFT = 26
    case TURN_LF_2BRANCH_RIGHT = 27
    case TURN_RB_2BRANCH_LEFT = 28
    case TURN_RB_2BRANCH_RIGHT = 29
    case TURN_RB_3BRANCH_CENTER = 30
    case TURN_RB_3BRANCH_LEFT = 31
    case TURN_RB_3BRANCH_RIGHT = 32
    case TURN_RF_2BRANCH_LEFT = 33
    case TURN_RF_2BRANCH_RIGHT = 34
    case TURN_RIGHT = 35
    case TURN_RIGHT_BACK = 36
    case TURN_RIGHT_FRONT = 37
    case TURN_RIGHT_SIDE = 38
    case TURN_RIGHT_SIDE_IC = 39
    case TURN_RIGHT_SIDE_MAIN = 40
    case TURN_RING = 41
    case TURN_RING_FRONT = 42
    case TURN_RING_LEFT = 43
    case TURN_RING_LEFTBACK = 44
    case TURN_RING_LEFTFRONT = 45
    case TURN_RING_RIGHT = 46
    case TURN_RING_RIGHTBACK = 47
    case TURN_RING_RIGHTFRONT = 48
    case TURN_RING_TURNBACK = 49
}



open class BleNaviInfo: BleWritable {
    
    /// 状态
    var mState: BleNavigationState = BleNavigationState.NAVI_START
    var mTime: Int = 0  // ms
    /// 转向标类型
    var mTurnType: BleNavTurnType = BleNavTurnType.TURN_ALONG
    /// 剩余距离, 单位米
    var mRemainDistance: Int = 0
    /// 剩余时间, 单位秒
    var mRemainTime: Int = 0
    /// 距离下一个路口距离 ,单位米
    var mDistance: Int = 0
    /// 当前速度，km/h
    var mSpeed: Int = 0
    /// 下一个路口名字
    var mRoadName: String = ""
    
    /// 名字最大长度，字节数
    static let NAME_MAX_LENGTH = 232
    
    
    open override var description: String {
        "BleNaviInfo(mState:\(mState), mTime:\(mTime), mTurnType:\(mTurnType), mRemainDistance:\(mRemainDistance), " +
        "mRemainTime:\(mRemainTime), mDistance:\(mDistance), mSpeed:\(mSpeed), mRoadName:\(mRoadName)"
    }
    
    override var mLengthToWrite: Int {
        return 24 + min(mRoadName.bytes.count, BleNaviInfo.NAME_MAX_LENGTH)
    }

    override func encode() {
        super.encode()
        writeInt8(mState.rawValue)
        writeObject(BleTime.ofLocal(mTime))
        writeInt8(mTurnType.rawValue)
        writeInt32(mRemainDistance)
        writeInt32(mRemainTime)
        writeInt32(mDistance)
        writeInt8(mSpeed)
        writeInt8(0)//保留
        writeInt16(min(mRoadName.bytes.count, BleNaviInfo.NAME_MAX_LENGTH))
        writeStringWithLimit(mRoadName, BleNaviInfo.NAME_MAX_LENGTH)
    }

    override func decode() {
        super.decode()
        //目前只需要这个状态
        mState = BleNavigationState(rawValue: Int(readInt8())) ?? .NAVI_START
    }
    
    /**
     * https://lbsyun.baidu.com/index.php?title=vehicle-opencontrol/guide/datatransmission
     */
    func bdTurnIconNameToType(_ turnIconName: String) -> BleNavTurnType {
        
        var turnType = BleNavTurnType.TURN_ALONG
        switch turnIconName {
        case "turn_along.png":
            turnType = .TURN_ALONG
        case "turn_back.png":
            turnType = .TURN_BACK
        case "turn_back_2branch_left.png":
            turnType = .TURN_BACK_2BRANCH_LEFT
        case "turn_back_2branch_right.png":
            turnType = .TURN_BACK_2BRANCH_RIGHT
        case "turn_back_3branch_center.png":
            turnType = .TURN_BACK_3BRANCH_CENTER
        case "turn_back_3branch_left.png":
            turnType = .TURN_BACK_3BRANCH_LEFT
        case "turn_back_3branch_right.png":
            turnType = .TURN_BACK_3BRANCH_RIGHT
        case "turn_branch_center.png":
            turnType = .TURN_BRANCH_CENTER
        case "turn_branch_left.png":
            turnType = .TURN_BRANCH_LEFT
        case "turn_branch_left_straight.png":
            turnType = .TURN_BRANCH_LEFT_STRAIGHT
        case "turn_branch_right.png":
            turnType = .TURN_BRANCH_RIGHT
        case "turn_branch_right_straight.png":
            turnType = .TURN_BRANCH_RIGHT_STRAIGHT
        case "turn_dest.png":
            turnType = .TURN_DEST
        case "turn_front.png":
            turnType = .TURN_FRONT
        case "turn_inferry.png":
            turnType = .TURN_INFERRY
        case "turn_lb_2branch_left.png":
            turnType = .TURN_LB_2BRANCH_LEFT
        case "turn_lb_2branch_right.png":
            turnType = .TURN_LB_2BRANCH_RIGHT
        case "turn_lb_3branch_center.png":
            turnType = .TURN_LB_3BRANCH_CENTER
        case "turn_lb_3branch_left.png":
            turnType = .TURN_LB_3BRANCH_LEFT
        case "turn_lb_3branch_right.png":
            turnType = .TURN_LB_3BRANCH_RIGHT
        case "turn_left.png":
            turnType = .TURN_LEFT
        case "turn_rb_3branch_center.png":
            turnType = .TURN_RB_3BRANCH_CENTER
        case "turn_left_back.png":
            turnType = .TURN_LEFT_BACK
        case "turn_left_front.png":
            turnType = .TURN_LEFT_FRONT
        case "turn_left_side.png":
            turnType = .TURN_LEFT_SIDE
        case "turn_left_side_ic.png":
            turnType = .TURN_LEFT_SIDE_IC
        case "turn_left_side_main.png":
            turnType = .TURN_LEFT_SIDE_MAIN
        case "turn_lf_2branch_left.png":
            turnType = .TURN_LF_2BRANCH_LEFT
        case "turn_lf_2branch_right.png":
            turnType = .TURN_LF_2BRANCH_RIGHT
        case "turn_rb_2branch_left.png":
            turnType = .TURN_RB_2BRANCH_LEFT
        case "turn_rb_2branch_right.png":
            turnType = .TURN_RB_2BRANCH_RIGHT
        case "turn_rb_3branch_left.png":
            turnType = .TURN_RB_3BRANCH_LEFT
        case "turn_rb_3branch_right.png":
            turnType = .TURN_RB_3BRANCH_RIGHT
        case "turn_rf_2branch_left.png":
            turnType = .TURN_RF_2BRANCH_LEFT
        case "turn_rf_2branch_right.png":
            turnType = .TURN_RF_2BRANCH_RIGHT
        case "turn_right.png":
            turnType = .TURN_RIGHT
        case "turn_right_back.png":
            turnType = .TURN_RIGHT_BACK
        case "turn_right_front.png":
            turnType = .TURN_RIGHT_FRONT
        case "turn_right_side.png":
            turnType = .TURN_RIGHT_SIDE
        case "turn_right_side_ic.png":
            turnType = .TURN_RIGHT_SIDE_IC
        case "turn_right_side_main.png":
            turnType = .TURN_RIGHT_SIDE_MAIN
        case "turn_ring.png":
            turnType = .TURN_RING
        case "turn_ring_front.png":
            turnType = .TURN_RING_FRONT
        case "turn_ring_left.png":
            turnType = .TURN_RING_LEFT
        case "turn_ring_leftback.png":
            turnType = .TURN_RING_LEFTBACK
        case "turn_ring_leftfront.png":
            turnType = .TURN_RING_LEFTFRONT
        case "turn_ring_right.png":
            turnType = .TURN_RING_RIGHT
        case "turn_ring_rightback.png":
            turnType = .TURN_RING_RIGHTBACK
        case "turn_ring_rightfront.png":
            turnType = .TURN_RING_RIGHTFRONT
        case "turn_ring_turnback.png":
            turnType = .TURN_RING_TURNBACK
        default:
            break
        }
        return turnType
    }

}
