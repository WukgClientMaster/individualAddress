//
//  TX_WKG_Photo_EffectView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TX_WKG_Photo_EffectView : UIView
@property (strong,readonly,nonatomic) NSIndexPath * selectedIndexPath;
-(void)resetPhotoEffectStatus;
@end
