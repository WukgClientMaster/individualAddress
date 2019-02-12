//
//  ScratchCardView.m
//  RGBTool
//
//  Created by admin on 23/08/2017.
//  Copyright © 2017 gcg. All rights reserved.
//

#import "XScratchView.h"
#import "TX_WKG_Photo_Node.h"
#import "TX_WKG_Photo_EditConfig.h"
#import "TX_WKG_RenderImageView.h"

@interface XScratchView (){
    CGPoint previousPoint;
    CGPoint currentPoint;
}
//** <##> */
@property (nonatomic, strong) TX_WKG_RenderImageView *surfaceImageView;
/** <##> */
@property (nonatomic, strong) CALayer *imageLayer;
/** <##> */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
/** 手指的涂抹路径 */
@property (nonatomic, assign) CGMutablePathRef path;
@property (strong, nonatomic) NSMutableArray * nodes;
@property (strong, nonatomic) NSMutableArray * undoNodes;
@property (strong, nonatomic) NSMutableArray * uniOptNodes; //单次操作数目
@property (copy, nonatomic) NSString * revokedOpt; //重新操作
@property (strong, nonatomic) NSNumber * selectedPencil;
@property (strong, nonatomic) CAShapeLayer * shape;

@end

@implementation XScratchView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.surfaceImageView = [[TX_WKG_RenderImageView alloc] initWithFrame:self.bounds];
        self.surfaceImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.surfaceImageView];
        
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        self.imageLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.imageLayer];
        self.scratchType = KTX_WKG_XScratchTypeWrite;
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        //        self.shapeLayer.lineWidth = widthEx(8.f);
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;//此处必须设为nil，否则后边添加addLine的时候会自动填充
        self.imageLayer.mask = self.shapeLayer;
        self.path = CGPathCreateMutable();
        currentPoint  = CGPointZero;
        previousPoint = currentPoint;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tx_Wkg_mosaic_notification_events:) name:TX_WKG_PHOTO_NEWDECOMMEND_ADDLINEWIDTH_MOSAIC_EFFECTIVE_NOTIFICATION_DEFINER object:nil];
    }
    return self;
}
-(void)dealloc{
    if (self.path) {
        CGPathRelease(self.path);
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TX_WKG_PHOTO_NEWDECOMMEND_ADDLINEWIDTH_MOSAIC_EFFECTIVE_NOTIFICATION_DEFINER object:nil];
}

-(void)tx_Wkg_mosaic_notification_events:(NSNotification*)notification{
    id obj = notification.object;
    if ([obj isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)obj;
        self.selectedPencil = number;
    }
}
#pragma mark - getter methods
-(NSMutableArray *)nodes{
    _nodes = ({
        if (!_nodes) {
            _nodes = [NSMutableArray array];
        }
        _nodes;
    });
    return _nodes;
}
-(NSMutableArray *)uniOptNodes{
    _uniOptNodes = ({
        if (!_uniOptNodes) {
            _uniOptNodes = [NSMutableArray array];
        }
        _uniOptNodes;
    });
    return _uniOptNodes;
}

-(NSMutableArray *)undoNodes{
    _undoNodes = ({
        if (!_undoNodes) {
            _undoNodes = [NSMutableArray array];
        }
        _undoNodes;
    });
    return _undoNodes;
}
#pragma mark -setter methods
-(void)setScratchType:(KTX_WKG_XScratchType)scratchType{
    _scratchType = scratchType;
}

- (void)setMosaicImage:(UIImage *)mosaicImage{
    _mosaicImage = mosaicImage;
    self.imageLayer.contents = (id)mosaicImage.CGImage;
}

- (void)setSurfaceImage:(UIImage *)surfaceImage{
    _surfaceImage = surfaceImage;
    self.surfaceImageView.image = surfaceImage;
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if ([self.revokedOpt isEqualToString:@"NO"]) {
        UIBezierPath * path = [UIBezierPath bezierPath];
        CGFloat lineWidth = self.selectedPencil == nil  ? 2* 2.f: [self.selectedPencil floatValue]* 2.f;
        if (_shape == nil) {
            _shape = [CAShapeLayer layer];
            _shape.backgroundColor = [UIColor clearColor].CGColor;
            [_shape setLineWidth:lineWidth];
            _shape.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            _shape.anchorPoint = CGPointMake(0.5, 0.5);
            _shape.position = CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)/2.f);
            _shape.strokeColor = [UIColor blueColor].CGColor;
            _shape.fillColor = nil;
        }
        for (int i = 0 ; i < self.uniOptNodes.count; i++) {
            TX_WKG_Photo_Node * node = self.uniOptNodes[i];
            if (i ==0 ) {
                [path moveToPoint:CGPointMake(node.x,node.y)];
            }else{
                [path addLineToPoint:CGPointMake(node.x,node.y)];
            }
            _shape.path = path.CGPath;
        }
        if (![[self.shapeLayer sublayers]containsObject:_shape]) {
            [self.shapeLayer addSublayer:_shape];
            [self.nodes addObject:_shape];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.revokedOpt = @"NO";
    _shape = nil;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.revokedOpt = @"NO";
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGPathContainsPoint(self.path, NULL, point, NO)){
        TX_WKG_Photo_Node * node = [TX_WKG_Photo_Node new];
        node.x = point.x;
        node.y = point.y;
        node.node = @"";
        [self.uniOptNodes addObject:node];
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.revokedOpt = @"NO";
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        dispatch_barrier_async(dispatch_get_main_queue(), ^{
            [self.uniOptNodes removeAllObjects];
            NSString * roll = @"YES";
            NSString * undoRoll = @"NO";
            [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
        });
    });
}

-(void)clearAllOptData{
    [self.nodes removeAllObjects];
    [self.undoNodes removeAllObjects];
}
//清除所有
-(void)clearAllScreen{
    CGPathRelease(self.path);
    self.path = CGPathCreateMutable();
    self.shapeLayer.path = nil;
    [self.nodes removeAllObjects];
    [self.undoNodes removeAllObjects];
}
//向后撤销
-(void)undoRollback{
    if (self.undoNodes.count == 0)return;
    dispatch_async(dispatch_get_main_queue(), ^{
        CAShapeLayer * shape = [self.undoNodes lastObject];
        [self.uniOptNodes removeAllObjects];
        [self.nodes addObject:shape];
        [self.shapeLayer addSublayer:shape];
        [self.undoNodes removeLastObject];
        NSString * roll     =  self.nodes.count == 0 ? @"NO" : @"YES";
        NSString * undoRoll =  self.undoNodes.count == 0 ? @"NO" : @"YES";
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
    });
}
//向前撤销
-(void)rollback{
    if (self.nodes.count == 0)return;
    dispatch_async(dispatch_get_main_queue(), ^{
        CAShapeLayer * shape = [self.nodes lastObject];
        [self.undoNodes addObject:shape];
        [self.nodes removeLastObject];
        [[self.shapeLayer sublayers]enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:shape]) {
                [obj removeFromSuperlayer];
            }
        }];
        [self.uniOptNodes removeAllObjects];
        NSString * roll     =  self.nodes.count == 0 ? @"NO" : @"YES";
        NSString * undoRoll =  self.undoNodes.count == 0 ? @"NO" : @"YES";
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
    });
}
//保存
-(UIImage*)save{
    return nil;
}

@end
