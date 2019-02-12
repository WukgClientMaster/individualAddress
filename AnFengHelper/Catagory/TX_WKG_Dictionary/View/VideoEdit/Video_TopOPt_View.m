//
//  Video_TopOPt_View.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "Video_TopOPt_View.h"

#define KVIDEO_EDIT_OPTIONAL_TAGVALUE 1000
@interface Video_TopOPt_View()
@property (strong, nonatomic) NSMutableArray * items;
@property (strong, nonatomic) NSMutableArray * containers;

@end
@implementation Video_TopOPt_View

#pragma mark - IBOutlet Events
-(void)optEvents:(UIButton*)args{
    if (self.opt_callback) {
        NSInteger tagValue = args.tag - KVIDEO_EDIT_OPTIONAL_TAGVALUE;
        NSDictionary * json = self.items[tagValue];
        NSString * title = (NSString*)[[json allKeys]firstObject];
        self.opt_callback(args,title);
    }
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
                   @{@"返回":@{@"normal":@"qmx_tuijian_arrow",@"selected":@"qmx_tuijian_arrow"}},
                   @{@"原音": @{@"normal":@"qmx_bianji_yiliang",@"selected":@"qmx_bianji_yiliang"}},
                   @{@"音乐":@{@"normal":@"qmx_bianji_music",@"selected":@"qmx_music_icon"}},
                    @{@"特效":@{@"normal":@"qmx_bianji_texiao",@"selected":@"qmx_bianji_texiao"}},
                   ].mutableCopy;
    for (int i = 0 ; i < self.items.count; i++) {
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.tag = KVIDEO_EDIT_OPTIONAL_TAGVALUE + i;
        NSDictionary * json = self.items[i];
        NSDictionary * valueDictionary = (NSDictionary*)[[json allValues]firstObject];
        UIImage * selectedImg = [UIImage imageNamed:valueDictionary[@"selected"]];
        UIImage * normalImg =  [UIImage imageNamed:valueDictionary[@"normal"]];
        [item setImage:selectedImg forState:UIControlStateSelected];
        [item setImage:nil forState:UIControlStateHighlighted];
        [item setImage:normalImg forState:UIControlStateNormal];
        [item addTarget:self action:@selector(optEvents:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        [self.containers addObject:item];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    __block  UIButton * anchor = nil;
    __block CGFloat  padding = widthEx(12.f);
    __weak  typeof(self)weakSelf = self;
    [self.containers enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0.f);
            if (anchor == nil && idx == 0) {
            make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
            }else if(anchor == nil){
            make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding*1.5);
            }else{
            make.right.mas_equalTo(anchor.mas_left).with.offset(-padding*2);
            }
        }];
        if (idx != 0) {
            anchor = obj;
        }
    }];
}

-(void)setSelectedStatus:(BOOL)selected opt:(NSString*)title{
    //item idx
    __block  NSMutableArray * containers;
    containers = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * key = (NSString*)[[obj allKeys]firstObject];
        [containers addObject:key];
    }];
    if (![containers containsObject:title])return;
    NSInteger idx  = [containers indexOfObject:title];
    UIButton * item = [self.containers objectAtIndex:idx];
    [item setSelected:selected];
}

-(void)setSelectedEnable:(BOOL)enable opt:(NSString*)title{
    __block  NSMutableArray * containers;
    containers = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * key = (NSString*)[[obj allKeys]firstObject];
        [containers addObject:key];
    }];
    if (![containers containsObject:title])return;
    NSInteger idx  = [containers indexOfObject:title];
    UIButton * item = [self.containers objectAtIndex:idx];
    [item setEnabled:enable];
}

@end
