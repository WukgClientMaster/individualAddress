//
//  TX_WKG_Photo_MosaicView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//
#define  TX_WKG_MosaicV_PencilFont_ItemTagValue  1000

#import "TX_WKG_Photo_MosaicView.h"
#import "TX_WKG_Video_OptOnlyImgItem.h"
#import "TX_WKG_Photo_EditConfig.h"

@interface TX_WKG_Photo_MosaicView()
@property (strong, nonatomic) NSMutableArray  * containers;
@property (strong, nonatomic) NSMutableArray * pencils;

@property (strong, nonatomic) UIButton * selectedPencilItem;
@end

@implementation TX_WKG_Photo_MosaicView

-(NSMutableArray *)containers{
    _containers = ({
        if (!_containers) {
            _containers = [NSMutableArray array];
        }
        _containers;
    });
    return _containers;
}

-(NSMutableArray *)pencils{
    _pencils = ({
        if (!_pencils) {
            _pencils = [NSMutableArray array];
        }
        _pencils;
    });
    return _pencils;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)pencilEvnets:(UIButton*)args{
    if (![args isEqual:self.selectedPencilItem]) {
        args.selected = YES;
        self.selectedPencilItem.selected = NO;
        self.selectedPencilItem = args;
        NSDictionary * json = self.pencils[args.tag - TX_WKG_MosaicV_PencilFont_ItemTagValue];
        NSInteger lineWidth = [json[@"title"]integerValue];
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_PHOTO_NEWDECOMMEND_ADDLINEWIDTH_MOSAIC_EFFECTIVE_NOTIFICATION_DEFINER  object:@(lineWidth)];
    }
}

-(void)setup{
    self.backgroundColor = [UIColor whiteColor];
    //  @{@"title":@"橡皮擦", @"normal":@"tx_wkg_photo_optional_close"},
    NSArray * items = @[
                      @{@"title":@"马赛克", @"normal":@"tx_wkg_photo_scratch"}
                    ];
    self.backgroundColor = [UIColor whiteColor];
    __weak  typeof(self)weakSelf =  self;
    for (int i = 0; i < items.count; i++) {
        TX_WKG_Video_OptOnlyImgItem * item = [[TX_WKG_Video_OptOnlyImgItem alloc]init];
        NSDictionary * json = items[i];
        item.callback = ^(id item) {
            if ([item isKindOfClass:[TX_WKG_Video_OptOnlyImgItem class]]) {
                TX_WKG_Video_OptOnlyImgItem * onlyItem = (TX_WKG_Video_OptOnlyImgItem*)item;
                if(weakSelf.mosaicCallback) {
                    weakSelf.mosaicCallback(onlyItem.indefiner);
                }
            }
        };
        [item configParamImgString:json[@"normal"] indefiner:json[@"title"]];
        item.imageView.contentMode = UIViewContentModeCenter;
        item.layer.masksToBounds = YES;
        item.layer.borderWidth  = widthEx(3.f);
        item.layer.cornerRadius = widthEx(3.f);
        item.layer.borderColor = KSYUIColorFromRGB(236, 92, 96).CGColor;
        [self addSubview:item];
        [self.containers addObject:item];
    }
    __block CGFloat padding = widthEx(20.f);
    __block TX_WKG_Video_OptOnlyImgItem * anchor = nil;
    [self.containers enumerateObjectsUsingBlock:^(TX_WKG_Video_OptOnlyImgItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mas_top).with.offset(heightEx(15.5));
            make.size.mas_equalTo(CGSizeMake(widthEx(167/80.f * 30), widthEx(30.f)));
            if (anchor == nil) {
            make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
            }else{
            make.left.mas_equalTo(anchor.mas_right).with.offset(widthEx(28.5f));
            }
        }];
        anchor = obj;
    }];
    [self loadPencilSubViews];
}

-(void)loadPencilSubViews{
    NSArray * items = @[@{@"title":@"2",@"normal":@"tx_wkg_num1_pencil_normal",@"selected":@"tx_wkg_num1_pencil_selected"},
                        @{@"title":@"4",@"normal":@"tx_wkg_num2_pencil_normal",@"selected":@"tx_wkg_num2_pencil_selected"},
                        @{@"title":@"6",@"normal":@"tx_wkg_num3_pencil_normal",@"selected":@"tx_wkg_num3_pencil_selected"},
                        @{@"title":@"8",@"normal":@"tx_wkg_num4_pencil_normal",@"selected":@"tx_wkg_num4_pencil_selected"}];
    [self.pencils addObjectsFromArray:items];
    NSMutableArray * containers = [NSMutableArray array];
    for (int i = 0; i< items.count; i++) {
        NSDictionary * json = items[i];
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setImage:[UIImage imageNamed:json[@"normal"]] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:json[@"selected"]] forState:UIControlStateSelected];
        [item addTarget:self action:@selector(pencilEvnets:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = TX_WKG_MosaicV_PencilFont_ItemTagValue + i;
        if (i == 0) {
            self.selectedPencilItem = item;
            [item setSelected:YES];
        }
        [self addSubview:item];
        [containers addObject:item];
    }
    __weak typeof(self)weakSelf = self;
    __block CGFloat padding = widthEx(25.f);
    CGFloat margin = padding * (0.5 + 0.75 + 1.f);
    __block CGFloat left_originX  = (kScreenWidth - margin -items.count *widthEx(35.f))/2.f;
    __block UIButton * anchor = nil;
    [containers enumerateObjectsUsingBlock:^(UIButton *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(widthEx(35.f) ,widthEx(35.f)));
            make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-heightEx(20.f));
            if (anchor == nil) {
                make.left.mas_equalTo(weakSelf.mas_left).with.offset(left_originX);
            }else{
                make.left.mas_equalTo(anchor.mas_right).with.offset(padding);
            }
        }];
        anchor = obj;
    }];
}
@end
