//
//  ImageConverTools.m
//  sma_coding_dev_flutter_sdk
//
//  Created by Coding on 2023/9/12.
//

#import "ImageConverTools.h"
#import <JL_BLEKit/JL_BLEKit.h>

@implementation ImageConverTools

+(NSData *)getImgWithImage:(UIImage *)image isAlpha:(BOOL)isAlpha {

    
    int width = image.size.width;
    int height = image.size.height;
    
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    
    NSData *bitmap = [BitmapTool convert_B_G_R_A_BytesFromImage:image];
    
    
    NSString *bmpPath = [NSString stringWithFormat:@"%@/%@", documentPath, @"ios_ios_0.bmp"];
    Boolean isOK = [JL_Tools writeData:bitmap fillFile:bmpPath];
    NSLog(@"bmp是否成功res:%d", isOK);
    //NSLog(@"bmp大小:%d", [NSData dataWithContentsOfFile:bmpPath].length);

    
    NSString *binPath = [NSString stringWithFormat:@"%@/%@", documentPath, @"ios_ios_0.png.bin"];
    /*--- BR28压缩算法 ---*/ //注意:这里根据自己需求，从上面图片转码API选择。
    int res = 0;
    if (isAlpha) {
        res = br28_btm_to_res_path_with_alpha_nopack((char*)[bmpPath UTF8String], width, height, (char*)[binPath UTF8String]);
    } else {
        res = br28_btm_to_res_path_nopack((char*)[bmpPath UTF8String], width, height, (char*)[binPath UTF8String]);
    }

    //NSLog(@"是否成功res:%d", res);
    //NSLog(@"--->Br28 BIN【%@】is OK!", binPath);
    //注意:这里的【binPath】就是我们转换好的图片路径。
        
    
    return [NSData dataWithContentsOfFile:binPath];
}


// MARK: - ==================
+ (NSMutableData *)convertUIImageToBitmapRGB565:(UIImage *) image {
    CGImageRef imageRef = image.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    NSMutableData *newData = [[NSMutableData alloc]init];
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = [self newBitmapRGB555ContextFromImage:imageRef];
    if(!context) {
        NSLog(@"convertUIImageToBitmapRGB565 is null");
        return NULL;
    }

    CGRect rect = CGRectMake(0, 0, width, height);

    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);

    // Get a pointer to the data
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    uint16_t *newbit = (uint16_t*)bitmapData;
    // Copy the data and release the memory (return memory allocated with new)
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t bufferLength = bytesPerRow * height;
    uint16_t *newBitmap = NULL;
    if(bitmapData) {
        newBitmap = (uint16_t *)malloc(sizeof(uint16_t) * bufferLength/2);
        if(newBitmap) {
            //RGB555->RGB565
            for (int i = 0; i < bufferLength/2;i++ ) {
                newBitmap[i] = newbit[i]&0x1f;
                newBitmap[i] |= (newbit[i]>>5)<<6;
            }
        }
        NSData* data = [NSData dataWithBytes:(const void *)newBitmap length:bufferLength];
        [newData setData:data];
        free(bitmapData);
        free(newBitmap);
    } else {
        NSLog(@"Error getting bitmap pixel data\n");
    }
    CGContextRelease(context);
    return newData;
}

+ (CGContextRef) newBitmapRGB555ContextFromImage:(CGImageRef) image {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint16_t *bitmapData;
    size_t bitsPerComponent = 5;

    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
//每行的字节数等于：每像素比特数乘以图片宽度加 31 的和除以 32，并向下取整，最后乘以 4
    // 向下取整 float floorf(float);
    float bytesFloat = floorf((16.0*width+31)/32);
    size_t bytesPerRow = bytesFloat*4;
    size_t bufferLength = bytesPerRow * height;

    colorSpace = CGColorSpaceCreateDeviceRGB();

    if(!colorSpace) {
        NSLog(@"Error allocating color space RGB\n");
        return NULL;
    }

    // Allocate memory for image data
    bitmapData = (uint16_t *)malloc(bufferLength);

    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder16Little);
    //kCGImagePixelFormatRGB565 kCGBitmapByteOrder16Little kCGBitmapByteOrder16Big
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }

    CGColorSpaceRelease(colorSpace);

    return context;
}


@end
