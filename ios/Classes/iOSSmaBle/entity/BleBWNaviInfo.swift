//
//  BleBWNaviInfo.swift
//  SmartV3
//
//  Created by Coding on 2023/11/13.
//  Copyright © 2023 CodingIOT. All rights reserved.
//

import UIKit



/// 骑行和步行导航信息
open class BleBWNaviInfo: BleWritable {
    
    /// 导航模式
    public enum NaviMode: Int {
        case WALK = 0x01 //步行
        case BIKE = 0x02 //骑行
    }
    
    /// 导航状态
    public enum NaviState: Int {
        case START = 0 //开始导航
        case GOING = 1 //导航数据更新
        case PAUSE = 2 //暂停导航
        case RESUME = 3 //继续导航
        case END = 4 //结束导航
        case GUIDE_END = 5 //抵达终点
    }
    

    public var mState: NaviState = .START //状态
    public var mTime: Int = 0  // ms
    public var mMode: NaviMode = NaviMode.WALK  //0:步行，1：骑行
    public var mSpeed: Int = 0 //当前速度
    public var mAltitude: Int = 0  //当前海拔
    public var mTurnType: Int = 0 //转向标类型
    public var mRemainTime: String = "" //剩余时间
    public var mRemainDistance: String = "" //剩余距离
    public var mRoadGuide: String = "" //引导信息
    
    
    private static let TIME_MAX_LENGTH = 32 // 名字最大长度，字节数
    private static let DISTANCE_MAX_LENGTH = 32 // 名字最大长度，字节数
    private static let ROAD_MAX_LENGTH = 164 // 名字最大长度，字节数
    override var mLengthToWrite: Int {
        
        return 28 + BleBWNaviInfo.TIME_MAX_LENGTH + BleBWNaviInfo.DISTANCE_MAX_LENGTH + min(mRoadGuide.bytes.count, BleBWNaviInfo.ROAD_MAX_LENGTH)
    }
    
    
    override func encode() {
        super.encode()
        writeInt8(mState.rawValue)
        writeObject(BleTime.ofLocal(mTime))
        writeInt8(mMode.rawValue)
        writeInt32(mSpeed)
        writeInt32(mAltitude)
        writeInt(0)
        writeInt8(mTurnType)
        writeInt8(min(mRemainTime.bytes.count, BleBWNaviInfo.TIME_MAX_LENGTH))
        writeInt8(min(mRemainDistance.bytes.count, BleBWNaviInfo.DISTANCE_MAX_LENGTH))
        writeInt8(min(mRoadGuide.bytes.count, BleBWNaviInfo.ROAD_MAX_LENGTH))
        writeStringWithFix(mRemainTime, BleBWNaviInfo.TIME_MAX_LENGTH)
        writeStringWithFix(mRemainDistance, BleBWNaviInfo.DISTANCE_MAX_LENGTH)
        writeStringWithLimit(mRoadGuide, BleBWNaviInfo.ROAD_MAX_LENGTH, addEllipsis: true)
    }
    
    override func decode() {
        super.decode()
        //目前只需要这个状态
        mState = BleBWNaviInfo.NaviState(rawValue: Int(readInt8())) ?? .END
    }
    
    open override var description: String {
        
        return "BleBWNaviInfo(mState=\(mState), mTime=\(mTime), mMode=\(mMode), mSpeed=\(mSpeed), mAltitude=\(mAltitude), mTurnType=\(mTurnType), mRemainDistance='\(mRemainDistance)', " +
                "mRemainTime='\(mRemainTime)', mRoadGuide='\(mRoadGuide)')"
    }
    
    func bdBikeTurnIconNameToType(turnIconName: String) -> Int {

        var iconBikeType = 5
        switch turnIconName {
        case "bsdk_drawable_rg_ic_turn_front_2branch_left.png":
            iconBikeType = 0
        case "bsdk_drawable_rg_ic_turn_front_2branch_right.png":
            iconBikeType = 1
        case "bsdk_drawable_rg_ic_turn_front_3branch_center.png":
            iconBikeType = 2
        case "bsdk_drawable_rg_ic_turn_front_3branch_left.png":
            iconBikeType = 3
        case "bsdk_drawable_rg_ic_turn_front_3branch_right.png":
            iconBikeType = 4
        case "bsdk_drawable_rg_ic_turn_front_blue.png":
            iconBikeType = 5
        case "bsdk_drawable_rg_ic_turn_goto_leftroad_front_blue.png":
            iconBikeType = 6
        case "bsdk_drawable_rg_ic_turn_goto_leftroad_front.png":
            iconBikeType = 6
        case "bsdk_drawable_rg_ic_turn_goto_leftroad_uturn_blue.png":
            iconBikeType = 7
        case "bsdk_drawable_rg_ic_turn_goto_leftroad_uturn.png":
            iconBikeType = 7
        case "bsdk_drawable_rg_ic_turn_goto_rightroad_front_blue.png":
            iconBikeType = 8
        case "bsdk_drawable_rg_ic_turn_goto_rightroad_front.png":
            iconBikeType = 8
        case "bsdk_drawable_rg_ic_turn_goto_rightroad_uturn_blue.png":
            iconBikeType = 9
        case "bsdk_drawable_rg_ic_turn_goto_rightroad_uturn.png":
            iconBikeType = 9
        case "bsdk_drawable_rg_ic_turn_left_2branch_left.png":
            iconBikeType = 10
        case "bsdk_drawable_rg_ic_turn_left_2branch_right.png":
            iconBikeType = 11
        case "bsdk_drawable_rg_ic_turn_left_3branch_left.png":
            iconBikeType = 12
        case "bsdk_drawable_rg_ic_turn_left_3branch_mid.png":
            iconBikeType = 13
        case "bsdk_drawable_rg_ic_turn_left_3branch_right.png":
            iconBikeType = 14
        case "bsdk_drawable_rg_ic_turn_left_back_blue.png":
            iconBikeType = 15
        case "bsdk_drawable_rg_ic_turn_left_back.png":
            iconBikeType = 15
        case "bsdk_drawable_rg_ic_turn_left_blue.png":
            iconBikeType = 16
        case "bsdk_drawable_rg_ic_turn_left.png":
            iconBikeType = 16
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_front_blue.png":
            iconBikeType = 17
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_front.png":
            iconBikeType = 17
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_back_blue.png":
            iconBikeType = 18
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_back.png":
            iconBikeType = 18
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_blue.png":
            iconBikeType = 19
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_left.png":
            iconBikeType = 19
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_front_blue.png":
            iconBikeType = 20
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_front.png":
            iconBikeType = 20
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_right_blue.png":
            iconBikeType = 21
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_right.png":
            iconBikeType = 21
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_right_front_blue.png":
            iconBikeType = 22
        case "bsdk_drawable_rg_ic_turn_left_diagonal_passroad_right_front.png":
            iconBikeType = 22
        case "bsdk_drawable_rg_ic_turn_left_front_blue.png":
            iconBikeType = 23
        case "bsdk_drawable_rg_ic_turn_left_front.png":
            iconBikeType = 23
        case "bsdk_drawable_rg_ic_turn_left_front_straight_blue.png":
            iconBikeType = 24
//            "bsdk_drawable_rg_ic_turn_left_front_straight.png" -> 24
//            "bsdk_drawable_rg_ic_turn_left_passroad_front_blue.png" -> 25
//            "bsdk_drawable_rg_ic_turn_left_passroad_front.png" -> 25
//            "bsdk_drawable_rg_ic_turn_left_passroad_uturn_blue.png" -> 26
//            "bsdk_drawable_rg_ic_turn_left_passroad_uturn.png" -> 26
//            "bsdk_drawable_rg_ic_turn_passroad_left_blue.png" -> 27
//            "bsdk_drawable_rg_ic_turn_passroad_left.png" -> 27
//            "bsdk_drawable_rg_ic_turn_passroad_right_blue.png" -> 28
//            "bsdk_drawable_rg_ic_turn_passroad_right.png" -> 28
//            "bsdk_drawable_rg_ic_turn_right_2branch_left.png" -> 29
//            "bsdk_drawable_rg_ic_turn_right_2branch_right.png" -> 30
//            "bsdk_drawable_rg_ic_turn_right_3branch_left.png" -> 31
//            "bsdk_drawable_rg_ic_turn_right_3branch_mid.png" -> 32
//            "bsdk_drawable_rg_ic_turn_right_3branch_right.png" -> 33
//            "bsdk_drawable_rg_ic_turn_right_back_blue.png" -> 34
//            "bsdk_drawable_rg_ic_turn_right_back.png" -> 34
//            "bsdk_drawable_rg_ic_turn_right_blue.png" -> 35
//            "bsdk_drawable_rg_ic_turn_right.png" -> 35
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_front_blue.png" -> 36
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_front.png" -> 36
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_left_blue.png" -> 37
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_left.png" -> 37
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_left_front_blue.png" -> 38
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_left_front.png" -> 38
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_back_blue.png" -> 39
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_back.png" -> 39
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_blue.png" -> 40
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_right.png" -> 40
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_front_blue.png" -> 41
//            "bsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_front.png" -> 41
//            "bsdk_drawable_rg_ic_turn_right_front_blue.png" -> 42
//            "bsdk_drawable_rg_ic_turn_right_front.png" -> 42
//            "bsdk_drawable_rg_ic_turn_right_front_straight_blue.png" -> 43
//            "bsdk_drawable_rg_ic_turn_right_front_straight.png" -> 43
//            "bsdk_drawable_rg_ic_turn_right_passroad_front_blue.png" -> 44
//            "bsdk_drawable_rg_ic_turn_right_passroad_front.png" -> 44
//            "bsdk_drawable_rg_ic_turn_right_passroad_uturn_blue.png" -> 45
//            "bsdk_drawable_rg_ic_turn_right_passroad_uturn.png" -> 45
//            else -> 5
        default:
        break
        }
        return iconBikeType
    }

//    fun bdWalkTurnIconNameToType(turnIconName: String): Int {
//        BleLog.d("w -> $turnIconName")
//        return when (turnIconName) {
//            "wsdk_drawable_rg_ic_turn_front.png" -> 0
//            "wsdk_drawable_rg_ic_turn_front_blue.png" -> 1
//            "wsdk_drawable_rg_ic_turn_front_white.png" -> 2
//            "wsdk_drawable_rg_ic_turn_goto_leftroad_front.png" -> 3
//            "wsdk_drawable_rg_ic_turn_goto_leftroad_front_blue.png" -> 4
//            "wsdk_drawable_rg_ic_turn_goto_leftroad_front_white.png" -> 5
//            "wsdk_drawable_rg_ic_turn_goto_leftroad_uturn.png" -> 6
//            "wsdk_drawable_rg_ic_turn_goto_leftroad_uturn_blue.png" -> 7
//            "wsdk_drawable_rg_ic_turn_goto_leftroad_uturn_white.png" -> 8
//            "wsdk_drawable_rg_ic_turn_goto_rightroad_front.png" -> 9
//            "wsdk_drawable_rg_ic_turn_goto_rightroad_front_blue.png" -> 10
//            "wsdk_drawable_rg_ic_turn_goto_rightroad_front_white.png" -> 11
//            "wsdk_drawable_rg_ic_turn_goto_rightroad_uturn.png" -> 12
//            "wsdk_drawable_rg_ic_turn_goto_rightroad_uturn_blue.png" -> 13
//            "wsdk_drawable_rg_ic_turn_goto_rightroad_uturn_white.png" -> 14
//            "wsdk_drawable_rg_ic_turn_left.png" -> 15
//            "wsdk_drawable_rg_ic_turn_left_back.png" -> 16
//            "wsdk_drawable_rg_ic_turn_left_back_blue.png" -> 17
//            "wsdk_drawable_rg_ic_turn_left_back_white.png" -> 18
//            "wsdk_drawable_rg_ic_turn_left_blue.png" -> 19
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_front.png" -> 20
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_front_blue.png" -> 21
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_front_white.png" -> 22
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_left.png" -> 23
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_back.png" -> 24
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_back_blue.png" -> 25
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_back_white.png" -> 26
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_blue.png" -> 27
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_front.png" -> 28
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_front_blue.png" -> 29
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_front_white.png" -> 30
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_left_white.png" -> 31
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_right.png" -> 32
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_right_blue.png" -> 33
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_right_front.png" -> 34
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_right_front_blue.png" -> 35
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_right_front_white.png" -> 36
//            "wsdk_drawable_rg_ic_turn_left_diagonal_passroad_right_white.png" -> 37
//            "wsdk_drawable_rg_ic_turn_left_front.png" -> 38
//            "wsdk_drawable_rg_ic_turn_left_front_blue.png" -> 39
//            "wsdk_drawable_rg_ic_turn_left_front_straight.png" -> 40
//            "wsdk_drawable_rg_ic_turn_left_front_straight_blue.png" -> 41
//            "wsdk_drawable_rg_ic_turn_left_front_straight_white.png" -> 42
//            "wsdk_drawable_rg_ic_turn_left_front_white.png" -> 43
//            "wsdk_drawable_rg_ic_turn_left_passroad_front.png" -> 44
//            "wsdk_drawable_rg_ic_turn_left_passroad_front_blue.png" -> 45
//            "wsdk_drawable_rg_ic_turn_left_passroad_front_white.png" -> 46
//            "wsdk_drawable_rg_ic_turn_left_passroad_uturn.png" -> 47
//            "wsdk_drawable_rg_ic_turn_left_passroad_uturn_blue.png" -> 48
//            "wsdk_drawable_rg_ic_turn_left_passroad_uturn_white.png" -> 49
//            "wsdk_drawable_rg_ic_turn_left_white.png" -> 50
//            "wsdk_drawable_rg_ic_turn_passroad_left.png" -> 51
//            "wsdk_drawable_rg_ic_turn_passroad_left_blue.png" -> 52
//            "wsdk_drawable_rg_ic_turn_passroad_left_white.png" -> 53
//            "wsdk_drawable_rg_ic_turn_passroad_right.png" -> 54
//            "wsdk_drawable_rg_ic_turn_passroad_right_blue.png" -> 55
//            "wsdk_drawable_rg_ic_turn_passroad_right_white.png" -> 56
//            "wsdk_drawable_rg_ic_turn_right.png" -> 57
//            "wsdk_drawable_rg_ic_turn_right_back.png" -> 58
//            "wsdk_drawable_rg_ic_turn_right_back_blue.png" -> 59
//            "wsdk_drawable_rg_ic_turn_right_back_white.png" -> 60
//            "wsdk_drawable_rg_ic_turn_right_blue.png" -> 61
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_front.png" -> 62
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_front_blue.png" -> 63
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_front_white.png" -> 64
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_left.png" -> 65
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_left_blue.png" -> 66
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_left_front.png" -> 67
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_left_front_blue.png" -> 68
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_left_front_white.png" -> 69
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_left_white.png" -> 70
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_right.png" -> 71
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_back.png" -> 72
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_back_blue.png" -> 73
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_back_white.png" -> 74
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_blue.png" -> 75
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_front.png" -> 76
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_front_blue.png" -> 77
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_front_white.png" -> 78
//            "wsdk_drawable_rg_ic_turn_right_diagonal_passroad_right_white.png" -> 79
//            "wsdk_drawable_rg_ic_turn_right_front.png" -> 80
//            "wsdk_drawable_rg_ic_turn_right_front_blue.png" -> 81
//            "wsdk_drawable_rg_ic_turn_right_front_straight.png" -> 82
//            "wsdk_drawable_rg_ic_turn_right_front_straight_blue.png" -> 83
//            "wsdk_drawable_rg_ic_turn_right_front_straight_white.png" -> 84
//            "wsdk_drawable_rg_ic_turn_right_front_white.png" -> 85
//            "wsdk_drawable_rg_ic_turn_right_passroad_front.png" -> 86
//            "wsdk_drawable_rg_ic_turn_right_passroad_front_blue.png" -> 87
//            "wsdk_drawable_rg_ic_turn_right_passroad_front_white.png" -> 88
//            "wsdk_drawable_rg_ic_turn_right_passroad_uturn.png" -> 89
//            "wsdk_drawable_rg_ic_turn_right_passroad_uturn_blue.png" -> 90
//            "wsdk_drawable_rg_ic_turn_right_passroad_uturn_white.png" -> 91
//            "wsdk_drawable_rg_ic_turn_right_white.png" -> 92
//            else -> 0
//        }
//    }
}
