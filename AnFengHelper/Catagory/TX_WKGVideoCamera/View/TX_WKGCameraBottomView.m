//
//  TX_WKGCameraBottomView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKGCameraBottomView.h"
#import "TX_WKG_CameraOptItem.h"
#import "TX_WKG_Video_OptOnlyImgItem.h"

@interface TX_WKGCameraBottomView ()
@property (strong, nonatomic) NSMutableArray * items;
@property (strong, nonatomic) NSMutableArray * containers;
@property (strong, nonatomic) TX_WKG_Video_OptOnlyImgItem * videoCameraControlItemView;
@end

@implementation TX_WKGCameraBottomView


-(TX_WKG_Video_OptOnlyImgItem *)videoCameraControlItemView{
    _videoCameraControlItemView = ({
        if (!_videoCameraControlItemView) {
            _videoCameraControlItemView = [[TX_WKG_Video_OptOnlyImgItem alloc]init];
            [_videoCameraControlItemView configParamImgString:@"tx_wkg_camera_normal_bg_black" highlight:@"tx_wkg_camera_highlight_bg_black" indefiner:@"拍照"];
            __weak typeof(self)weakSelf = self;
            _videoCameraControlItemView.callback = ^(id item) {
                TX_WKG_Video_OptOnlyImgItem * optItem = (TX_WKG_Video_OptOnlyImgItem*)item;
                if (weakSelf.callback) {
                    weakSelf.callback(optItem.indefiner);
                }
            };
        }
        _videoCameraControlItemView;
    });
    return _videoCameraControlItemView;
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
//type:YES 控件颜色是深色 NO：白色
-(void)settingCameraBottomControllsColor:(NSString*)type{
    if ([type isEqualToString:@"YES"]) {
        self.items = @[@{@"title":@"导入",@"normal":@"tx_wkg_cameraExport_bg_white"},
                       @{@"title":@"滤镜",@"normal":@"tx_wkg_camera_effect_bg_white"},
                       ].mutableCopy;
          [_videoCameraControlItemView configParamImgString:@"tx_wkg_videoNormal" highlight:@"tx_wkg_videoHighlight" indefiner:@"拍照"];
    }else{
        self.items = @[@{@"title":@"导入",@"normal":@"tx_wkg_cameraExport_bg_black"},
                       @{@"title":@"滤镜",@"normal":@"tx_wkg_camera_effect_bg_black"},
                       ].mutableCopy;
        [_videoCameraControlItemView configParamImgString:@"tx_wkg_camera_normal_bg_black" highlight:@"tx_wkg_camera_highlight_bg_black" indefiner:@"拍照"];
    }
    for (int i = 0; i < self.items.count; i++) {
        TX_WKG_CameraOptItem * item = self.containers[i];
        NSDictionary * json = self.items[i];
        [item configParamImgString:json[@"normal"] highlight:json[@"normal"] indefiner:json[@"title"]];
        if ([type isEqualToString:@"YES"]) {
            item.title_label.textColor = [UIColor grayColor];
        }else{
            item.title_label.textColor = [UIColor whiteColor];
        }
    }
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    self.items = @[@{@"title":@"导入",@"normal":@"tx_wkg_cameraExport_bg_black"},
                   @{@"title":@"滤镜",@"normal":@"tx_wkg_camera_effect_bg_black"},
                   ].mutableCopy;
    for (int i = 0; i < self.items.count; i++) {
        TX_WKG_CameraOptItem * item = [[TX_WKG_CameraOptItem alloc]init];
        item.callback = ^(id item) {
            if ([item isKindOfClass:[TX_WKG_CameraOptItem class]]) {
                TX_WKG_CameraOptItem * edit_item = (TX_WKG_CameraOptItem*)item;
                if (weakSelf.callback) {
                    weakSelf.callback(edit_item.indefiner);
                }
            }
        };
        NSDictionary * json = self.items[i];
        [item configParamImgString:json[@"normal"] highlight:json[@"normal"] indefiner:json[@"title"]];
        item.title_label.text = json[@"title"];
        item.title_label.textColor = [UIColor whiteColor];
        [self addSubview:item];
        [self.containers addObject:item];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutObjectViews];
}

-(void)layoutObjectViews{
    __weak  typeof(self)weakSelf = self;
    __block TX_WKG_CameraOptItem * anchor = nil;
    [self addSubview:self.videoCameraControlItemView];
    [self.videoCameraControlItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(widthEx(80.f), heightEx(80.f)));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    __block CGFloat padding = widthEx(58.f);
    [self.containers enumerateObjectsUsingBlock:^(TX_WKG_CameraOptItem * item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMakeEx(50, 70));
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            if (anchor == nil) {
            make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
            }else{
            make.right.mas_equalTo(self.mas_right).with.offset(-padding);
            }
        }];
        anchor = item;
    }];
}

@end
