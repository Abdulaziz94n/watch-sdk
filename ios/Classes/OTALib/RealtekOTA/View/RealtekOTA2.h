//
//  RealtekOTA2.h
//  sma_coding_dev_flutter_sdk
//
//  Created by 叩鼎科技 on 2023/4/17.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


/// 执行回调
//typedef void(^RefreshBlock)(NSInteger type,BOOL isConnected,CGFloat pro);
/**
 * OTA upgrade status
 */
typedef NS_ENUM(NSUInteger, ABHRTKOTAStatus) {
    /// 正常情况, 默认值
    ABHRTKOTAStatusNone = 0,
    /// 校验文件
    ABHRTKOTAStatusVerifyFile,
    /// 准备升级中
    ABHRTKOTAStatusReadyForUpgrade,
    /// 升级中...
    ABHRTKOTAStatusDuringUpgrade,
    /// 发送完成, 仅仅代表发送数据完成, 这个状态不能当成升级成功
    ABHRTKOTAStatusDidFinishSending,
    /// 升级成功
    ABHRTKOTAStatusUpgradeSucceed,
    /// OTA升级失败
    ABHRTKOTAStatusUpgradeFailed,
    /// 文件校验失败
    //ABHRTKOTAStatusFileVerificationFailed,
    /// OTA内部问题, 无法升级, 可以理解调用准备升级后, 准备失败, 无法升级
    //ABHRTKOTAStatusCouldNotUpgrade,
};

//// Realtek OTA升级时候, 返回的数据, 进度等等
//struct ABHRTKOTAResult {
//
//    /// 当前OTA 状态
//    ABHRTKOTAStatus status;
//    /// 当前OTA 失败错误消息
//    NSError *error;
//
//    // 文件总字节大小
//    CGFloat totalBytesCount;
//    /// 当前已经发送的字节
//    CGFloat sendBytesCount;
//};


/// 执行回调
typedef void(^ABHRTKOTACallBack)(ABHRTKOTAStatus status, NSError *error, CGFloat totalBytesCount, CGFloat sendBytesCount);

@interface RealtekOTA2 : NSObject

+ (instancetype)sharedInstance;


@property (nonatomic, copy)  NSString * _Nullable uuidString;
@property (nonatomic, copy)  NSString * _Nullable filePath;


/// OTA的回调, 抛信息到UI层
@property (nonatomic, copy) ABHRTKOTACallBack otaCallBack;

/// 开始升级OTA方法 en: Start the upgrade OTA method
/// - Parameters:
///   - per: 需要升级的外设 en:Peripherals that need to be upgraded
///   - path: OTA升级的bin文件路径 en: The bin file path of the OTA upgrade
-(BOOL)startUpgradeWithPeripheral:(CBPeripheral *)per andPath:(NSString *)path;

@end
