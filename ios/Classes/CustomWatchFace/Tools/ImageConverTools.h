//
//  ImageConverTools.h
//  sma_coding_dev_flutter_sdk
//
//  Created by Coding on 2023/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageConverTools : NSObject

+(NSData *)getImgWithImage:(UIImage *)image isAlpha:(BOOL)isAlpha;

+ (NSMutableData *) convertUIImageToBitmapRGB565:(UIImage *) image;
@end

NS_ASSUME_NONNULL_END
