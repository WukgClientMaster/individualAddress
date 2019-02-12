//
//  TX_WKG_RenderImageView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/26.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_RenderImageView.h"

@interface TX_WKG_RenderImageView()
@property (nonatomic, assign) CGSize constraintSize;

@end

@implementation TX_WKG_RenderImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _constraintSize = frame.size;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    size_t w = CGImageGetWidth(image.CGImage);
    size_t h = CGImageGetHeight(image.CGImage);
    
    CGFloat scaleX = _constraintSize.width/w;
    CGFloat scaleY = _constraintSize.height/h;
    CGFloat scale = MIN(scaleX, scaleY);
    
    CGPoint center = self.center;
    CGRect resizeRect = self.frame;
    resizeRect.size.width = (int)(scale * w + 0.5);
    resizeRect.size.height = (int)(scale * h + 0.5);
    
    self.frame = resizeRect;
    self.center = center;
    [super setImage:image];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
