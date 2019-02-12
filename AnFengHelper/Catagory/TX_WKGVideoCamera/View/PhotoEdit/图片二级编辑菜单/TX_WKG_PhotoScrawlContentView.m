//
//  TX_WKG_PhotoScrawlContentView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/21.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_PhotoScrawlContentView.h"
#import "TX_WKG_Photo_EditConfig.h"
#import "TX_WKG_Scrawl_Node.h"
#import "TX_WKG_BezierPath.h"

@interface TX_WKG_PhotoScrawlContentView (){
    CGPoint previousPoint;
    CGPoint currentPoint;
}
@property (strong, nonatomic) TX_WKG_Scrawl_Node * scrawlNode;
@property (strong, nonatomic) NSMutableArray * images;
@property (strong, nonatomic) NSMutableArray * undoRollImages;
@property (nonatomic,readwrite,strong) UIImage * contentViewImage;
@property (copy, nonatomic) NSString * initializeFormatString;

@end

@implementation TX_WKG_PhotoScrawlContentView

#pragma mark - getter methods
-(NSMutableArray *)undoRollImages{
    _undoRollImages = ({
        if (!_undoRollImages) {
            _undoRollImages = [NSMutableArray array];
        }
        _undoRollImages;
    });
    return _undoRollImages;
}

-(NSMutableArray *)images{
    _images = ({
        if (!_images) {
            _images = [NSMutableArray array];
        }
        _images;
    });
    return _images;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.initializeFormatString = @"YES";
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tx_wkg_photo_scrawl_drawNode:) name:TX_WKG_NOTIFICATION_PHOTO_SCRAWL_DEFINIER object:nil];
        [self setup];
    }
    return self;
}

-(void)tx_wkg_photo_scrawl_drawNode:(NSNotification*)notification{
    id object = notification.object;
    if ([object isKindOfClass:[TX_WKG_Scrawl_Node class]]) {
        self.scrawlNode = object;
    }
}

-(void)dealloc{

}

-(void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.scrawlNode = [[TX_WKG_Scrawl_Node alloc]initWithColor:UIColorFromRGB(0x000000) lineWidth:2.f isSelected:YES];
    self.scrawlNode.drawType = TX_WKG_PhotoScrawlContentWrite;
    currentPoint = CGPointMake(0, 0);
    previousPoint = currentPoint;
}
#pragma mark - setter methods

#pragma mark - UITouch Events
- (void)eraseLine:(NSString*)drawType{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.contentViewImage drawInRect:self.bounds];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor clearColor].CGColor);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.contentViewImage = UIGraphicsGetImageFromCurrentImageContext();
    if ([drawType isEqualToString:@"End"]) {
        [self.images addObject:self.contentViewImage];
        NSString * roll     = @"YES";
        NSString * undoRoll = @"NO";
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
    }
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    [self setNeedsDisplay];
}

- (void)drawLineNew:(NSString*)drawType{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.contentViewImage drawInRect:self.bounds];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.scrawlNode.color.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.scrawlNode.lineWidth);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    if ([drawType isEqualToString:@"End"]) {
        [self.images addObject:image];
        NSString * roll = @"YES";
        NSString * undoRoll = @"NO";
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
    }
    self.contentViewImage = image;
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    [self setNeedsDisplay];
}

- (void)handleTouches:(NSString*)drawType{
    if (self.scrawlNode.drawType == TX_WKG_PhotoScrawlContentWrite) {
        [self drawLineNew:drawType];
    }
    else{
        [self eraseLine:drawType];
    }
}

- (void)drawRect:(CGRect)rect{
    [self.contentViewImage drawInRect:self.bounds];
}
-(void)clearAllOptData{
    [self.images removeAllObjects];
    [self.undoRollImages removeAllObjects];
}
//向后撤销
-(void)undoRollback{
    if (self.undoRollImages.count == 0)return;
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        UIImage * image = (UIImage*)[self.undoRollImages lastObject];
        [self.images addObject:image];
        [self.undoRollImages removeObject:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * roll =  self.images.count == 0 ? @"NO" : @"YES";
            NSString * undoRoll =  self.undoRollImages.count == 0 ? @"NO" : @"YES";
            [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
            if ([roll isEqualToString:@"NO"]) {
                self.contentViewImage = nil;
            }else{
                self.contentViewImage = (UIImage*)[self.images lastObject];
            }
            [self setNeedsDisplay];
        });
    });
}
//向前撤销
-(void)rollback{
    if (self.images.count == 0)return;
    UIImage * lastImage = (UIImage*)[self.images lastObject];
    [self.undoRollImages addObject:lastImage];
    [self.images removeLastObject];
    NSString * roll =  self.images.count == 0 ? @"NO" : @"YES";
    NSString * undoRoll =  self.undoRollImages.count == 0 ? @"NO" : @"YES";
    [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
    if ([roll isEqualToString:@"NO"]) {
        self.contentViewImage = nil;
    }else{
        self.contentViewImage = (UIImage*)[self.images lastObject];
    }
    [self setNeedsDisplay];
}
//清除所有
-(void)clearAllScreen{
    [self.images removeAllObjects];
    [self.undoRollImages removeAllObjects];
     self.contentViewImage = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":@"NO",@"向后撤销":@"NO"} userInfo:nil];
    [self setNeedsDisplay];
}


#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint p = [[touches anyObject] locationInView:self];
    previousPoint = p;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    currentPoint = [[touches anyObject] locationInView:self];
    [self handleTouches:@"v"];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    currentPoint = [[touches anyObject] locationInView:self];
    [self handleTouches:@"End"];
}

@end
