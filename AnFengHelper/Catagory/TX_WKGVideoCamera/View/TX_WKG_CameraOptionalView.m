//
//  TX_WKG_CameraOptionalView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_CameraOptionalView.h"
#define  KVIDEO_CAMERA_OPTIONAL_TAGVALUE 1000

@interface TX_WKG_CameraOptionalView()
@property (strong, nonatomic) NSMutableArray * items;
@property (strong, nonatomic) NSMutableArray * containers;
@property (copy,readwrite,nonatomic) NSString * optionalBeautyisClosed;//美颜是否关闭
@property (copy,readwrite,nonatomic) NSString * optionalCurrentControlColor;//当前视图控件是颜色 YES 深色: NO:白色
@end

@implementation TX_WKG_CameraOptionalView

#pragma mark - IBOutlet EVENTS

-(void)optEvents:(UIButton*)args{
    if (self.opt_callback) {
        NSInteger tagValue = args.tag - KVIDEO_CAMERA_OPTIONAL_TAGVALUE;
        NSDictionary * json = self.items[tagValue];
        NSString * title = (NSString*)[[json allKeys]firstObject];
        self.opt_callback(args,title);
    }
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
-(void)settingCameraOptionalControllsColor:(NSString*)type{
    NSDictionary * beautyJson;
    //optionalCurrentControlColor;//当前视图控件是颜色 YES 深色: NO:白色
    if ([self.optionalBeautyisClosed isEqualToString:@"YES"]) {
        if ([type isEqualToString:@"YES"]) {
             beautyJson =  @{@"美颜":@{@"normal":@"tx_wkg_camera_beauty_close_bg_white",@"selected":@"tx_wkg_camera_beauty_close_bg_white"}};
        }else{
            beautyJson =  @{@"美颜":@{@"normal":@"tx_wkg_camera_beauty_close_bg_black",@"selected":@"tx_wkg_camera_beauty_close_bg_black"}};
        }
    }else{
        if ([type isEqualToString:@"NO"]) {
            beautyJson = @{@"美颜":@{@"normal":@"tx_wkg_camera_beauty_bg_black",@"selected":@"tx_wkg_camera_beauty_bg_black"}};
        }else
        beautyJson = @{@"美颜":@{@"normal":@"tx_wkg_camera_beauty_bg_white",@"selected":@"tx_wkg_camera_beauty_bg_white"}};
    }
    if ([type isEqualToString:@"YES"]) {
        self.optionalCurrentControlColor = @"YES";
        self.items =  @[
                        @{@"返回":@{@"normal":@"tx_wkg_camera_dismiss_bg_white",@"selected":@"tx_wkg_camera_dismiss_bg_white"}},
                        @{@"更多": @{@"normal":@"tx_wkg_camera_more_bg_white",@"selected":@"tx_wkg_camera_more_bg_white"}},
                        beautyJson,
                        @{@"旋转":@{@"normal":@"tx_wkg_camera_rotate_bg_white",@"selected":@"tx_wkg_camera_rotate_bg_white"}},
                        ].mutableCopy;
    }else{
        self.optionalCurrentControlColor = @"NO";
        self.items =  @[
                        @{@"返回":@{@"normal":@"tx_wkg_camera_dismiss_bg_black",@"selected":@"tx_wkg_camera_dismiss_bg_black"}},
                        @{@"更多": @{@"normal":@"tx_wkg_camera_more_bg_black",@"selected":@"tx_wkg_camera_more_bg_black"}},
                        beautyJson,
                        @{@"旋转":@{@"normal":@"tx_wkg_camera_rotate_bg_black",@"selected":@"tx_wkg_camera_rotate_bg_black"}},
                        ].mutableCopy;
    }
    for (int i = 0; i < self.items.count; i++) {
        UIButton * item = self.containers[i];
        NSDictionary * json = self.items[i];
        NSDictionary * valueJson = [[json allValues]firstObject];
        UIImage * normalImage = [UIImage imageNamed:valueJson[@"normal"]];
        UIImage * selectedImage = [UIImage imageNamed:valueJson[@"selected"]];
        [item setImage:normalImage forState:UIControlStateNormal];
        [item setImage:selectedImage forState:UIControlStateSelected];
    }
}

-(void)setSelectedStatus:(BOOL)selected opt:(NSString*)title{
    NSInteger idx = 0;
    for (int i = 0; i < self.items.count; i++) {
        NSDictionary * json = self.items[i];
        NSString * key = (NSString*)[[json allKeys]firstObject];
        if ([title isEqualToString:key]) {
            idx = i;
            break;
        }
    }
    //optionalCurrentControlColor;//当前视图控件是颜色 YES 深色: NO:白色
    if (selected) {
        self.optionalBeautyisClosed = @"YES";
        NSDictionary * json = nil;
        if ([self.optionalCurrentControlColor isEqualToString:@"YES"]) {
            json = @{@"美颜":@{@"normal":@"tx_wkg_camera_beauty_close_bg_white",@"selected":@"tx_wkg_camera_beauty_close_bg_white"}};
        }else{
            json = @{@"美颜":@{@"normal":@"tx_wkg_camera_beauty_close_bg_black",@"selected":@"tx_wkg_camera_beauty_close_bg_black"}};
        }
        UIButton * item = self.containers[idx];
        NSDictionary * valueJson = [[json allValues]firstObject];
        [item setImage:[UIImage imageNamed:valueJson[@"normal"]] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:valueJson[@"selected"]] forState:UIControlStateSelected];
    }else{
        self.optionalBeautyisClosed = @"NO";
        NSDictionary * json = nil;
        if ([self.optionalCurrentControlColor isEqualToString:@"YES"]) {
            json = @{@"美颜":@{@"normal":@"tx_wkg_camera_beauty_bg_white",@"selected":@"tx_wkg_camera_beauty_bg_white"}};
        }else{
            json = @{@"美颜":@{@"normal":@"tx_wkg_camera_beauty_bg_black",@"selected":@"tx_wkg_camera_beauty_bg_black"}};
        }
        NSDictionary * valueJson = [[json allValues]firstObject];
        UIButton * item = self.containers[idx];
        [item setImage:[UIImage imageNamed:valueJson[@"normal"]] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:valueJson[@"selected"]] forState:UIControlStateSelected];
    }
}

-(void)setup{
    self.optionalBeautyisClosed = @"NO";
    self.items =  @[
                    @{@"返回":@{@"normal":@"tx_wkg_camera_dismiss_bg_black",@"selected":@"tx_wkg_camera_dismiss_bg_black"}},
                    @{@"更多": @{@"normal":@"tx_wkg_camera_more_bg_black",@"selected":@"tx_wkg_camera_more_bg_black"}},
                    @{@"美颜":@{@"normal":@"tx_wkg_camera_beauty_bg_black",@"selected":@"tx_wkg_camera_beauty_bg_black"}},
                    @{@"旋转":@{@"normal":@"tx_wkg_camera_rotate_bg_black",@"selected":@"tx_wkg_camera_rotate_bg_black"}},
                    ].mutableCopy;
    for (int i = 0 ; i < self.items.count; i++) {
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.tag = KVIDEO_CAMERA_OPTIONAL_TAGVALUE + i;
        NSDictionary * json = self.items[i];
        NSDictionary * valueDictionary = (NSDictionary*)[[json allValues]firstObject];
        UIImage * selectedImg = [UIImage imageNamed:valueDictionary[@"selected"]];
        UIImage * normalImg =  [UIImage imageNamed:valueDictionary[@"normal"]];
        [item setImage:selectedImg forState:UIControlStateSelected];
        [item setImage:nil forState:UIControlStateHighlighted];
        [item setImage:normalImg forState:UIControlStateNormal];
        [item addTarget:self action:@selector(optEvents:) forControlEvents:UIControlEventTouchUpInside];
        item.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:item];
        [self.containers addObject:item];
    }
    [self layoutViews];
}

-(void)layoutViews{
    __weak typeof(self)weakSelf = self;
    __block CGFloat padding = widthEx(12.f);
    __block UIButton * anchor = nil;
    __block CGFloat margin = (KScreenWidth - 2*padding - widthEx(30*4))/3.f;
    [self.containers enumerateObjectsUsingBlock:^(UIButton* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0.f);
            make.size.mas_equalTo(CGSizeMake(widthEx(30),widthEx(30)));
            if (anchor == nil) {
            make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
            }else{
            make.left.mas_equalTo(anchor.mas_right).with.offset(margin);
            }
        }];
        anchor = obj;
    }];
}

@end
