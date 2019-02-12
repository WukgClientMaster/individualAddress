//
//  TX_WKG_PhotoScrawlContentView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/21.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TX_WKG_PhotoScrawlContentView : UIView
@property (strong,readonly,nonatomic) UIImage * contentViewImage;
@property (strong,readonly,nonatomic) NSMutableArray * images;
@property (strong,readonly,nonatomic) NSMutableArray * undoRollImages;
@property (strong, nonatomic) UIImage * snapshoot;

-(void)clearAllOptData;
//清除所有
-(void)clearAllScreen;
//向前撤销
-(void)rollback;
//向后撤销
-(void)undoRollback;

@end

