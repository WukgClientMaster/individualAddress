//
//  PhotoCompositionTool.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/29.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "PhotoCompositionTool.h"

@implementation PhotoCompositionTool

+(void)photoCompressionSessionWithOutputPath:(NSString*)videoPath renderImages:(NSArray*)imageArray handle:(PhotoCompressionHandle)callback{
    //定义视频的大小320 480 倍数
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height-10.f;
    CGSize  size  = CGSizeMake(320 * scale  , 480 * scale);
    NSError *error =nil;
    unlink([videoPath UTF8String]);
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:videoPath] fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(videoWriter);
    if(error)
        NSLog(@"error =%@", [error localizedDescription]);
    //AVVideoCompressionPropertiesKey
    NSDictionary *videoSettings =[NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey,
                                  [NSNumber numberWithInt:size.width],AVVideoWidthKey,
                                  [NSNumber numberWithInt:size.height],AVVideoHeightKey,
                                  @{AVVideoAverageBitRateKey:@(size.width * size.height * 8.f)},AVVideoCompressionPropertiesKey,nil];
    AVAssetWriterInput *writerInput =[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    //kCVPixelBufferWidthKey
    NSDictionary*sourcePixelBufferAttributesDictionary =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,
                                                         [NSNumber numberWithInt:size.width],kCVPixelBufferWidthKey,
                                                         [NSNumber numberWithInt:size.height],kCVPixelBufferHeightKey,nil];
    AVAssetWriterInputPixelBufferAdaptor *adaptor =[AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    if ([videoWriter canAddInput:writerInput]){
        [videoWriter addInput:writerInput];
    }
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    dispatch_queue_t dispatchQueue =dispatch_queue_create("mediaInputQueue",NULL);
    int __block frame =0;
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while([writerInput isReadyForMoreMediaData])
        {
            if(++frame >=[imageArray count]*10)
            {
                [writerInput markAsFinished];
                [videoWriter finishWritingWithCompletionHandler:^{
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        AVAssetWriterStatus status =  videoWriter.status;
                        if (status == AVAssetWriterStatusCompleted) {
                            if (callback) {
                                callback(@"success");
                            }
                        }else{
                            if (callback) {
                                callback(@"failure");
                            }
                        }
                    }];
                }];
                break;
            }
            CVPixelBufferRef buffer =NULL;
            int idx = frame / 10;
            buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[imageArray objectAtIndex:idx] CGImage] size:size];
            if (buffer)
            {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,10)]){
                        NSLog(@"FAIL");
                    }
                    else{
                        NSLog(@"OK");
                    }
                    CFRelease(buffer);
            }
        }
    }];
}

+(CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size{
    NSDictionary *options =[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    CVPixelBufferRef pxbuffer =NULL;
    CVReturn status =CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    NSParameterAssert(status ==kCVReturnSuccess && pxbuffer !=NULL);
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    void *pxdata =CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata !=NULL);
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef context =CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    return pxbuffer;
}

@end
