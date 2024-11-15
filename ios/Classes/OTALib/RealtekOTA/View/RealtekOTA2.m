//
//  RealtekOTA2.m
//  sma_coding_dev_flutter_sdk
//
//  Created by 叩鼎科技 on 2023/4/17.
//

#import "RealtekOTA2.h"
#import <RTKOTASDK/RTKOTASDK.h>
#import <RTKLEFoundation/RTKLEFoundation.h>

@interface RealtekOTA2 () <RTKDFUUpgradeDelegate>

@property (nonatomic) RTKDFUUpgrade *upgradeTask;

@property NSArray <RTKOTAUpgradeBin*> *packBins;
@property NSArray <RTKOTAUpgradeBin*> *primaryBins;
@property NSArray <RTKOTAUpgradeBin*> *secondaryBins;

@end


@implementation RealtekOTA2


+ (instancetype)sharedInstance {
    static RealtekOTA2 *_sharedOption;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedOption = [RealtekOTA2 new];
    });
    return _sharedOption;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 重要的方法, 开始OTA升级方法, 里面包含校验文件和调用开始OTAF方法
-(BOOL)startUpgradeWithPeripheral:(CBPeripheral *)per andPath:(NSString *)path{
    
    [RTKLog setLogLevel:RTKLogLevelVerbose];
    
    NSError *error = [self checkFileWithPath:path];
    if (error) {
        NSLog(@"获取OTA bin文件失败error:%@", error);
        
        self.otaCallBack(ABHRTKOTAStatusUpgradeFailed, error, 0, 0);
        return NO;
    }
    
    
    [self execOTAwithPeripheral:per];
     
    return YES;
}

// 执行具体的OTA升级
-(void)execOTAwithPeripheral:(CBPeripheral *)per {
    
    
    //self.selectedDevice = self.discoveredPeripheralConnections[indexPath.row];
    //[SVProgressHUD showWithStatus:@"Connecting..."];
    
    
    self.upgradeTask = [[RTKDFUUpgrade alloc] initWithPeripheral:per];
    self.upgradeTask.delegate = self;
    
    [self.upgradeTask prepareForUpgrade];
}

-(NSError *)checkFileWithPath:(NSString *)path {
    
    NSError *objError;
    if (self.upgradeTask.deviceInfo.isRWSMember) {
        
        NSArray <RTKOTAUpgradeBin*> *primaryBins, *secondaryBins;
        NSError *cusErr = [RTKOTAUpgradeBin extractCombinePackFileWithFilePath:path toPrimaryBudBins:&primaryBins secondaryBudBins:&secondaryBins];
        if (!cusErr) {
            self.primaryBins = primaryBins;
            self.secondaryBins = secondaryBins;
        } else {
            RTKLogDebug(@"cusErr:%@",cusErr);
            objError = cusErr;
        }
    } else {
        
        NSError *cusErr_2;
        self.packBins = [RTKOTAUpgradeBin imagesExtractedFromMPPackFilePath:path error:&cusErr_2];
        
        if (cusErr_2) {
            RTKLogDebug(@"cusErr_2:%@",cusErr_2);
            objError = cusErr_2;
        }
        if (self.packBins.count == 1 && !self.packBins.lastObject.ICDetermined) {
            [self.packBins.lastObject assertAvailableForPeripheralInfo:self.upgradeTask.deviceInfo];
        } else {
            
            NSString *errStr = [NSString stringWithFormat:@"packBinsCount:%lu  ICDetermined:%d", (unsigned long)self.packBins.count, self.packBins.lastObject.ICDetermined];
            RTKLogDebug(@"execFileWithPath bin Path Error");
            objError = [[NSError alloc] initWithDomain: NSCocoaErrorDomain code:-1001 userInfo:@{@"customerError": errStr}];
        }
    }
    
    return objError;
}


#pragma mark - RTKDFUUpgradeDelegate
- (void)DFUUpgradeDidReadyForUpgrade:(RTKDFUUpgrade *)task{
    
    // 升级已经准备好了的回调
    NSLog(@"升级已经准备好了的回调");
    
    self.otaCallBack(ABHRTKOTAStatusReadyForUpgrade, nil, 0, 0);
    
    // 设置升级模式为普通升级
    [(RTKDFUUpgradeGATT*)self.upgradeTask setPrefersUpgradeUsingOTAMode:YES];
    
    self.upgradeTask.batteryLevelLimit = 0; //电量检查
    // 下面两个是:是否, 严格检查升级文件版本
    self.upgradeTask.olderImageAllowed = YES;
    self.upgradeTask.usingStrictImageCheckMechanism = NO;
    
    if (self.upgradeTask.deviceInfo.isRWSMember) {
        [self.upgradeTask upgradeWithImagesForPrimaryBud:self.primaryBins imagesForSecondaryBud:self.secondaryBins];
    } else {
        
        [self.upgradeTask upgradeWithImages:self.packBins];
    }
}

// 无法升级
- (void)DFUUpgrade:(RTKDFUUpgrade *)task couldNotUpgradeWithError:(NSError *)error{
    
    NSLog(@"无法升级 error:%@", error);
    self.otaCallBack(ABHRTKOTAStatusUpgradeFailed, error, 0, 0);
}

//---------------
- (void)DFUUpgrade:(RTKDFUUpgrade *)task isAboutToSendImageBytesTo:(RTKProfileConnection *)connection withContinuationHandler:(void(^)(void))continuationHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        continuationHandler();
    });
}


- (void)DFUUpgrade:(RTKDFUUpgrade *)task
        withDevice:(RTKProfileConnection *)connection
 didSendBytesCount:(NSUInteger)length
           ofImage:(RTKOTAUpgradeBin *)image {
    
    NSString *resStr = [NSString stringWithFormat:@"Upgrading %@ image (%ld/%ld)", image.name, length, image.data.length];
    NSLog(@"didSendBytesCount resStr:%@", resStr);
    
    self.otaCallBack(ABHRTKOTAStatusDuringUpgrade, nil, image.data.length, length);
}

/// 即将发送文件
- (void)DFUUpgrade:(RTKDFUUpgrade *)task withDevice:(RTKProfileConnection *)connection willSendImage:(RTKOTAUpgradeBin *)image {
    
    //self.progressLabel.text = [NSString stringWithFormat:@"Sending %@", image.name];
    NSString *resStr = [NSString stringWithFormat:@"Sending %@", image.name];
    NSLog(@"withDevice resStr:%@", resStr);
}

// 升级完成
- (void)DFUUpgrade:(RTKDFUUpgrade *)task withDevice:(RTKProfileConnection *)connection didCompleteSendImage:(RTKOTAUpgradeBin *)image {
    
    //self.progressLabel.text = [NSString stringWithFormat:@"Did finish send %@", image.name];
    //self.upgradeProgress.progress = task.progress.fractionCompleted;
    
    NSString *resStr = [NSString stringWithFormat:@"Did finish send %@", image.name];
    NSLog(@"didCompleteSendImage resStr:%@  progress:%.2f", resStr, task.progress.fractionCompleted);
    
    self.otaCallBack(ABHRTKOTAStatusDidFinishSending, nil, image.data.length, image.data.length);
}


- (void)DFUUpgrade:(RTKDFUUpgrade *)task withDevice:(RTKProfileConnection *)connection didActivateImages:(NSSet<RTKOTAUpgradeBin*>*)images {
    
    //self.progressLabel.text = [NSString stringWithFormat:@"Activate images"];
    NSString *resStr = [NSString stringWithFormat:@"Activate images"];
    NSLog(@"didActivateImages resStr:%@", resStr);
}

/**
  * 告诉代理升级是否成功完成。
  *
  * @param task 报告此事件的升级任务。
  * @param error 表示升级失败的错误对象，或者为nil表示升级成功。
  *
  * @discussion 检查error参数值是否为nil，判断升级是否成功。 通常，设备会重新启动以使用新图像，从而导致断开连接。
  */
- (void)DFUUpgrade:(RTKDFUUpgrade *)task didFinishUpgradeWithError:(nullable NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            
            //self.progressLabel.text = @"Upgrade failed";
            NSString *resStr = [NSString stringWithFormat:@"Upgrade failed"];
            NSLog(@"didFinishUpgradeWithError resStr:%@ Error:%@", resStr, error);
            
            self.otaCallBack(ABHRTKOTAStatusUpgradeFailed, error, 0, 0);
            
            //UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERROR" message:error.description preferredStyle:UIAlertControllerStyleActionSheet];
            //UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            //[alertController addAction:confirmAction];
            //[self presentViewController:alertController animated:YES completion:nil];
        } else {
            
            //self.progressLabel.text = @"Upgrade Success";
            NSString *resStr = [NSString stringWithFormat:@"Upgrade Success"];
            NSLog(@"didFinishUpgradeWithError resStr:%@", resStr);
            
            self.otaCallBack(ABHRTKOTAStatusUpgradeSucceed, nil, 0, 0);
        }
        
        //[SVProgressHUD dismissWithDelay:2.0 completion:^{
        //    OTADemoViewController *homeView = [self.navigationController.viewControllers objectAtIndex:0];
        //    if ([homeView respondsToSelector:@selector(setUpgradeTask:)]) {
        //        [homeView setUpgradeTask:nil];
        //    }
        //    [self.navigationController popViewControllerAnimated:YES];
        //}];
    });
}

- (void)DFUUpgradeDidFinishFirstDeviceAndPrepareCompanionDevice:(RTKDFUUpgrade *)task {
    
    //self.progressLabel.text = @"Connecting to companion device";
    NSString *resStr = @"Connecting to companion device";
    NSLog(@"DFUUpgradeDidFinishFirstDeviceAndPrepareCompanionDevice resStr:%@", resStr);
}

- (void)DFUUpgrade:(RTKDFUUpgrade *)task willUpgradeCompanionDevice:(RTKProfileConnection *)connection deviceInfo:(RTKOTADeviceInfo *)companionInfo {
    
    //self.progressLabel.text = @"Start upgrade companion device";
    NSString *resStr = @"Start upgrade companion device";
    NSLog(@"willUpgradeCompanionDevice resStr:%@", resStr);
}



@end
