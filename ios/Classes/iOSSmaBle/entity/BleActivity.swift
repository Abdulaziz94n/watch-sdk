//
// Created by Best Mafen on 2019/9/26.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

open class BleActivity: BleReadable {
    static let ITEM_LENGTH = 16

    // 以下三种为自动识别的模式，没有开始、暂停、结束等状态
    public static let AUTO_NONE = 1
    public static let AUTO_WALK = 2
    public static let AUTO_RUN = 3

    // 以下为手动锻炼模式 -- mMode定义
    public static let RUNNING = 7     // 跑步
    public static let INDOOR = 8      // 室内运动，跑步机
    public static let OUTDOOR = 9     // 户外运动
    public static let CYCLING = 10    // 骑行
    public static let SWIMMING = 11   // 游泳
    public static let WALKING = 12    // 步行，健走
    public static let CLIMBING = 13   // 爬山
    public static let YOGA = 14       // 瑜伽
    public static let SPINNING = 15   // 动感单车
    public static let BASKETBALL = 16 // 篮球
    public static let FOOTBALL = 17   // 足球
    public static let BADMINTON = 18  // 羽毛球
    public static let MARATHON = 19    // 马拉松    未查到
    public static let INDOOR_WALK = 20   // 室内步行
    public static let FREE_TRAINING = 21   // 自由锻炼
    public static let WEIGHTTRANNING = 23  // 力量训练
    public static let WEIGHTLIFTING = 24   // 举重
    public static let BOXING = 25         // 拳击
    public static let JUMP_ROPE = 26      // 跳绳
    public static let CLIMB_STAIRS = 27   // 爬楼梯
    public static let SKI = 28            // 滑雪
    public static let SKATE = 29          // 滑冰
    public static let ROLLER_SKATING = 30  // 轮滑
    public static let HULA_HOOP = 32         // 呼啦圈
    public static let GOLF = 33              // 高尔夫
    public static let BASEBALL = 34          // 棒球
    public static let DANCE = 35             // 舞蹈
    public static let PING_PONG = 36         // 乒乓球
    public static let HOCKEY = 37            // 曲棍球
    public static let PILATES = 38           // 普拉提
    public static let TAEKWONDO = 39         // 跆拳道
    public static let HANDBALL = 40          // 手球
    public static let DANCE_STREET = 41     // 街舞
    public static let VOLLEYBALL = 42        // 排球
    public static let TENNIS = 43            // 网球
    public static let DARTS = 44             // 飞镖
    public static let GYMNASTICS = 45        // 体操
    public static let STEPPING = 46          // 踏步
    public static let ELLIPIICAL = 47          // 椭圆机
    public static let ZUMBA = 48          // 尊巴
    public static let CRICHKET = 49 // 板球
    public static let TREKKING = 50          // 徒步旅行        6 MET/70Kg/60分钟/441千卡
    public static let AEROBICS = 51          // 有氧运动        5.8 MET/70Kg/60分钟/408千卡
    public static let ROWING_MACHINE = 52    // 划船机          12 MET/70Kg/60分钟/840千卡
    public static let RUGBY = 53             // 橄榄球          8 MET/70Kg/60分钟/560千卡
    public static let SIT_UP = 54            // 仰卧起坐        8 MET/70KG/60分钟/560千卡
    public static let DUM_BLE = 55           // 哑铃            3 MET/70KG/60分钟/210千卡
    public static let BODY_EXERCISE = 56     // 健身操          4.7 MET/70KG/60分钟/327千卡
    public static let KARATE = 57            // 空手道          10 MET/70KG/60分钟/700千卡
    public static let FENCING = 58           // 击剑            6 MET/70KG/60分钟/420千卡
    public static let MARTIAL_ARTS = 59      // 武术            13.2 MET/70KG/60分钟/922千卡
    public static let TAI_CHI = 60           // 太极拳          4 MET/70KG/60分钟/280千卡
    public static let FRISBEE = 61           // 飞盘            3 MET/70KG/60分钟/220千卡
    public static let ARCHERY = 62           // 射箭            4 MET/70KG/60分钟/294千卡
    public static let HORSE_RIDING = 63      // 骑马            4 MET/70KG/60分钟/294千卡
    public static let BOWLING = 64           // 保龄球          4 MET/70KG/60分钟/294千卡
    public static let SURF = 65              // 冲浪            3 MET/70KG/60分钟/220千卡
    public static let SOFTBALL = 66         // 垒球            5 MET/70KG/60分钟/368千卡
    public static let SQUASH = 67            // 壁球            8 MET/70KG/60分钟/588千卡
    public static let SAILBOAT = 68          // 帆船            3 MET/70KG/60分钟/220千卡
    public static let PULL_UP = 69           // 引体向上        8 MET/70KG/60分钟/560千卡
    public static let SKATEBOARD = 70        // 滑板            5 MET/70KG/60分钟/350千卡
    public static let TRAMPOLINE = 71        // 蹦床            6 MET/70KG/60分钟/441千卡
    public static let FISHING = 72           // 钓鱼            3 MET/70KG/60分钟/220千卡
    public static let POLE_DANCING = 73      // 钢管舞          6 MET/70KG/60分钟/441千卡
    public static let SQUARE_DANCE = 74      // 广场舞          3 MET/70KG/60分钟/210千卡
    public static let JAZZ_DANCE = 75        // 爵士舞          4.8 MET/70KG/60分钟/336千卡
    public static let BALLET = 76            // 芭蕾舞          4.8 MET/70KG/60分钟/336千卡
    public static let DISCO = 77             // 迪斯科          4.5 MET/70KG/60分钟/420千卡
    public static let TAP_DANCE = 78         // 踢踏舞          4.8 MET/70KG/60分钟/336千卡
    public static let MODERN_DANCE = 79      // 现代舞          4.8 MET/70KG/60分钟/336千卡
    public static let PUSH_UPS = 80          // 俯卧撑          8 MET/70KG/60分钟/560千卡
    public static let SCOOTER = 81           // 滑板车          7 MET/70KG/60分钟/490千卡
    public static let PLANK = 82              // 平板支撑        3.3 MET/70KG/60分钟/228千卡
    public static let BILLIARDS = 83          // 桌球            2.5 MET/70KG/60分钟/175千卡
    public static let ROCK_CLIMBING = 84      // 攀岩            11 MET/70KG/60分钟/770千卡
    public static let DISCUS = 85             // 铁饼            4 MET/70KG/60分钟/280千卡
    public static let RACE_RIDING = 86        // 赛马            10 MET/70KG/60分钟/700千卡
    public static let WRESTLING = 87          // 摔跤            6 MET/70KG/60分钟/420千卡
    public static let HIGH_JUMP = 88          // 跳高            6 MET/70KG/60分钟/420千卡
    public static let PARACHUTE = 89          // 跳伞            3.5 MET/70KG/60分钟/245千卡
    public static let SHOT_PUT = 90           // 铅球            4 MET/70KG/60分钟/280千卡
    public static let LONG_JUMP = 91          // 跳远            6 MET/70KG/60分钟/420千卡
    public static let JAVELIN = 92            // 标枪            6 MET/70KG/60分钟/420千卡
    public static let HAMMER = 93             // 链球            4 MET/70KG/60分钟/280千卡
    public static let SQUAT = 94              // 深蹲            4 MET/70KG/60分钟/280千卡
    public static let LEG_PRESS = 95          // 压腿            2.5 MET/70KG/60分钟/175千卡
    public static let OFF_ROAD_BIKE = 96      // 越野自行车      8.3 MET/70KG/60分钟/581千卡
    public static let MOTOCROSS = 97          // 越野摩托车      4 MET/70KG/60分钟/280千卡
    public static let ROWING = 98             // 赛艇            8 MET/70KG/60分钟/588千卡
    public static let CROSSFIT = 99           // CROSSFIT        7 MET/70KG/60分钟/514千卡 通过多种以自身重量、负重 为主的高次数、快速、爆发力的动作增强自己的体能和运动能力
    public static let WATER_BIKE = 100        // 水上自行车      4 MET/70KG/60分钟/294千卡
    public static let KAYAK = 101             // 皮划艇          5 MET/70KG/60分钟/368千卡
    public static let CROQUET = 102           // 槌球            2.5 MET/70KG/60分钟/175千卡
    public static let FLOOR_BALL = 103        // 地板球          6 MET/70KG/60分钟/441千卡 （福乐球 FLOORBALL） 软式曲棍球
    public static let THAI = 104            // 泰拳            7 MET/70KG/514 280千卡
    public static let JAI_BALL = 105         // 回力球          12 MET/70KG/60分钟/840千卡
    public static let TENNIS_DOUBLES = 106    // 网球(双打)      6 MET/70KG/60分钟/420千卡
    public static let BACK_TRAINING = 107     // 背部训练        3.5 MET/70KG/60分钟/245千卡
    public static let WATER_VOLLEYBALL = 108  // 水上排球        3 MET/70KG/60分钟/210千卡
    public static let WATER_SKIING = 109      // 滑水            6 MET/70KG/60分钟/420千卡
    public static let MOUNTAIN_CLIMBER = 110  // 登山机          8 MET/70KG/60分钟/588千卡
    public static let HIIT = 111              // HIIT            7 MET/70KG/60分钟/514千卡  高强度间歇性训练
    public static let BODY_COMBAT = 112      // BODY COMBAT     7 MET/70KG/60分钟/514千卡  搏击（拳击）的一种
    public static let BODY_BALANCE = 113      // BODY BALANCE    7 MET/70KG/60分钟/514千卡  瑜伽、太极和普拉提融合在一起的身心训练项目
    public static let TRX = 114               // TRX             7 MET/70KG/60分钟/514千卡 全身抗阻力锻炼 全身抗阻力锻炼
    public static let TAE_BO = 115 // 跆搏（TAE BO）   7 MET/70KG/60分钟/514千卡 集跆拳道、空手道、拳击、自由搏击、舞蹈韵律操为一体
    public static let GAME = 116   // 游戏
    // 手动锻炼模式下的状态 -- mState定义
    public static let BEGIN = 0 // 开始
    public static let ONGOING = 1 // 进行中
    public static let PAUSE = 2 // 暂停
    public static let RESUME = 3 // 继续
    public static let END = 4 // 结束

    public var mTime: Int = 0 // 距离当地2000/1/1 00:00:00的秒数
    public var mMode: Int = 0 //运动模式，可参考 mMode的定义
    public var mState: Int = 0  //运动状态，可参考 mState定义
    public var mStep: Int = 0  //步数，例如值为10，即代表走了10步
    public var mCalorie: Int = 0  // 1/10000千卡，例如接收到的数据为56045，则代表 5.6045 Kcal 约等于 5.6 Kcal
    public var mDistance: Int = 0 // 1/10000米，例如接收到的数据为56045，则代表移动距离 5.6045 米 约等于 5.6 米

    override func decode() {
        super.decode()
        mTime = Int(readInt32())
        mMode = Int(readUIntN(5))
        mState = Int(readUIntN(3))
        mStep = Int(readUInt24())
        mCalorie = Int(readUInt32())
        mDistance = Int(readUInt32())
    }

    open override var description: String {
        "BleActivity(mTime: \(mTime), mMode: \(mMode), mState: \(mState), mStep: \(mStep), mCalorie: \(mCalorie), mDistance: \(mDistance))"
    }
    
    public func toDictionary()->[String:Any]{
        let dic : [String : Any] = ["mTime":mTime,
                                    "mMode":mMode,
                                    "mState":mState,
                                    "mStep":mStep,
                                    "mCalorie":mCalorie,
                                    "mDistance":mDistance]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleActivity{

        let newModel = BleActivity()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mTime = dic["mTime"] as? Int ?? 0
        newModel.mMode = dic["mMode"] as? Int ?? 0
        newModel.mState = dic["mState"] as? Int ?? 0
        newModel.mStep = dic["mStep"] as? Int ?? 0
        newModel.mCalorie = dic["mCalorie"] as? Int ?? 0
        newModel.mDistance = dic["mDistance"] as? Int ?? 0
        return newModel
    }
}
