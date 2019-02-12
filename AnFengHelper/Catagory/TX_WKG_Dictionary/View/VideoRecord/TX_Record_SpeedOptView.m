//
//  TX_Record_SpeedOptView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/9.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_Record_SpeedOptView.h"

@interface TX_Record_SpeedOptView()
@property (strong, nonatomic) NSMutableArray * opts;
@property (strong, nonatomic) NSMutableArray * optsContainers;
@property (strong,readwrite,nonatomic) UIButton * selectButton;
@end

@implementation TX_Record_SpeedOptView
#pragma mark IBOutlet Events
-(void)optEvents:(UIButton*)args{
    if (self.callback) {
        self.callback(args.currentTitle);
        if (![args isEqual:self.selectButton]) {
            [self.selectButton setSelected:NO];
            [args setSelected:YES];
            self.selectButton = args;
        }
    }
}

#pragma mark - getter methods
-(NSMutableArray *)opts{
    _opts = ({
        if (!_opts) {
            _opts = [NSMutableArray array];
        }
        _opts;
    });
    return _opts;
}
-(NSMutableArray *)optsContainers{
    _optsContainers = ({
        if (!_optsContainers) {
            _optsContainers = [NSMutableArray array];
        }
        _optsContainers;
    });
    return _optsContainers;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColorFromRGB(0x080103) colorWithAlphaComponent:0.3f];
    self.layer.cornerRadius = widthEx(8.f);
    self.layer.masksToBounds = YES;
    self.opts =@[@"极慢",@"慢",@"标准",@"快",@"极快"].mutableCopy;
    NSArray * colors =@[[UIColor whiteColor],UIColorFromRGB(0x00fac5)];
    for (int i = 0; i < self.opts.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.opts[i] forState:UIControlStateNormal];
        [button setTitleColor:colors[0] forState:UIControlStateNormal];
        [button setTitleColor:colors[1] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:widthEx(13.f)];
        [button addTarget:self action:@selector(optEvents:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.optsContainers addObject:button];
        if ([self.opts[i] isEqualToString:@"标准"]) {
             self.selectButton = button;
            [self.selectButton setSelected:YES];
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof(self)weakSelf = self;
    __block UIButton * anchor = nil;
    __block CGFloat padding = widthEx(0.f);
    __block CGFloat itemWidth = CGRectGetWidth(self.frame) / (self.opts.count);
    [self.optsContainers enumerateObjectsUsingBlock:^(UIButton*  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0.f);
            make.size.mas_equalTo(CGSizeMake(itemWidth, CGRectGetHeight(self.frame)));
            if (anchor == nil) {
                make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
            }else{
                make.left.mas_equalTo(anchor.mas_right).with.offset(padding);
            }
        }];
        anchor = item;
    }];
}

@end
