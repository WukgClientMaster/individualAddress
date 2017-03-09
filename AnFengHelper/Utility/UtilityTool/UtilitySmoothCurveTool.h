//
//  UtilitySmoothCurveTool.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/6/8.
//  Copyright © 2016年 吴可高. All rights reserved.
//  绘制一个平滑曲线 曲线路径UIBezierPath CGMutablePathRef


#import <Foundation/Foundation.h>
#import <CoreGraphics/CGPath.h>
@interface UtilitySmoothCurveTool : NSObject

+(UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity andBeizerPath:(UIBezierPath*)bezierPath;

@end
