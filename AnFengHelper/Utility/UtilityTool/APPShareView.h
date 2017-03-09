//
//  APPShareView.h
//  AttractionsVoice
//
//  Created by 吴可高 on 16/7/23.
//  Copyright © 2016年 com.BlueMobi.Lqw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^APPShareResponseBlock)(UIButton* parameter);
@interface APPShareView : UIView
@property (copy, nonatomic) APPShareResponseBlock appShareBlock;

@end
