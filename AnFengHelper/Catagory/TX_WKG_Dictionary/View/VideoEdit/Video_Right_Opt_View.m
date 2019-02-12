//
//  Video_Right_Opt_View.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "Video_Right_Opt_View.h"
#import "TX_WKG_Video_EditOptItem.h"

@interface Video_Right_Opt_View()
@property (strong, nonatomic) NSMutableArray * containers;
@property (strong, nonatomic) NSMutableArray * items;

@end

@implementation Video_Right_Opt_View
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

-(NSMutableArray *)items{
    _items = ({
        if (!_items) {
            _items = [NSMutableArray array];
        }
        _items;
    });
    return _items;
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
    __weak typeof(self)weakSelf = self;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.01];
    self.items = @[
//                   @{@"title":@"旋转",@"normal":@"qmx_bianji_rotate"},
                   @{@"title":@"裁剪",@"normal":@"qmx_bianji_caijian"},
                   @{@"title":@"贴纸",@"normal":@"qmx_bianji_tiezhi"},
                   @{@"title":@"选封面",@"normal":@"qmx_bianji_fengmian"},
                   ].mutableCopy;
    for (int i = 0; i < self.items.count; i++) {
        TX_WKG_Video_EditOptItem * item = [[TX_WKG_Video_EditOptItem alloc]init];
        item.callback = ^(id item) {
            if ([item isKindOfClass:[TX_WKG_Video_EditOptItem class]]) {
                TX_WKG_Video_EditOptItem * edit_item = (TX_WKG_Video_EditOptItem*)item;
                if (weakSelf.opt_callback) {
                    weakSelf.opt_callback(edit_item.indefiner);
                }
            }
        };
        NSDictionary * json = self.items[i];
        [item configParamImgString:json[@"normal"] title:json[@"title"] indefiner:json[@"title"]];
        [self addSubview:item];
        [self.containers addObject:item];
    }
}
-(void)setHidden:(BOOL)hidden opt:(NSString*)title{
    //item idx
    __block  NSMutableArray * containers;
    containers = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * key = obj[@"title"];
        [containers addObject:key];
    }];
    if (![containers containsObject:title])return;
    NSInteger idx  = [containers indexOfObject:title];
    TX_WKG_Video_EditOptItem * item = [self.containers objectAtIndex:idx];
    [item setHidden:hidden];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutObjectViews];
}

-(void)layoutObjectViews{
    __weak  typeof(self)weakSelf = self;
    __block TX_WKG_Video_EditOptItem * anchor = nil;
    [self.containers enumerateObjectsUsingBlock:^(TX_WKG_Video_EditOptItem * item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMakeEx(50, 70));
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
            if (anchor == nil) {
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(0);
            }else{
        make.top.mas_equalTo(anchor.mas_bottom).with.offset(0);
            }
        }];
        anchor = item;
    }];
}

@end
