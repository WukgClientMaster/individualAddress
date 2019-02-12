//
//  TX_WKG_Photo_TextView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/5.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TX_WKG_Scrawl_Node.h"

@interface TX_WKG_Photo_TextView : UIView
@property (strong, nonatomic) NSIndexPath * selectIndexPath;
@property (strong,readonly,nonatomic) TX_WKG_Scrawl_Node * selectedNode;
-(void)resetPhotoTextStatus;

@end
