//
//  APPTextField.m
//  AttractionsVoice
//
//  Created by 吴可高 on 16/7/19.
//  Copyright © 2016年 com.BlueMobi.Lqw. All rights reserved.
//

#import "APPTextField.h"

@implementation APPTextField

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+ 20, bounds.origin.y, bounds.size.width -20, bounds.size.height);//更好理解些
    return inset;
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x+ 20, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
    
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x +20, bounds.origin.y, bounds.size.width -20, bounds.size.height);
    return inset;
}
@end
