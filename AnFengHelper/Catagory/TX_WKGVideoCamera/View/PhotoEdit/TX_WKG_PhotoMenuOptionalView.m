//
//  TX_WKG_PhotoMenuOptionalView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//

typedef void (^TX_WKG_PasterControl_EventsCallback)();
@interface TX_WKG_Paster_Control : UIControl

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * label;
@property (copy, nonatomic) TX_WKG_PasterControl_EventsCallback evnetsCallback;
-(void)setControlWithImageString:(NSString*)imageString text:(NSString*)text;

@end

@implementation TX_WKG_Paster_Control
-(void)pasterEvents:(UIControl*)control{
    if (self.evnetsCallback) {
        self.evnetsCallback();
    }
}

-(UIImageView *)imageView{
    _imageView = ({
        if (!_imageView) {
            _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        _imageView;
    });
    return _imageView;
}

-(UILabel *)label{
    _label = ({
        if (!_label) {
            _label = [[UILabel alloc]initWithFrame:CGRectZero];
            _label.textColor = [UIColor whiteColor];
            _label.font = [UIFont systemFontOfSize:12.f];
            _label.textAlignment = NSTextAlignmentCenter;
        }
        _label;
    });
    return _label;
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
    __block CGFloat padding = widthEx(4.f);
    [self addTarget:self action:@selector(pasterEvents:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding*3);
        make.size.mas_equalTo(CGSizeMake(widthEx(14), widthEx(14)));
    }];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).with.offset(padding*2);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
}

-(void)setControlWithImageString:(NSString*)imageString text:(NSString*)text{
    if (self.imageView) {
        self.imageView.image = [UIImage imageNamed:imageString];
    }
    if (self.label) {
        self.label.text = text;
    }
}

@end

#import "TX_WKG_PhotoMenuOptionalView.h"
#import "TX_WKG_Video_OptOnlyImgItem.h"
#import "TX_WKG_Photo_EditConfig.h"

@interface TX_WKG_PhotoMenuOptionalView()
@property (strong, nonatomic) UIView * lineView;
@property (strong, nonatomic) NSMutableArray * containers;
@property (strong, nonatomic) NSMutableArray * items;
@property (strong, nonatomic) TX_WKG_Paster_Control * paster_control_Item;

@end

@implementation TX_WKG_PhotoMenuOptionalView

#pragma mark - getter methods
-(TX_WKG_Paster_Control *)paster_control_Item{
    _paster_control_Item = ({
        if (!_paster_control_Item) {
            _paster_control_Item = [[TX_WKG_Paster_Control alloc]initWithFrame:CGRectZero];
            _paster_control_Item.layer.masksToBounds = YES;
            _paster_control_Item.layer.cornerRadius  = widthEx(15.f);
            _paster_control_Item.backgroundColor = UIColorFromRGB(0xfe4e5b);
            __weak typeof(self)weakSelf  = self;
            _paster_control_Item.evnetsCallback = ^{
                if (weakSelf.callback) {
                    weakSelf.callback(@"贴图");
                }
            };
        }
        _paster_control_Item;
    });
    return _paster_control_Item;
}

-(UIView *)lineView{
    _lineView = ({
        if (!_lineView) {
            _lineView = [[UIView alloc]initWithFrame:CGRectZero];
            _lineView.backgroundColor = UIColorFromRGB(0xdadada);
        }
        _lineView;
    });
    return _lineView;
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
-(NSMutableArray *)items{
    _items = ({
        if (!_items) {
            _items = [NSMutableArray array];
        }
        _items;
    });
    return _items;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = @[@{@"title":@"关闭", @"normal":@"tx_wkg_photo_optional_close",@"unenable":@"tx_wkg_photo_optional_close"},
                       @{  @"title":@"向前撤销", @"normal": @"tx_wkg_photo_optional_undo_unenable",@"unenable":@"tx_wkg_photo_optional_undo"},
                       @{  @"title":@"向后撤销", @"normal":@"tx_wkg_photo_optional_reback_unenable",@"unenable":@"tx_wkg_photo_optional_reback"},
                       @{  @"title":@"使用", @"normal":@"tx_wkg_photo_optional_use",@"unenable":@"tx_wkg_photo_optional_use"}
                       ].mutableCopy;
        _photoMenuType = TX_WKG_PhotoMenuEdit_Normal_Optional_Type;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tx_wkg_photo_edit_notification:) name:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:nil];
    }
    return self;
}
-(void)catgoryDataFilter{
    switch (_photoMenuType) {
        case TX_WKG_PhotoMenuEdit_Global_Optional_Type:
            self.items = @[
                           @{  @"title":@"向前撤销", @"normal": @"tx_wkg_photo_optional_undo_unenable",@"unenable":@"tx_wkg_photo_optional_undo"},
                           @{  @"title":@"向后撤销", @"normal":@"tx_wkg_photo_optional_reback_unenable",@"unenable":@"tx_wkg_photo_optional_reback"},
                           ].mutableCopy;
            break;
        case TX_WKG_PhotoMenuEdit_Clips_Optional_Type:
            self.items = @[@{@"title":@"关闭", @"normal":@"tx_wkg_photo_optional_close",@"unenable":@"tx_wkg_photo_optional_close"},
                           @{@"title":@"使用", @"normal":@"tx_wkg_photo_optional_use",@"unenable":@"tx_wkg_photo_optional_use"}
                           ].mutableCopy;
            break;
        case TX_WKG_PhotoMenuEdit_Normal_Optional_Type:
            self.items = @[@{@"title":@"关闭", @"normal":@"tx_wkg_photo_optional_close",@"unenable":@"tx_wkg_photo_optional_close"},
                           @{  @"title":@"向前撤销", @"normal": @"tx_wkg_photo_optional_undo_unenable",@"unenable":@"tx_wkg_photo_optional_undo"},
                           @{  @"title":@"向后撤销", @"normal":@"tx_wkg_photo_optional_reback_unenable",@"unenable":@"tx_wkg_photo_optional_reback"},
                           @{  @"title":@"使用", @"normal":@"tx_wkg_photo_optional_use",@"unenable":@"tx_wkg_photo_optional_use"}
                           ].mutableCopy;
            break;
        default:
            break;
    }
}


-(void)tx_wkg_photo_edit_notification:(NSNotification*)notification{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary * json = (NSDictionary*)object;
        [self catgoryDataFilter];
        [self adpaterContainerWithJson:json];
    }
}

-(void)adpaterContainerWithJson:(NSDictionary*)json{
    NSArray * opts = @[@"向前撤销",@"向后撤销"];
    for (int i = 0; i < self.items.count; i++) {
        NSDictionary * param = self.items[i];
        NSString * title = param[@"title"];
        for (int j = 0; j < opts.count; j++) {
            NSString * optString = opts[j];
            if ([optString isEqualToString:title]) {
                NSString * optValue = json[optString];
                TX_WKG_Video_OptOnlyImgItem * optOnlyImgItem = self.containers[i];
                if ([optValue isEqualToString:@"YES"]) {
                    NSString * imageString =  [optString  isEqualToString:@"向前撤销"] ? @"tx_wkg_photo_optional_undo":@"tx_wkg_photo_optional_reback";
                    [optOnlyImgItem configParamImgString:imageString indefiner:optString];
                }else if([optValue isEqualToString:@"NO"]){
                    NSString * imageString =  [optString  isEqualToString:@"向前撤销"] ? @"tx_wkg_photo_optional_undo_unenable":@"tx_wkg_photo_optional_reback_unenable";
                    [optOnlyImgItem configParamImgString:imageString indefiner:optString];
                }
            }
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:nil];
}

-(void)setPhotoMenuType:(TX_WKG_PhotoMenuEditType)photoMenuType{
    _photoMenuType = photoMenuType; //对图片操作类型
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.containers enumerateObjectsUsingBlock:^(TX_WKG_Video_OptOnlyImgItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            }];
        }];
        dispatch_barrier_async(dispatch_get_main_queue(), ^{
            [self.containers removeAllObjects];
            [self loadViewObjects];
        });
    });
}

-(void)loadViewObjects{
    switch (_photoMenuType) {
        case TX_WKG_PhotoMenuEdit_Global_Optional_Type:
            self.items = @[
                           @{  @"title":@"向前撤销", @"normal": @"tx_wkg_photo_optional_undo",@"unenable":@"tx_wkg_photo_optional_undo_unenable"},
                           @{  @"title":@"向后撤销", @"normal":@"tx_wkg_photo_optional_reback_unenable",@"unenable":@"tx_wkg_photo_optional_reback"},
                           ].mutableCopy;
            [self setup];
            break;
            
        case TX_WKG_PhotoMenuEdit_Clips_Optional_Type:
        case TX_WKG_PhotoMenuEdit_Middle_Paster_Optional_Event_Type:
            self.items = @[@{@"title":@"关闭", @"normal":@"tx_wkg_photo_optional_close",@"unenable":@"tx_wkg_photo_optional_close"},
                           @{@"title":@"使用", @"normal":@"tx_wkg_photo_optional_use",@"unenable":@"tx_wkg_photo_optional_use"}
                           ].mutableCopy;
            [self setup];
            break;
        case TX_WKG_PhotoMenuEdit_Normal_Optional_Type:
            self.items = @[@{@"title":@"关闭", @"normal":@"tx_wkg_photo_optional_close",@"unenable":@"tx_wkg_photo_optional_close"},
                           @{  @"title":@"向前撤销", @"normal": @"tx_wkg_photo_optional_undo_unenable",@"unenable":@"tx_wkg_photo_optional_undo"},
                           @{  @"title":@"向后撤销", @"normal":@"tx_wkg_photo_optional_reback_unenable",@"unenable":@"tx_wkg_photo_optional_reback"},
                           @{  @"title":@"使用", @"normal":@"tx_wkg_photo_optional_use",@"unenable":@"tx_wkg_photo_optional_use"}
                           ].mutableCopy;
            [self setup];
            break;
        default:
            break;
    }
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf);
        make.height.mas_equalTo(heightEx(1.f));
    }];
    self.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < self.items.count; i++) {
        TX_WKG_Video_OptOnlyImgItem * item = [[TX_WKG_Video_OptOnlyImgItem alloc]init];
        NSDictionary * json = self.items[i];
        item.callback = ^(id item) {
            if ([item isKindOfClass:[TX_WKG_Video_OptOnlyImgItem class]]) {
                TX_WKG_Video_OptOnlyImgItem * onlyItem = (TX_WKG_Video_OptOnlyImgItem*)item;
                if(weakSelf.callback) {
                    weakSelf.callback(onlyItem.indefiner);
                }
            }
        };
        [item configParamImgString:json[@"normal"] indefiner:json[@"title"]];
        [self addSubview:item];
        [self.containers addObject:item];
    }
    __block CGFloat padding = widthEx(24.f);
    __block TX_WKG_Video_OptOnlyImgItem * anchor = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.containers enumerateObjectsUsingBlock:^(TX_WKG_Video_OptOnlyImgItem  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(widthEx(35), heightEx(35)));
                make.centerY.mas_equalTo(weakSelf.mas_centerY);
                if (_photoMenuType == TX_WKG_PhotoMenuEdit_Normal_Optional_Type) {
                    if (anchor == nil) {
                        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
                    }else if(idx == 1){
                        make.right.mas_equalTo(weakSelf.mas_centerX).with.offset(-padding);
                    }else if (idx == 2){
                        make.left.mas_equalTo(weakSelf.mas_centerX).with.offset(padding);
                    }else{
                        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
                    }
                }else if (_photoMenuType == TX_WKG_PhotoMenuEdit_Clips_Optional_Type ||
                          _photoMenuType == TX_WKG_PhotoMenuEdit_Middle_Paster_Optional_Event_Type){
                    if (anchor == nil) {
                        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
                    }else{
                        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
                    }
                }else if(_photoMenuType == TX_WKG_PhotoMenuEdit_Global_Optional_Type){
                    if (anchor == nil) {
                        make.right.mas_equalTo(weakSelf.mas_centerX).with.offset(-padding);
                    }else{
                        make.left.mas_equalTo(weakSelf.mas_centerX).with.offset(padding);
                    }
                }
            }];
            anchor = obj;
        }];
        dispatch_barrier_async(dispatch_get_main_queue(), ^{
            if (self.photoMenuType == TX_WKG_PhotoMenuEdit_Middle_Paster_Optional_Event_Type) {
                [self addSubview:self.paster_control_Item];
                [self.paster_control_Item setControlWithImageString:@"tx_wkg_photo_paster_add" text:@"贴纸"];
                [self.containers addObject:self.paster_control_Item];
                [self.paster_control_Item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(weakSelf.mas_centerY);
                    make.centerX.mas_equalTo(weakSelf.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(widthEx(70), widthEx(30)));
                }];
            }
        });
    });
}
@end
