//
//  TX_WKG_Photo_ClipsView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/24.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TX_WKG_Photo_ClipsTypeCallback)(NSString * title);
@interface TX_WKG_Photo_ClipsView : UIView
@property (copy, nonatomic) TX_WKG_Photo_ClipsTypeCallback clipsCallback;

-(void)resetPhotoClipsStatus;

@end
