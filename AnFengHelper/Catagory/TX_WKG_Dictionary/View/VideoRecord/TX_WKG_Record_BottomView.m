//
//  TX_WKG_Record_BottomView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Record_BottomView.h"
#import "TX_WKG_VideoRecord_Item.h"
#import "TX_WKG_Video_OptOnlyImgItem.h"
@interface TX_WKG_Record_BottomView()
@property (strong, nonatomic) NSMutableArray * items;
@property (strong, nonatomic) NSMutableArray *containers;
@property (assign, nonatomic) BOOL  preOptStatus;
@end

@implementation TX_WKG_Record_BottomView
#pragma mark - getter methods
-(NSMutableArray *)items{
    _items = ({
        if (!_items) {
            _items = [NSMutableArray array];
        }
        _items;
    });
    return _items;
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
        [self configData];
        [self setObjectView];
    }
    return self;
}
-(void)configData{
    self.items = @[@{@"img":@"qmx_paishe_lvjing",@"highlight":@"qmx_paishe_lvjing",@"title":@"特效滤镜"},
    @{@"img":@"qmx_paishe_shipin",@"highlight":@"qmx_paishe_shipin",@"title":@"导入视频"},
    @{@"img":@"qmx_paishe_huishan",@"highlight":@"qmx_paishe_huishanlv",@"title":@"回删"}].mutableCopy;
}

-(void)setObjectView{
    self.preOptStatus = NO;
    for (int i = 0; i < 2; i++) {
        TX_WKG_Video_OptOnlyImgItem  * item = (TX_WKG_Video_OptOnlyImgItem*)[[TX_WKG_Video_OptOnlyImgItem alloc]init];
        __weak typeof(self)weakSelf = self;
        item.callback = ^(id item) {
            if (weakSelf.eventCallback) {
                if ([item isKindOfClass:[TX_WKG_Video_OptOnlyImgItem class]]) {
                    TX_WKG_Video_OptOnlyImgItem * recordItem = (TX_WKG_Video_OptOnlyImgItem*)item;
                    weakSelf.eventCallback(recordItem.indefiner);
                }
            }
        };
        NSDictionary * param = self.items[i];
        [item configParamImgString:param[@"img"] highlight:param[@"highlight"] indefiner:param[@"title"]];
        [self.containers addObject:item];
        [self addSubview:item];
    }
}

//视频回删功能
-(void)loadbackDeleteVideoView:(BOOL)isbackDelete{
    TX_WKG_Video_OptOnlyImgItem * item = (TX_WKG_Video_OptOnlyImgItem*)[self.containers lastObject];
    if (isbackDelete) {
        if (_preOptStatus == NO) {
            NSDictionary * json = [self.items lastObject];
            [item configParamImgString:json[@"img"] highlight:json[@"highlight"] indefiner:json[@"title"]];
        }
        isbackDelete = _preOptStatus;
    }else{
        NSDictionary * json = self.items[1];
        [item configParamImgString:json[@"img"] highlight:json[@"highlight"] indefiner:json[@"title"]];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutObjectViews];
}

-(void)layoutObjectViews{
    __weak  typeof(self)weakSelf = self;
    __block CGFloat padding = widthEx(45.f);
    __block TX_WKG_VideoRecord_Item * anchor = nil;
    [self.containers enumerateObjectsUsingBlock:^(TX_WKG_VideoRecord_Item * item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMakeEx(50, 60));
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            if (anchor == nil) {
            make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
            }else{
            make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
            }
        }];
        anchor = item;
    }];
}

@end
