//
//  Video_Publish_Draft_View.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "Video_Publish_Draft_View.h"
@interface Video_Publish_Draft_View()
@property (strong, nonatomic) NSMutableArray * containers;
@end
@implementation Video_Publish_Draft_View

#pragma mark - IBOutlet Events
-(void)publishEvents:(UIButton*)args{
    if (self.publish_callback) {
        self.publish_callback(args.currentTitle);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - getter methods
-(NSMutableArray *)containers{
    _containers = ({
        if (!_containers) {
            _containers = [NSMutableArray array];
        }
        _containers;
    });
    return _containers;
}

-(void)setup{
    __weak  typeof(self)weakSelf = self;
    __block CGFloat padding = widthEx(12.f);
    NSArray *  backgroundColors = @[[UIColor whiteColor],UIColorFromRGB(0x0ae7ce)];
    NSArray * titleColors = @[[UIColor darkGrayColor],[UIColor whiteColor]];
    NSArray * titles = @[@"存草稿",@"发布作品"];
    for (int i = 0 ; i < titleColors.count; i++) {
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setBackgroundColor:backgroundColors[i]];
        [item setTitle:titles[i] forState:UIControlStateNormal];
        [item setTitleColor:titleColors[i] forState:UIControlStateNormal];
        item.layer.masksToBounds = YES;
        item.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [item addTarget:self action:@selector(publishEvents:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        [self.containers addObject:item];
    }
    __block UIButton* anchor = nil;
    [self.containers enumerateObjectsUsingBlock:^(UIButton*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(heightEx(35.f)));
            make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0.f);
            if (anchor == nil) {
                make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
                make.width.mas_equalTo(kScreenWidth/2.f - 5*padding);
            }
            else{
                make.left.mas_equalTo(anchor.mas_right).with.offset(padding);
                make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
            }
        }];
        anchor = obj;
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.containers enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.masksToBounds = YES;
        obj.layer.cornerRadius  =  CGRectGetHeight(obj.frame)/2.f;
    }];
}
@end
