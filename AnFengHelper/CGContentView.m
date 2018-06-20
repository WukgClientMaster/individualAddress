//
//  CGContentView.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/6/18.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "CGContentView.h"
@interface CGContentView()
@property(nonatomic,strong) CAShapeLayer * shapeLayer;
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) NSMutableArray * nodes;
@end

@implementation CGContentView

-(NSMutableArray *)nodes{
    _nodes = ({
        if (!_nodes) {
            _nodes = [NSMutableArray array];
        }
        _nodes;
    });
    return _nodes;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = ({
            _imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
            _imageView.image = [UIImage imageNamed:@"filter1.jpeg"];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            _imageView;
        });
        [self addSubview:_imageView];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    for (int i = 0; i < self.nodes.count; i++) {
        NSValue * value = self.nodes[i];
        if (i == 0) {
            CGContextMoveToPoint(ctx, [value CGPointValue].x,[value CGPointValue].y);
        }else{
            CGContextAddLineToPoint(ctx,[value CGPointValue].x,[value CGPointValue].y);
        }
        CGContextSetLineWidth(ctx, 12);
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextSetLineCap(ctx,kCGLineCapRound);
        if (i== self.nodes.count -1) {
            CGContextClosePath(ctx);
            CGContextDrawPath(ctx,kCGPathStroke);
            CGContextRestoreGState(ctx);
            CGPathRef pathRef = CGContextCopyPath(ctx);
            self.shapeLayer.path = pathRef;
        }
    }
    /*
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextMoveToPoint(ctx, 20, 100);
    CGContextAddLineToPoint(ctx, 100, 320);
    CGContextSetLineWidth(ctx, 12);
    CGContextSetLineCap(ctx,kCGLineCapRound);

    CGContextRestoreGState(ctx);
    CGContextSetLineWidth(ctx, 24);
    CGContextMoveToPoint(ctx, 40, 200);
    CGContextAddLineToPoint(ctx, 80, 100);
    CGPathRef pathRef = CGContextCopyPath(ctx);
    if (self.shapeLayer == nil) {
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        self.shapeLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)/2.f);
    }
    self.shapeLayer.path = pathRef;
    self.shapeLayer.lineWidth = 100.f;
    [self.shapeLayer setStrokeColor:[UIColor whiteColor].CGColor];
    [self.shapeLayer setFillColor:nil];
    _imageView.layer.mask = self.shapeLayer;
    */
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject]locationInView:self];
    NSValue * value = [NSValue valueWithCGPoint:point];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!CGContextPathContainsPoint(ctx, point,kCGPathStroke)) {
        [self.nodes addObject:value];
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nodes removeAllObjects];
}
@end
