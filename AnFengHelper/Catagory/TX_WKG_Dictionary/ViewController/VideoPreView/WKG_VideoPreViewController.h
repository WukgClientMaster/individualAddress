//
//  WKG_VideoPreViewController.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/11.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKG_VideoPreViewController : UIViewController
@property (copy, nonatomic) NSString * done_optional;

-(instancetype)initWithVideoPth:(NSString*)videoPath coverImage:(UIImage*)coverImage;

-(instancetype)initWithVideoURl:(NSURL*)videoUrl coverImage:(UIImage*)coverImage;


@end
