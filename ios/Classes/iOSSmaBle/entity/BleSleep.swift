//
// Created by Best Mafen on 2019/9/26.
// Copyright (c) 2019 szabh. All rights reserved.
//

import Foundation

open class BleSleep: BleReadable, NSCopying {
    static let ITEM_LENGTH = 7
    //睡眠状态
    public static let DEEP = 1  //深睡
    public static let LIGHT = 2 //浅睡
    public static let AWAKE = 3 //清醒
    public static let TOTAL_LENGTH = 4  //睡眠总时长 sleep time total length
    public static let DEEP_LENGTH  = 5  //深睡时长 deep sleep time length
    public static let LIGHT_LENGTH = 6  //浅睡时长 light sleep time length
    public static let AWAKE_LENGTH = 7  //清醒时长 awake time length
    /// 零星小睡，固件上暂未定义
    public static let PIECEMEAL = 8
    
    public static let START = 17 //睡眠开始
    public static let END = 34  //睡眠结束-当前无有效定义和使用

    private static let PERIOD = 900 // 秒数
    private static let OFFSET = 60  // 数据偏差范围60秒,之所以添加此数值,是因为数据记录的时间可能存在偏差
    private static let ERROR_DATA = 14400 // 如果任意两条睡眠数据之间存在4小时的空白期,则判定此次睡眠数据无效
    
    public var mTime: Int = 0 // 距离当地2000/1/1 00:00:00的秒数
    public var mMode: Int = 0 // 睡眠状态
    public var mSoft: Int = 0 // 轻动，即睡眠过程中检测到相对轻微的动作
    public var mStrong: Int = 0 // 重动，即睡眠过程中检测到相对剧烈的运动

    /// 协议上是没有这个属性的, 这个仅仅是为了方便处理数据
    public var mLocalTime: TimeInterval {
        get {
            return (Double(mTime) + 946656000.0)
        }
    }
    
    //MARK: - 初始化相关方法
    required public init(_ data: Data? = nil, _ byteOrder: ByteOrder = .BIG_ENDIAN) {
        super.init(data, byteOrder)
    }

    public init(_ time: Int, _ mode: Int, _ soft: Int = 0, _ strong: Int = 0) {
        super.init()
        mTime = time
        mMode = mode
        mSoft = soft
        mStrong = strong
    }

    override func decode() {
        super.decode()
        mTime = Int(readInt32())
        mMode = Int(readUInt8())
        mSoft = Int(readUInt8())
        mStrong = Int(readUInt8())
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        
        let copyModel = BleSleep()
        copyModel.mTime = self.mTime
        copyModel.mMode = self.mMode
        copyModel.mSoft = self.mSoft
        copyModel.mStrong = self.mStrong
        
        return copyModel
    }

    open override var description: String {
        "BleSleep(mTime:\(mTime), mMode:\(mMode), mSoft:\(mSoft), mStrong:\(mStrong), mLocalTime:\(mLocalTime)"
    }
    
    
    //MARK: - 工具方法
    public func toDictionary()->[String:Any]{
        let dic: [String:Any] = [
            "mTime":mTime,
            "mMode":mMode,
            "mSoft":mSoft,
            "mStrong":mStrong
        ]
        return dic
    }
    
    public func dictionaryToObjct(_ dic:[String:Any]) ->BleSleep{

        let newModel = BleSleep()
        if dic.keys.count<1{
            return newModel
        }
        newModel.mTime = dic["mTime"] as? Int ?? 0
        newModel.mMode = dic["mMode"] as? Int ?? 0
        newModel.mSoft = dic["mSoft"] as? Int ?? 0
        newModel.mStrong = dic["mStrong"] as? Int ?? 0
        return newModel
    }

    //MARK: - 计算睡眠相关数据的方法
    /**
     * 处理原始睡眠数据，数据必须是按时间升序排列的
     * algorithmType -> BleCache.shared.mSleepAlgorithmType
     * mSleepAlgorithmType == 0 代表是旧设备
     */
    public class func analyseSleep(origin: [BleSleep],algorithmType:Int = 0) -> [BleSleep] {
        if origin.count < 2 {
            return []
        }
        //原始数据处理,取最后入睡点记录
        var takeLastOrigin :[BleSleep] = []
        for index in 0..<origin.count {
            if origin[index].mMode == START {
                takeLastOrigin.removeAll()
            }
            takeLastOrigin.append(origin[index])
        }
        var hasFallenAsleep = false // 是否有入睡点的数据
        var result: [BleSleep] = []
        //bleLog("测试数据analyseSleep 执行, takeLastOrigin.count=\(takeLastOrigin.count)")
        
        
        if takeLastOrigin.count <= 2 {
            return []
        }
        //bleLog("测试数据analyseSleep 执行Flage = 2")
        //判断数据是否有效
        for index in 0..<takeLastOrigin.count-2{
            if ((takeLastOrigin[index + 1].mTime - takeLastOrigin[index].mTime) >= BleSleep.ERROR_DATA) {
                return []
            }
        }
        if algorithmType == 0 {
    
            for index in 0..<takeLastOrigin.count {
                let sleep = takeLastOrigin[index]
                switch sleep.mMode {
                case BleSleep.START:
                    hasFallenAsleep = true
                    // 有多个入睡点，只保留最后一段，所以把之前的全部清空
                    result.removeAll()
                    // 把入睡拆分成前15分钟浅睡，后面深睡
                    sleep.mMode = BleSleep.LIGHT
                    result.append(sleep)
                    if takeLastOrigin.count > index + 1 {
                        // 如果跟下个点的时间相差15分钟以上，插入一个深睡点
                        if takeLastOrigin[index + 1].mTime - sleep.mTime > BleSleep.PERIOD {
                            result.append(BleSleep(sleep.mTime + BleSleep.PERIOD, BleSleep.DEEP))
                        }
                    }
                    break
                case BleSleep.DEEP:
                    if sleep.mStrong > 2 { // 如果重动>2, 则为清醒
                        if result.isEmpty || sleep.mTime - result.last!.mTime > BleSleep.PERIOD+BleSleep.OFFSET {
                            // 如果跟上个点的时间相差15+1分钟以上，插入一个清醒点
                            result.append(BleSleep(sleep.mTime - BleSleep.PERIOD, BleSleep.AWAKE))
                        } else if !result.isEmpty && sleep.mTime - result.last!.mTime <= BleSleep.PERIOD-BleSleep.OFFSET {
                            // 如果跟上个点的时间相差15-1分钟以内，直接将上个点修改为清醒
                            result.last!.mMode = BleSleep.AWAKE
                        }
                    }else{
                        if sleep.mSoft > 2 { // 重动<=2, 轻动>2, 则为浅睡
                            if result.isEmpty || sleep.mTime - result.last!.mTime > BleSleep.PERIOD {
                                // 如果跟上个点的时间相差15分钟以上，插入一个浅睡点
                                result.append(BleSleep(sleep.mTime - BleSleep.PERIOD, BleSleep.LIGHT))
                            } else if !result.isEmpty && sleep.mTime - result.last!.mTime <= BleSleep.PERIOD {
                                // 如果跟上个点的时间相差15分钟以内，直接将上个点修改为浅睡
                                result.last!.mMode = BleSleep.LIGHT
                            }
                        }else{
                            if (!result.isEmpty && result.last!.mMode == sleep.mMode && (sleep.mTime - result.last!.mTime) > (BleSleep.PERIOD - BleSleep.OFFSET)) {
                                //当相近点都为深睡,且与上一个点记录间隔超过15-1分钟,则将当前点设置为浅睡点并记录
                                result.append(BleSleep(sleep.mTime, BleSleep.LIGHT))
                                                    
                            } else if (result.count > 2 && result.last!.mMode == BleSleep.LIGHT && result[result.count - 2].mMode == BleSleep.DEEP && (sleep.mTime - result.last!.mTime) > (BleSleep.PERIOD - BleSleep.OFFSET)) {
                                                    
                                //如果出现: A点深睡,B点浅睡,且C点与B点相隔在15-1分钟内,而C点传过来的为深睡,那么C点也要强行归类到浅睡
                                result.append(BleSleep(sleep.mTime, BleSleep.LIGHT))
                            } else if (result.isEmpty || result.last!.mMode != sleep.mMode) {
                                result.append(sleep)
                            }
                        }
                    }
                    break
                case BleSleep.LIGHT:
                    if (sleep.mStrong > 2 || sleep.mSoft > 25) {
                        if (result.isEmpty || sleep.mTime - result.last!.mTime > BleSleep.PERIOD) {
                            // 如果跟上个点的时间相差15分钟以上，插入一个清醒点
                            result.append(BleSleep(sleep.mTime - BleSleep.PERIOD, BleSleep.AWAKE))
                        }else if (!result.isEmpty && sleep.mTime - result.last!.mTime <= PERIOD) {
                            // 如果跟上个点的时间相差15分钟以内，直接将上个点修改为清醒
                            result.last!.mMode = AWAKE
                        }
                    } else {
                        //不满足所有判断条件,则就是深睡,直接添加该条记录即可
                        if result.isEmpty || result.last!.mMode != sleep.mMode {
                            result.append(sleep)
                        }
                    }
                    break
                case BleSleep.AWAKE:
                    //清醒数据不做任何判断,直接添加完事
                    if result.isEmpty || result.last!.mMode != sleep.mMode {
                        result.append(sleep)
                    }
                    break
                default:
                    break
                }
            }
            if !hasFallenAsleep && !result.isEmpty {
                result[0].mMode = BleSleep.LIGHT
                if result.count > 1 {
                    // 如果跟下个点的时间相差15分钟以上，插入一个深睡点
                    if result[1].mTime - result[0].mTime > BleSleep.PERIOD {
                        result.insert(BleSleep(result[0].mTime + BleSleep.PERIOD, BleSleep.DEEP), at: 1)
                    }
                }
            }
        }else{
            for index in 0..<takeLastOrigin.count {
                let sleep = takeLastOrigin[index]
                switch sleep.mMode {
                case BleSleep.START:
                    hasFallenAsleep = true
                    // 有多个入睡点，只保留最后一段，所以把之前的全部清空
                    result.removeAll()
                    //入睡后10秒会产生第二状态，所以入睡时的状态数据可以抛弃
                    break
                case BleSleep.DEEP:
                    result.append(sleep)
                    break
                case BleSleep.LIGHT:
                    result.append(sleep)
                    break
                case BleSleep.AWAKE:
                    result.append(sleep)
                    break
                case BleSleep.END:
                    result.append(sleep)
                    break
                case BleSleep.TOTAL_LENGTH,BleSleep.DEEP_LENGTH,BleSleep.LIGHT_LENGTH,BleSleep.AWAKE_LENGTH:
                    result.append(sleep)
                    break
                default:
                    break
                }
            }
            if  hasFallenAsleep == false{
                result.removeAll()
            }
        }
        return result
    }

    /**
     * 获取各个状态的时间，分钟数，数据必须是按时间升序排列的
     * sleeps -> analyseSleep()
     * algorithmType -> BleCache.shared.mSleepAlgorithmType
     */
    public class func getSleepStatusDuration(sleeps: [BleSleep],_ algorithmType :Int = 0) -> [Int: Int] {
        var result: [Int: Int] = [Int: Int]()
        var totalLength = 0
        var deepLength = 0
        var lightLength = 0
        var awakeLength = 0
        for index in 0..<sleeps.count {
            let sleep = sleeps[index]
            if index < sleeps.count - 1 {
                if sleep.mMode == BleSleep.TOTAL_LENGTH && algorithmType == 1{
                    totalLength = sleep.mSoft<<8+sleep.mStrong
                }else if sleep.mMode == BleSleep.DEEP_LENGTH && algorithmType == 1{
                    deepLength = sleep.mSoft<<8+sleep.mStrong
                }else if sleep.mMode == BleSleep.LIGHT_LENGTH && algorithmType == 1{
                    lightLength = sleep.mSoft<<8+sleep.mStrong
                }else if sleep.mMode == BleSleep.AWAKE_LENGTH && algorithmType == 1{
                    awakeLength = sleep.mSoft<<8+sleep.mStrong
                }else{
                    let key = sleep.mMode
                    let duration = (sleeps[index + 1].mTime - sleep.mTime) / 60
                    let keyValue = result[key] ?? 0
                    result[key] = keyValue+duration
                }
            }
        }
        //bleLog("SleepStatus result - \(result)")
        if totalLength>0 {
            result[BleSleep.TOTAL_LENGTH] = totalLength
            result[BleSleep.DEEP] = deepLength
            result[BleSleep.LIGHT] = lightLength
            result[BleSleep.AWAKE] = awakeLength
        }
        return result
    }

    
    
    /// 全天睡眠，从记录中获取到有效的睡眠数据
    /// - Parameters:
    ///   - sleeps: 睡眠数据
    ///   - zeroClockTime: 时间单位毫秒
    public class func analyseSleepAllDay(_ sleeps: [BleSleep], todayStart: TimeInterval, todayEnd: TimeInterval, zeroClockTime: TimeInterval) -> [BleSleep] {
        
        var start = -1//开始索引, 主要是入睡点17的位置
        var end = -1//结束索引
        //let todayStart = Date().startOfDay()
        //let todayEnd = Date().endOfDay()
        //bleLog("查询睡眠开始和结束时间, todayStart:\(todayStart), todayEnd:\(todayEnd)")
        
        
        //先定位大于todayStart附近的入睡数据
        var flagModel: BleSleep?
        for (i, it) in sleeps.enumerated() {
            
            if (it.mLocalTime >= todayStart) {
                flagModel = it
                start = i
                break
            }
        }
        
        //bleLog("analyseSleepAllDay -> start:\(start), flagModel:\(String(describing: flagModel))")
        if (start == -1) {
            return [BleSleep]()
        }
        
        guard var current = flagModel else {
            return [BleSleep]()
        }
        
        //查找第一个入睡点，这里有可能存在没有入睡点的问题
        if (start > 0) {
            var j = start - 1
            repeat {
                current = sleeps[j]
                if (current.mMode == START) {
                    start = j
                    break
                }
                if (current.mMode == END) {
                    break
                }
                j-=1
            } while (j >= 0)
        }
        //bleLog("analyseSleepAllDay -> start:\(start)")
        
        end = sleeps.count
        var i = end - 1
        repeat {
            current = sleeps[i]
            if (current.mLocalTime < todayEnd) {
                if (current.mMode == START) {
                    end = i
                    break
                }
                if (current.mMode == END) {
                    end = i + 1
                    break
                }
            }
            i-=1
        } while (i >= start)
        
        //bleLog("analyseSleepAllDay -> start:\(start) - end:\(end)")
        //主要是把前面和后面无效的数据删除
        return Array(sleeps[start...end])
    }
    
    
    /// 全天睡眠，睡眠数据分段，可能有多段睡眠数据
    class func getSleepAllDaySegments(_ sleeps: [BleSleep]) -> [[BleSleep]] {
        
        var sleepSegments = [[BleSleep]]()
        var tmpList = [BleSleep]()
        
        for (index, bleSleep) in sleeps.enumerated() {
            
            tmpList.append(bleSleep)
            //这里以结束点分组，但可能存在没有结束点的数据
            if (bleSleep.mMode == END//有结束点
                //没有结束点，如果是最后一组且最后一个
                || (!tmpList.isEmpty && index == (sleeps.count - 1))
            ) {
                sleepSegments.append(tmpList)
                tmpList = [BleSleep]()
            }
        }
        return sleepSegments
    }
    
    /// 全天睡眠，获取分段数据各状态的时间(分钟数)，数据必须是按时间升序排列的
    public class func getSleepAllDaySegmentStatus(_ sleeps: [BleSleep]) -> [Int: Int] {
        
        var result = [Int: Int]()
        var piecemeal = 0
        if (sleeps.count == 2//只有两点那种一般都是小睡
            && sleeps[0].mMode == START
            && sleeps[1].mMode == END
        ) {
            piecemeal = sleeps[1].mTime - sleeps[0].mTime
        } else if (sleeps.count > 2) {
            
            for (index, sleep) in sleeps.enumerated() {
                
                let lastIndex = sleeps.count - 1
                if (index < lastIndex) {
                    let mode = sleep.mMode
                    let modeTotal = result[mode] ?? 0
                    let duration = sleeps[index + 1].mTime - sleeps[index].mTime
                    result[mode] = modeTotal + duration
                }
            }
        }
        //一个分段里面要么只有小睡，要么只有长睡
        if (piecemeal > 0) {
            //小睡时长
            result[PIECEMEAL] = piecemeal / 60
        } else {
            //长睡时长
            guard let lastModel = sleeps.last else {
                //bleLog("--getSleepAllDaySegmentStatus sleeps.last == nil")
                return result
            }
            guard let firstModel = sleeps.first else {
                //bleLog("--getSleepAllDaySegmentStatus sleeps.first == nil")
                return result
            }
            
            let total = (lastModel.mTime - firstModel.mTime) / 60
            result[LIGHT] = (result[LIGHT] ?? 0) / 60
            result[DEEP] = (result[DEEP] ?? 0) / 60
            result[AWAKE] = total - (result[LIGHT] ?? 0) - (result[DEEP] ?? 0) //要与固件一致
        }
        
        return result
    }
    
    /// 用于展示睡眠页面各个数据
    /// 全天睡眠，获取各状态总时长, 用于显示时长
    public class func getSleepAllDayStatus(_ sleeps: [BleSleep]) -> [Int: Int] {
        
        let sleepSegments = getSleepAllDaySegments(sleeps)
        var result = [Int: Int]()
        
        for (_, sleepSegment) in sleepSegments.enumerated() {
            
            let tmpStatus = getSleepAllDaySegmentStatus(sleepSegment)
            let light = tmpStatus[LIGHT] ?? 0
            let deep = tmpStatus[DEEP] ?? 0
            let awake = tmpStatus[AWAKE] ?? 0
            let piecemeal = tmpStatus[PIECEMEAL] ?? 0
            result[LIGHT] = (result[LIGHT] ?? 0) + light
            result[DEEP] = (result[DEEP] ?? 0) + deep
            result[AWAKE] = (result[AWAKE] ?? 0) + awake
            result[PIECEMEAL] = (result[PIECEMEAL] ?? 0) + piecemeal
            
            //bleLog("getSleepAllDayStatus -> index:\(index), result\(result)")
        }
        
        return result
    }
    
    
    /// 全天睡眠，获取睡眠视图数据，用于画图
    public class func getSleepAllDayViewDatas(_ sleeps: [BleSleep]) -> [BleSleep] {
        
        var viewDatas = [BleSleep]()
        let sleepSegments = getSleepAllDaySegments(sleeps)
        
        for sleepSegment in sleepSegments {
            
            let status = getSleepAllDaySegmentStatus(sleepSegment)
            let piecemeal = status[PIECEMEAL] ?? 0
            if (piecemeal > 0) {
                //viewDatas.append(sleepSegment[0].copy(mMode = START))
                let firstM = sleepSegment[0].copy() as! BleSleep
                firstM.mMode = START
                viewDatas.append(firstM)
                
                for it in sleepSegment {
                    let flagM = it.copy() as! BleSleep
                    flagM.mMode = PIECEMEAL
                    viewDatas.append(flagM)
                }
                
                let lastM = sleepSegment[1].copy() as! BleSleep
                lastM.mMode = END
                viewDatas.append(lastM)
            } else {
                for it in sleepSegment {
                    viewDatas.append(it)
                }
            }
        }
        return viewDatas
    }
}
