//
//  TX_Record_TopOptView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#define KVIDEO_RECORD_OPTIONAL_TAGVALUE  1000

#import "TX_Record_TopOptView.h"
@interface TX_Record_TopOptView()
@property (strong, nonatomic) NSMutableArray * items;
@property (strong, nonatomic) NSMutableArray * containers;
@property (strong,readwrite,nonatomic) UIButton * musicOpt_btn;
@end

@implementation TX_Record_TopOptView
#pragma mark -IBOutlet Events
-(void)recordOptEvents:(UIButton*)args{
    if (self.callback) {
        NSInteger tagValue = args.tag - KVIDEO_RECORD_OPTIONAL_TAGVALUE;
        NSDictionary * json = self.items[tagValue];
        NSString * title = (NSString*)[[json allKeys]firstObject];
        self.callback(args,title);
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
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    self.items = @[
                      @{@"前后":@{@"normal":@"qmx_paishe_qiehuanjingtou",@"selected":@"qmx_paishe_qiehuanjingtou"}},
                      @{@"闪光":@{@"normal":@"qmx_paishe_shanguang",@"selected":@"qmx_paishe_shanguangkai"}},
                      @{@"延迟": @{@"normal":@"qmx_paishe_three",@"selected":@"qmx_paishe_threelv"}},
                      @{@"音乐":@{@"normal":@"qmx_bianji_music",@"selected":@"qmx_music_icon"}},
                   ].mutableCopy;
    for (int i = 0; i < self.items.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary * config  = self.items[i];
        NSDictionary * valueDic = (NSDictionary*)[[config allValues]firstObject];
        UIImage * normalImg = [UIImage imageNamed:valueDic[@"normal"]];
        UIImage * selectedImg = [UIImage imageNamed:valueDic[@"selected"]];
        [button setImage:normalImg forState:UIControlStateNormal];
        [button setImage:selectedImg forState:UIControlStateSelected];
        [button setImage:nil forState:UIControlStateHighlighted];
        [button setTag:(KVIDEO_RECORD_OPTIONAL_TAGVALUE + i)];
        [button addTarget:self action:@selector(recordOptEvents:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [self addSubview:button];
        button.imageView.contentMode = UIViewContentModeCenter;
        [self.containers addObject:button];
        if (i == self.items.count-1) {
            self.musicOpt_btn = button;
        }
    }
    [self layoutSubObjectViews];
}

-(void)setStatusImageWithEnable:(BOOL)enable{
    UIImage * image =  enable ? [UIImage imageNamed:@"qmx_music_icon"] : [UIImage imageNamed:@"qmx_bianji_music"] ;
    [self.musicOpt_btn setImage:image forState:UIControlStateNormal];
}

-(void)setSelectedStatus:(BOOL)selected opt:(NSString*)title{
    //item idx
    __block  NSMutableArray * containers;
    containers = [NSMutableArray array];
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        [self.items enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * key = (NSString*)[[obj allKeys]firstObject];
            [containers addObject:key];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![containers containsObject:title])return;
            NSInteger idx  = [containers indexOfObject:title];
            UIButton * item = [self.containers objectAtIndex:idx];
            [item setSelected:selected];
        });
    });
}


#pragma mark - layoutSubViews
-(void)layoutSubObjectViews{
    __weak typeof(self)weakSelf = self;
    __block CGFloat padding = widthEx(12.f);
    __block UIButton * anchor = nil;
    [self.containers enumerateObjectsUsingBlock:^(UIButton*  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            if (anchor == nil) {
            make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
            make.top.mas_equalTo(weakSelf.mas_top).with.offset(2*padding);
            }else{
            make.top.mas_equalTo(anchor.mas_bottom).with.offset(2*padding);
            make.centerX.mas_equalTo(anchor.mas_centerX).with.offset(0.f);
            }
        }];
        anchor  =  item;
    }];
}

@end
