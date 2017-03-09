//
//  ScrollViewZoom.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/29.
//  Copyright © 2016年 吴可高. All rights reserved.
//

static const float kZoomRectSizeWith = 80.f;
#import "ScrollViewZoom.h"

@interface ScrollViewZoom ()<UIScrollViewDelegate>
{

}
@property (strong, nonatomic) UIImageView * zoomImgView;

@property (copy, nonatomic) ScrollViewZoomCallBack callBack;

@end

@implementation ScrollViewZoom

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumZoomScale = 1.f;
        self.maximumZoomScale = 1.5f;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator  = NO;
        self.delegate  = self;
        self.userInteractionEnabled  = YES;
    }
    return self;
}

-(UIImageView *)zoomImgView
{
    _zoomImgView  = ({
        if (!_zoomImgView) {
            _zoomImgView = [[UIImageView alloc]initWithFrame:self.bounds];
            _zoomImgView.userInteractionEnabled = YES;
        }
        _zoomImgView;
    });
    return _zoomImgView;
}

-(instancetype)initWithFrame:(CGRect)frame targetImageUrl:(NSURL *)imgUrl callBack:(ScrollViewZoomCallBack)callBack
{
    if (self  = [super initWithFrame:frame])
    {
        UITapGestureRecognizer * tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleValueClicked:)];
        tapgesture.numberOfTapsRequired = 2;
        [self.zoomImgView addGestureRecognizer:tapgesture];
        [self addSubview:self.zoomImgView];
        
    }
    return  self;
}

-(void)doubleValueClicked:(UITapGestureRecognizer*) tapgesture
{
    CGPoint targetPoint  = [tapgesture locationInView:self];
    if  (self.zoomScale > self.minimumZoomScale)
        [self setZoomScale:1.0f animated:YES];
    
    CGRect targetRectFrame = CGRectMake(targetPoint.x -kZoomRectSizeWith/2.0, targetPoint.y - kZoomRectSizeWith /2.0, kZoomRectSizeWith, kZoomRectSizeWith);
    [self zoomToRect:targetRectFrame animated:YES];
}

#pragma mark -设置缩放对象
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomImgView;
}
#pragma mark -zooming
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale >1.f)
        scrollView.center = CGPointMake(scrollView.bounds.size.width/2.f, scrollView.bounds.size.height/2.f);
}
@end
