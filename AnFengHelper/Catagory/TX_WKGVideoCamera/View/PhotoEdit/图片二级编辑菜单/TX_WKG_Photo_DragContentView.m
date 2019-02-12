//
//  TX_WKG_Photo_DragContentView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/5.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_DragContentView.h"
#import "TX_WKG_Photo_EditConfig.h"
#import <GLKit/GLKit.h>

#define kDragCloseBtnTag        1
#define kDragEditBtnTag         2
#define kDragScaleBtnTag        3
#define kDragRotationBtnTag     4

#define kDefaultDragViewWidth   80
#define kDefaultDragIconSize    30

@interface TX_WKG_Photo_DragContentView()
@property (nonatomic, strong, readwrite) UILabel * contentLabel;
@property (nonatomic, assign) float ratio;
@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *scaleBtn;
@property (strong, nonatomic) UIColor * textColor;
@end

@implementation TX_WKG_Photo_DragContentView
- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text{
    size_t width =  CGRectGetWidth(frame);
    size_t height = CGRectGetHeight(frame);
    _ratio = ((float)width)/((float)height);
    height = width / _ratio;
    if (self = [self initWithFrame:frame]) {
        [self setupUIWithSize:CGSizeMake(width, height)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tx_wkg_insert_word_events:) name:TX_WKG_PHOTO_INSERT_TEXTWORD_NOTIFICATION_DEFINER object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TX_WKG_PHOTO_INSERT_TEXTWORD_NOTIFICATION_DEFINER object:nil];
}

- (void)setupUIWithSize:(CGSize)size{
    // 边框
    _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _borderView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    _borderView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *dragBorderGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImageDrag:)];
    [_borderView addGestureRecognizer:dragBorderGesture];
    [self addSubview:_borderView];
    _borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    _borderView.layer.borderWidth = 1.0f;
    // 图片
    _contentLabel = [UILabel new];
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.text = @"你若安好";
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.font = [UIFont systemFontOfSize:widthEx(16.f)];
    [_contentLabel sizeToFit];
    _contentLabel.frame = CGRectMake(CGRectGetMinX(self.borderView.frame)+ widthEx(8.f), CGRectGetMinY(self.borderView.frame)+widthEx(4.f), CGRectGetWidth(self.borderView.frame) - widthEx(16.f), CGRectGetHeight(self.borderView.frame) - widthEx(8.f));
    [self addSubview:_contentLabel];

    // 关闭
    CGRect closeFrame = CGRectMake(CGRectGetMinX(self.borderView.frame)- kDefaultDragIconSize/2.f, CGRectGetMinY(self.borderView.frame)- kDefaultDragIconSize/2.f , kDefaultDragIconSize, kDefaultDragIconSize);
    _closeBtn = [[UIButton alloc] initWithFrame:closeFrame];
    [_closeBtn setImage:[UIImage imageNamed:@"tx_wkg_photo_text_cancel"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setTag:kDragCloseBtnTag];
    [self addSubview:_closeBtn];
    // 编辑
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(CGRectGetMinX(self.borderView.frame)- kDefaultDragIconSize/2.f, CGRectGetMaxY(self.borderView.frame) - kDefaultDragIconSize/2.f ,kDefaultDragIconSize, kDefaultDragIconSize);
 
    [_editBtn setImage:[UIImage imageNamed:@"tx_wkg_photo_text_edit"] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn setTag:kDragEditBtnTag];
    [self addSubview:_editBtn];
    // 缩放
    _scaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _scaleBtn.frame = CGRectMake(CGRectGetMaxX(self.borderView.frame) - kDefaultDragIconSize/2.f,CGRectGetMaxY(self.borderView.frame) - kDefaultDragIconSize/2.f, kDefaultDragIconSize, kDefaultDragIconSize);
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onButtonScale:)];
    [_scaleBtn setImage:[UIImage imageNamed:@"tx_wkg_photo_text_scale"] forState:UIControlStateNormal];
    [_scaleBtn setTag:kDragScaleBtnTag];
    [_scaleBtn addGestureRecognizer:panGesture];
    [self addSubview:_scaleBtn];
}

-(void)setConfigWithContentText:(NSString*)text{
    if (text.length == 0 || text == nil) {
        text = @"你若安好";
    }
    self.contentLabel.text = text;
    [self.contentLabel sizeToFit];
    CGSize  contentSize = [self getTheSizeOfTextView:text];
    if (contentSize.width < widthEx(120)) {
        contentSize.width = widthEx(120);
    }else{
        contentSize.width +=widthEx(16.f);
    }
    CGFloat x = CGRectGetMinX(self.frame);
    CGFloat y = CGRectGetMinY(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    self.contentLabel.center = CGPointMake(contentSize.width/2.f, CGRectGetHeight(self.frame)/2.f);
    self.frame = CGRectMake(x, y, contentSize.width, height);
    _borderView.frame = CGRectMake(0, 0, contentSize.width, height);
    _scaleBtn.frame = CGRectMake(CGRectGetMaxX(self.borderView.frame) - kDefaultDragIconSize/2.f,CGRectGetMaxY(self.borderView.frame) - kDefaultDragIconSize/2.f, kDefaultDragIconSize, kDefaultDragIconSize);
}

- (NSMutableDictionary *)setRichText{
    UIFont *font = [UIFont systemFontOfSize:18.f];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    return attributes;
}

-(CGSize)getTheSizeOfTextView:(NSString*)text{
    CGRect rect = [text boundingRectWithSize:CGSizeZero options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:[self setRichText] context:nil];
    return rect.size;
}

-(void)tx_wkg_insert_word_events:(NSNotification*)notification{
    id obj = notification.object;
    if ([obj isKindOfClass:[UIColor class]]) {
        UIColor * color = (UIColor*)obj;
        if (self.contentLabel) {
            self.contentLabel.textColor = color;
            self.textColor = color;
        }
    }
}

-(void)setConfigWithContentTextColor:(UIColor*)textColor{
    if (textColor == nil) {
        textColor = [UIColor blackColor];
    }
    self.contentLabel.textColor = textColor;
}
#pragma mark - Events
- (void)buttonTapped:(UIButton *)sender{
    switch (sender.tag) {
        case kDragCloseBtnTag:
            [self removeFromSuperview];
            if (self.dragContentCallback) {
                self.dragContentCallback(@"关闭");
            }
            break;
        case kDragEditBtnTag:
            if (self.dragContentCallback) {
                self.dragContentCallback(@"编辑");
            }
            break;
        default:
            break;
    }
}

- (void)onImageDrag:(UIPanGestureRecognizer *)gesture{
    CGPoint gestureOrigin = [gesture locationInView:self.superview];
    if (!CGRectContainsPoint(self.superview.frame, CGPointMake(gestureOrigin.x, gestureOrigin.y+ CGRectGetMinY(self.superview.frame))))return;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self hideToolBar];
            break;
        case UIGestureRecognizerStateChanged:
            [self hideToolBar];
            self.center = CGPointMake(gestureOrigin.x, gestureOrigin.y);
            break;
        case UIGestureRecognizerStateEnded:
         [self showToolBar];
            break;
        default:
            break;
    }
}

- (void)onButtonScale:(UIPanGestureRecognizer *)gesture{
    CGPoint gestureOrigin = [gesture locationInView:self];
    gestureOrigin.x = gestureOrigin.x - kDefaultDragIconSize/2;
    gestureOrigin.y = gestureOrigin.y - kDefaultDragIconSize/2;
    CGFloat deltaX = gestureOrigin.x - self.contentLabel.center.x;
    CGFloat deltaY = gestureOrigin.y - self.contentLabel.center.y;
    
    CGFloat scaleX = deltaX/(self.contentLabel.frame.size.width/2);
    CGFloat scaleY = deltaY/(self.contentLabel.frame.size.height/2);
    scaleX = MAX(scaleX, 0);
    scaleY = MAX(scaleY, 0);
    
    if (scaleX < 1.0f && self.contentLabel.frame.size.width*scaleX <= kDefaultDragIconSize) {
        scaleX = kDefaultDragIconSize/self.contentLabel.frame.size.width;
    }
    if (scaleY < 1.0f && self.contentLabel.frame.size.height*scaleY <= kDefaultDragIconSize) {
        scaleY = kDefaultDragIconSize/self.contentLabel.frame.size.height;
    }
    // imageView
    self.contentLabel.transform = CGAffineTransformScale(self.contentLabel.transform, scaleX, scaleY);
    // closeBtn frame
    _closeBtn.frame = CGRectMake(_contentLabel.centerX - _contentLabel.frame.size.width/2-kDefaultDragIconSize/2 , _contentLabel.center.y- _contentLabel.frame.size.height/2-kDefaultDragIconSize/2, kDefaultDragIconSize, kDefaultDragIconSize);
    
    _editBtn.frame = CGRectMake(_contentLabel.centerX  - _contentLabel.frame.size.width/2-kDefaultDragIconSize/2, _contentLabel.center.y + _contentLabel.frame.size.height/2 - kDefaultDragIconSize/2, kDefaultDragIconSize, kDefaultDragIconSize);
    
    _scaleBtn.frame = CGRectMake(_contentLabel.frame.size.width/2.f + _contentLabel.centerX -kDefaultDragIconSize/2, _contentLabel.frame.size.height/2+_contentLabel.center.y -kDefaultDragIconSize/2, kDefaultDragIconSize, kDefaultDragIconSize);
   // borderView
    _borderView.frame = self.contentLabel.frame;
}

- (void)onButtonRotate:(UIPanGestureRecognizer *)gesture{
    CGPoint gestureOrigin = [gesture locationInView:self];
    CGPoint center = self.contentLabel.center;
    GLKVector2 originVec = GLKVector2Normalize(GLKVector2Make(self.contentLabel.center.x - center.x, self.contentLabel.center.y - center.y));
    GLKVector2 newVec = GLKVector2Normalize(GLKVector2Make(gestureOrigin.x - center.x, gestureOrigin.y - center.y));
    CGFloat cos = GLKVector2DotProduct(originVec, newVec);
    CGFloat rad = MAX(MIN(acos(cos), 2*M_PI), 0);
    if (newVec.x > originVec.x) {
        rad = rad;
    }else {
        rad = -rad;
    }
    self.transform = CGAffineTransformRotate(self.transform, rad);
}

#pragma mark - Override
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSArray *subviews = [[self.subviews reverseObjectEnumerator] allObjects];
    for (UIView *view in subviews) {
        if (view.userInteractionEnabled && CGRectContainsPoint(view.frame, point)) {
            return view;
        }
    }
    return nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event{
    return YES;
}
#pragma mark - PublicMethod
- (void)showToolBar{
    _scaleBtn.hidden = NO;
    _closeBtn.hidden = NO;
    _editBtn.hidden = NO;
    _borderView.layer.borderWidth = 1.0f;
}

- (void)hideToolBar{
    _scaleBtn.hidden = YES;
    _closeBtn.hidden = YES;
    _editBtn.hidden = YES;
    _borderView.layer.borderWidth = 0.0f;
}

@end
