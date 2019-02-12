//
//  MusicSegmentView.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicSegmentViewDidSelectedDelegate
@required
-(void)musicSegmentViewDidSelected:(NSUInteger)index flage:(BOOL)flage;

@end

@interface MusicSegmentView : UIView
@property(nonatomic,strong) NSArray * segments;
@property(nonatomic,weak) id<MusicSegmentViewDidSelectedDelegate> delegate;
-(void)selectCollViewDidScrollViewFromIdx:(NSInteger)fromIdx toIdx:(NSInteger)toIdx flage:(BOOL)flage;

@end

