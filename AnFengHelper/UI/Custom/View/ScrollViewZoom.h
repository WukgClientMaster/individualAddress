//
//  ScrollViewZoom.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/29.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ScrollViewZoomCallBack) (NSInteger);

@interface ScrollViewZoom : UIScrollView
/**
 *
 *
 *  @param frame
 *  @param imgUrl
 *  @param callBack
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame targetImageUrl:(NSURL*) imgUrl callBack:(ScrollViewZoomCallBack)callBack;
@end
