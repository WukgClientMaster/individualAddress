//
//  TX_WKGOptCameraOverView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKGOptCameraOverView.h"
#import "TX_WKG_CameraOptItem.h"

#define TX_WKG_SETTING_RATIO_TAG_VALUE  1000

@interface TX_WKGOptCameraOverView()
@property (strong, nonatomic) NSMutableArray * items;
@property (strong, nonatomic) NSMutableArray * containers;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *ratioContrainers;
@property (strong, nonatomic) UIImageView * selectedImageView;
@property (strong, nonatomic) UIButton * selectedOptItem;
@property (strong, nonatomic) UIImageView * overbackgroundImageView;
@end

@implementation TX_WKGOptCameraOverView
#pragma mark - IBOutlet Events
-(void)exchangeRatioEvents:(UIButton*)args{
    if (![args isEqual:self.selectedOptItem]) {
        NSDictionary * json = @{@(1000):@"9-16",@(1001):@"3-4",@(1002):@"1-1"};
        if (self.callback) {
            NSNumber * key = [NSNumber numberWithInteger:args.tag];
            self.callback(json[key]);
        }
        args.transform = CGAffineTransformScale(args.transform, 1.1, 1.1);
        self.selectedOptItem.transform = CGAffineTransformIdentity;
        self.selectedOptItem = args;
        [self.selectedImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(args.mas_centerX);
            make.centerY.mas_equalTo(args.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(args.frame)*1.2, CGRectGetHeight(args.frame)*1.2));
        }];
    }
}
#pragma mark - getter methods
-(UIImageView *)overbackgroundImageView{
    _overbackgroundImageView = ({
        if (!_overbackgroundImageView) {
            _overbackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            UIImage * image = [UIImage imageNamed:@"tx_wkg_cameraOpt_Over_bg"];
            _overbackgroundImageView.image = image;
            _overbackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        _overbackgroundImageView;
    });
    return _overbackgroundImageView;
}

-(UIImageView *)selectedImageView{
    _selectedImageView = ({
        if (!_selectedImageView) {
            UIImage * img = [UIImage imageNamed:@"tx_wkg_ratio_selected_item"];
            _selectedImageView = [[UIImageView alloc]initWithImage:img];
            _selectedImageView.contentMode = UIViewContentModeCenter;
        }
        _selectedImageView;
    });
    return _selectedImageView;
}

-(UIView *)lineView{
    _lineView = ({
        if (!_lineView) {
            _lineView = [[UIView alloc]initWithFrame:CGRectZero];
            _lineView.backgroundColor = [UIColor whiteColor];
        }
        _lineView;
    });
    return _lineView;
}

-(NSMutableArray *)ratioContrainers{
    _ratioContrainers = ({
        if (!_ratioContrainers) {
            _ratioContrainers = [NSMutableArray array];
        }
        _ratioContrainers;
    });
    return _ratioContrainers;
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
-(void)settingTX_WKG_CameraOverViewControlStatusWithOptType:(NSString*)optType{
    NSDictionary * json = nil;
    NSInteger idx = 0;
    for(int i = 0; i < self.items.count; i++) {
        json = self.items[i];
        idx  = i;
        if ([json[@"optType"] isEqualToString:optType]) {
            break;
        }
    }
    if (json == nil) return;
    if ([optType hasPrefix:@"延迟"]) {
        idx = 0;
    }else{
        idx = 1;
    }
    TX_WKG_CameraOptItem * item = self.containers[idx];
    [item configParamImgString:json[@"normal"] title:json[@"title"] indefiner:json[@"title"] optType:json[@"optType"]];
    item.title_label.text = json[@"title"];
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    [self addSubview:self.overbackgroundImageView];
    [self.overbackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsZero);
    }];
    self.items = @[
                   @{@"optType":@"延迟拍摄",@"title":@"延迟拍摄",@"normal":@"delay_camera_normal",@"highlight":@"delay_camera_highlight"},
                   @{@"optType":@"闪光灯关闭",@"title":@"闪光灯",@"normal":@"flashlight_close_normal",@"highlight":@"flashlight_close_normal"},
                   @{@"optType":@"闪光灯",@"title":@"闪光灯",@"normal":@"flashlight_normal",@"highlight":@"flashlight_highlight"},
                   @{@"optType":@"延迟拍摄关闭",@"title":@"延迟拍摄",@"normal":@"delay_camera_close_normal",@"highlight":@"delay_camera_close_highlight"},
                   ].mutableCopy;
    for (int i = 0; i < self.items.count / 2; i++) {
        TX_WKG_CameraOptItem * item = [[TX_WKG_CameraOptItem alloc]init];
        item.callback = ^(id item) {
            if ([item isKindOfClass:[TX_WKG_CameraOptItem class]]) {
                TX_WKG_CameraOptItem * cameraItem = (TX_WKG_CameraOptItem*)item;
                if (weakSelf.callback) {
                    weakSelf.callback(cameraItem.optType);
                }
            }
        };
        NSDictionary * json = self.items[i];
        [item configParamImgString:json[@"normal"] title:json[@"title"] indefiner:json[@"title"] optType:json[@"optType"]];
        item.title_label.text = json[@"title"];
        item.title_label.font = [UIFont systemFontOfSize:11.f];
        [self addSubview:item];
        [self.containers addObject:item];
    }
    [self layoutSubjectViews];
}

-(void)layoutSubjectViews{
    __weak typeof(self)weakSelf = self;
    __block CGFloat padding = widthEx(25.f);
    __block CGFloat height_padding = heightEx(40.f);
    __block TX_WKG_CameraOptItem * anchor = nil;
    [self.containers enumerateObjectsUsingBlock:^(TX_WKG_CameraOptItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 50));
            make.top.mas_equalTo(weakSelf.mas_top).with.offset(height_padding/2.f);
            if (anchor == nil) {
                make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
            }else{
                make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
            }
        }];
        anchor = obj;
    }];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(anchor.mas_bottom).with.offset(height_padding/2.f);
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding/2.f);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding/2.f);
        make.height.mas_equalTo(@(heightEx(1.f)));
    }];
    //设置拍摄的比例
    NSArray * imgs = @[@"tx_wkg_ratio16-9",@"tx_wkg_ratio4-3",@"tx_wkg_ratio1-1"];
    for (int i = 0; i < imgs.count; i++) {
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        item.imageView.contentMode = UIViewContentModeCenter;
        [item addTarget:self action:@selector(exchangeRatioEvents:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = TX_WKG_SETTING_RATIO_TAG_VALUE + i;
        [self addSubview:item];
        [self.ratioContrainers addObject:item];
        if (i == 0) {
            self.selectedOptItem = item;
            item.transform = CGAffineTransformScale(item.transform, 1.1, 1.1);
        }
    }
    __block CGFloat ratio_padding   = widthEx(18.f);
    __block UIButton* ratio_anchor  = nil;
    [self.ratioContrainers enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(widthEx(35),heightEx(35)));
            if (SC_iPhoneX) {
                make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-heightEx(18.f));
            }else{
                make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-heightEx(12.f));
            }
            if (ratio_anchor == nil) {
                make.left.mas_equalTo(weakSelf.mas_left).with.offset(ratio_padding);
            }else{
                make.left.mas_equalTo(ratio_anchor.mas_right).with.offset(widthEx(15.f));
            }
        }];
        ratio_anchor = obj;
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof(self)weakSelf = self;
    if (![[self subviews]containsObject:self.selectedImageView]) {
        [self addSubview:self.selectedImageView];
        [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(weakSelf.selectedOptItem.frame) * 1.2, CGRectGetHeight(weakSelf.selectedOptItem.frame)*1.2));
            make.centerX.mas_equalTo(weakSelf.selectedOptItem.mas_centerX);
            make.centerY.mas_equalTo(weakSelf.selectedOptItem.mas_centerY);
        }];
    }else{
        [self.selectedImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(CGRectGetWidth(weakSelf.selectedOptItem.frame) * 1.2, CGRectGetHeight(weakSelf.selectedOptItem.frame)*1.2));
            make.centerX.mas_equalTo(weakSelf.selectedOptItem.mas_centerX);
            make.centerY.mas_equalTo(weakSelf.selectedOptItem.mas_centerY);
        }];
    }
}

@end
