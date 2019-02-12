//
//  PhotoInterruptView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/10.
//  Copyright © 2018年 NRH. All rights reserved.
//
#define KPHOTOINTERRUPT_OPTIONAL_TAGVALUE 1000

#import "PhotoInterruptView.h"

@interface PhotoInterruptView()
@property (strong, nonatomic) NSMutableArray * items;
@property (strong, nonatomic) NSMutableArray * containers;
@property (strong, nonatomic) UILabel * title_label;
@end


@implementation PhotoInterruptView

-(void)optEvents:(UIButton*)args{
    if (self.opt_callback) {
        NSInteger tagValue = args.tag - KPHOTOINTERRUPT_OPTIONAL_TAGVALUE;
        NSDictionary * json = self.items[tagValue];
        NSString * title = (NSString*)[[json allKeys]firstObject];
        self.opt_callback(args,title);
    }
}
#pragma mark - getter methods
-(UILabel *)title_label{
    _title_label = ({
        if (!_title_label) {
            _title_label = [[UILabel alloc]initWithFrame:CGRectZero];
            _title_label.font = [UIFont systemFontOfSize:widthEx(18.f)];
            _title_label.textColor = UIColorFromRGB(0x333333);
            _title_label.text = @"图片编辑";
        }
        _title_label;
    });
    return _title_label;
}
-(NSMutableArray *)containers{
    _containers = ({
        if (!_containers) {
            _containers = [NSMutableArray array];
        }
        _containers;
    });
    return _containers;
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
    self.items =  @[
                    @{@"返回":@{@"normal":@"tx_wkg_photo_dismiss",@"selected":@"tx_wkg_photo_dismiss"}},
                     @{@"下一步":@{@"normal":@"tx_wkg_photo_edit",@"selected":@"tx_wkg_photo_edit"}},
                    ].mutableCopy;
    for (int i = 0 ; i < self.items.count; i++) {
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.tag = KPHOTOINTERRUPT_OPTIONAL_TAGVALUE + i;
        NSDictionary * json = self.items[i];
        NSDictionary * valueDictionary = (NSDictionary*)[[json allValues]firstObject];
        if (i == self.items.count -1) {
            NSString * title = (NSString*)[[json allKeys]firstObject];
            [item setTitle:title forState:UIControlStateNormal];
            [item setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            item.titleLabel.font = [UIFont fontWithName:@"SimHei" size:widthEx(14.f)];
        }else{
            UIImage * selectedImg = [UIImage imageNamed:valueDictionary[@"selected"]];
            UIImage * normalImg =  [UIImage imageNamed:valueDictionary[@"normal"]];
            [item setImage:selectedImg forState:UIControlStateSelected];
            [item setImage:nil forState:UIControlStateHighlighted];
            [item setImage:normalImg forState:UIControlStateNormal];
        }
        [item addTarget:self action:@selector(optEvents:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        [self.containers addObject:item];
    }
    [self addSubview:self.title_label];
    [self layoutSubviews];
}

-(void)setSubControllWithTitle:(NSString*)title hidden:(BOOL)hidden{
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        __block NSInteger idx = 0;
        for (int i = 0; i < self.items.count; i++) {
            NSDictionary * json = self.items[i];
            NSString * key =  (NSString*)[[json allKeys]firstObject];
            if ([key isEqualToString:title]) {
                idx = i;
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton * optional_item = (UIButton*)self.containers[idx];
            [optional_item setHidden:hidden];
        });
    });
}

-(void)layoutSubviews{
    [super layoutSubviews];
    __block  UIButton * anchor = nil;
    __block CGFloat  padding = widthEx(12.f);
    __block CGFloat  offsetY = SC_iPhoneX ? 12 : 0;

    __weak  typeof(self)weakSelf = self;
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(offsetY);
    }];
    [self.containers enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(offsetY);
            if (anchor == nil) {
                make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
            }else{
                make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
            }
        }];
        anchor = obj;
    }];
}

@end
