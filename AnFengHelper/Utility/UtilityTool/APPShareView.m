//
//  APPShareView.m
//  AttractionsVoice
//
//  Created by 吴可高 on 16/7/23.
//  Copyright © 2016年 com.BlueMobi.Lqw. All rights reserved.
//

#import "APPShareView.h"

@interface APPShareView ()
@property (strong, nonatomic) NSMutableArray * contraints;
@end
@implementation APPShareView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
-(void)setUp
{
    __weak typeof(self)weakSelf = self;
    self.backgroundColor = KColor(247, 247, 247);
    NSArray * titles = @[@"微信好友",@"微信朋友圈",@"新浪微博"];
    NSArray * imgs = @[@"forum_wechat",@"forum_wechatCycle",@"forum_sina"];
    for (int i = 0; i < titles.count; i++) {
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setTitle:titles[i] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:11.f];
        [item setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [item addTarget:self action:@selector(shareEvent:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
        [self.contraints addObject:item];
    }
    __block  UIButton * _lastObject = nil;
    [self.contraints enumerateObjectsUsingBlock:^(UIButton *item, NSUInteger idx, BOOL *  stop) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0.f);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width/3.f,kScreen_Width/3.f));
            if (!_lastObject) {
                make.left.mas_equalTo(weakSelf.mas_left).with.offset(0);
            }
            else
            {
                make.left.mas_equalTo(_lastObject.mas_right).with.offset(0);
            }
            _lastObject = item;
        }];
    }];
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelShareEvent:) forControlEvents:UIControlEventTouchDown];
    cancel.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(45.f);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
}
- (NSMutableArray *)contraints
{
    _contraints = ({
        if (!_contraints) {
            _contraints  = [NSMutableArray array];
        }
        _contraints;
    });
    return _contraints;
}
-(void)shareEvent:(UIButton*)param
{
    if (_appShareBlock) {
        _appShareBlock(param);
    }
}
-(void)cancelShareEvent:(UIButton*)param
{
    if (_appShareBlock) {
        _appShareBlock(param);
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contraints enumerateObjectsUsingBlock:^(UIButton * item, NSUInteger idx, BOOL *  stop) {
        [self titleTextContentRect:item];
    }];
}
-(void)titleTextContentRect:(UIButton*)tabbarButton
{
    CGRect imgFrame  = tabbarButton.imageView.frame;
    CGFloat imgX = (tabbarButton.frame.size.width - imgFrame.size.width)/2.0f;
    CGFloat imgY = 2;
    CGFloat titleX  =  - imgFrame.size.width/2.f - imgFrame.size.width/2.f;
    tabbarButton.imageEdgeInsets  = UIEdgeInsetsMake
    (imgY, imgX, imgFrame.size.width, imgX);
    [tabbarButton setTitleEdgeInsets:UIEdgeInsetsMake( imgFrame.size.height,titleX, 0, 0)];
}
@end

