//
//  VideoPlayerView.h
//  AnFengHelper
//
//  Created by 吴可高 on 2018/7/14.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VideoPlayerViewIsRemoveCoverImageViewCallback)(BOOL remove);

@interface VideoPlayerView : UIView
@property(nonatomic,copy) VideoPlayerViewIsRemoveCoverImageViewCallback removeCoverImageViewCallback;

-(void)stopVideo;
-(void)setVideo:(NSString*)videoURL;

@end
