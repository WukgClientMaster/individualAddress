//
//  TX_WKG_Video_PreView_ProgressView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/30.
//  Copyright © 2018年 NRH. All rights reserved.
//
#define thumbBound_x widthEx(2.f)
#define thumbBound_y widthEx(16.f)

@interface Video_Progress_Slider: UISlider{
    CGRect lastBounds;
}
@end

@implementation Video_Progress_Slider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    //y轴方向改变手势范围
    rect.origin.y = rect.origin.y - widthEx(10);
    rect.size.width = rect.size.width + widthEx(2.f);
    rect.size.height = rect.size.height + widthEx(20);
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    lastBounds = result;
    return result;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    if ([result isKindOfClass:[Video_Progress_Slider class]]) {
        if ((point.y >= -thumbBound_y) && (point.y < lastBounds.size.height + thumbBound_y)) {
            float value = 0.0;
            value = point.x - self.bounds.origin.x;
            value = value / self.bounds.size.width;
            value = value < 0? 0 : value;
            value = value > 1? 1: value;
            value = value * (self.maximumValue - self.minimumValue);
            [self setValue:value animated:YES];
        }
    }
    return result;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result) {
        if ((point.x >= lastBounds.origin.x - thumbBound_x) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + thumbBound_x)) && (point.y < (lastBounds.size.height + thumbBound_y))) {
            result = YES;
        }
    }
    return result;
}
@end

#import "TX_WKG_Video_PreView_ProgressView.h"
@interface TX_WKG_Video_PreView_ProgressView ()
@property (strong, nonatomic) UIButton * zoom_item;
@property (strong, nonatomic) Video_Progress_Slider * slider;
@property (strong, nonatomic) UILabel  * currentPlay_label;
@property (strong, nonatomic) UILabel  * videoDuration_label;
@property (assign, nonatomic) CGFloat  videoDuration;
@end

@implementation TX_WKG_Video_PreView_ProgressView
#pragma mark - IBOutet Events
-(void)valueChanged:(Video_Progress_Slider*)slider{
    [self setVideoPlayProgress:slider.value];
}

-(void)sliderSeekToSeconds:(Video_Progress_Slider*)slider{
    if (self.autoprogressCallback) {
        CGFloat seekValue   = _slider.value * self.videoDuration;
        NSDictionary * json = @{@"type":@"进度",@"value":@(seekValue)};
        self.autoprogressCallback(json);
    }
}

-(void)videoZoomRotate:(UIButton*)args{
    if (self.autoprogressCallback) {
        NSDictionary * json = @{@"type":@"缩放",@"value":@(args.selected)};
        self.autoprogressCallback(json);
    }
}
#pragma mark - getter methods
-(UILabel *)currentPlay_label{
    _currentPlay_label = ({
        if (!_currentPlay_label) {
            _currentPlay_label = [UILabel new];
            _currentPlay_label.textColor = [UIColor whiteColor];
            _currentPlay_label.font = [UIFont systemFontOfSize:widthEx(13.f)];
            _currentPlay_label.text = @"0:00";
        }
        _currentPlay_label;
    });
    return _currentPlay_label;
}

-(UILabel *)videoDuration_label{
    _videoDuration_label = ({
        if (!_videoDuration_label) {
            _videoDuration_label = [UILabel new];
            _videoDuration_label.textColor = [UIColor whiteColor];
            _videoDuration_label.font = [UIFont systemFontOfSize:widthEx(13.f)];
            _videoDuration_label.text = @"1:00";
        }
        _videoDuration_label;
    });
    return _videoDuration_label;
}

-(Video_Progress_Slider *)slider{
    _slider = ({
        if (!_slider) {
            _slider = [[Video_Progress_Slider alloc]init];
            _slider.minimumValue = 0;
            _slider.maximumValue = 1;
            [_slider setThumbImage:[UIImage imageNamed:@"tx_wkg_qmx_video_progress_thumbView"] forState:UIControlStateNormal];
            [_slider setMaximumTrackTintColor:rgba(220, 220, 220, 1.f)];
            [_slider setMinimumTrackTintColor:[UIColor whiteColor]];
            [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchDown];

            [_slider addTarget:self action:@selector(sliderSeekToSeconds:) forControlEvents:UIControlEventTouchCancel];
            [_slider addTarget:self action:@selector(sliderSeekToSeconds:) forControlEvents:UIControlEventTouchUpOutside];
            [_slider addTarget:self action:@selector(sliderSeekToSeconds:) forControlEvents:UIControlEventTouchUpInside];
        }
        _slider;
    });
    return _slider;
}


-(UIButton *)zoom_item{
    _zoom_item = ({
        if (!_zoom_item) {
            _zoom_item = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage * normalImage = [UIImage imageNamed:@"tx_wkg_recommend_video_zoom"];
            UIImage * selectedImage = [UIImage imageNamed:@"tx_wkg_recommend_video_zoomNormal"];
            [_zoom_item setImage:normalImage forState:UIControlStateNormal];
            [_zoom_item setImage:selectedImage forState:UIControlStateSelected];
            [_zoom_item addTarget:self action:@selector(videoZoomRotate:) forControlEvents:UIControlEventTouchUpInside];
        }
        _zoom_item;
    });
    return _zoom_item;
}
-(void)setOptionalZoomScaleWithStatus:(BOOL)status{
    if (!_zoom_item)return;
    [_zoom_item setSelected:status];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setZoomScaleType:(TX_WKG_VIDEO_PREVIEW_ZOOM_SCALE_TYPE)zoomScaleType{
    _zoomScaleType = zoomScaleType;
    switch (_zoomScaleType) {
        case TX_WKG_VIDEO_PREVIEW_ZOOM_SCALE_NONE:
            [self loadNoneRatioView];
            break;
            
        case TX_WKG_VIDEO_PREVIEW_ZOOM_SCALE_RETIO:
            [self loadRatioView];
            break;
            
        default:
            break;
    }
}


-(void)loadNoneRatioView{
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView * subView in [self subviews]) {
        [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
    }
    [self setNoneRatio];
}

-(void)setNoneRatio{
    __weak typeof(self)weakSelf = self;
    __block CGFloat padding = widthEx(12.f);
    [self addSubview:self.currentPlay_label];
    [self.currentPlay_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0.f);
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
    }];
    [self addSubview:self.videoDuration_label];
    [self addSubview:self.slider];
    [self.videoDuration_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    make.left.mas_equalTo(weakSelf.currentPlay_label.mas_right).with.offset(padding);
    make.right.mas_equalTo(weakSelf.videoDuration_label.mas_left).with.offset(-padding);
        make.height.mas_equalTo(@(heightEx(30.f)));
    }];
}

-(void)loadRatioView{
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView * subView in [self subviews]) {
        [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
    }
    [self setup];
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    __block CGFloat padding = widthEx(12.f);
    [self addSubview:self.currentPlay_label];
    [self.currentPlay_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0.f);
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
    }];
    [self addSubview:self.zoom_item];
    [self addSubview:self.videoDuration_label];
    [self addSubview:self.slider];
    [self.zoom_item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(widthEx(40), widthEx(40)));
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
    }];
    [self.videoDuration_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(weakSelf.zoom_item.mas_left).with.offset(-padding);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(weakSelf.currentPlay_label.mas_right).with.offset(padding);
        make.right.mas_equalTo(weakSelf.videoDuration_label.mas_left).with.offset(-padding);
    }];
}

-(void)setVideoPlayProgress:(CGFloat)progress{
    if (progress == 0 && self.videoDuration == 0) {
        self.currentPlay_label.text = @"0:00";
        self.slider.value = 0.f;
        return;
    }
    self.slider.value = progress;
    CGFloat currentDuration = self.videoDuration * progress;
    self.currentPlay_label.text = [self getMMSSFromSS:currentDuration];
}

-(NSString *)getMMSSFromSS:(CGFloat)videoDuration{
    NSInteger  seconds     = videoDuration;
    NSInteger  m  = seconds / 60;
    NSInteger  s  = seconds % 60;
    NSString * str_minute;
    NSString * str_second;
    if (m > 9) {
        str_minute  = [NSString stringWithFormat:@"%zd",m];
    }else{
        str_minute  = [NSString stringWithFormat:@"0%zd",m];
    }
    if (s > 9) {
        str_second = [NSString stringWithFormat:@"%zd",s];
    }else{
        str_second = [NSString stringWithFormat:@"0%zd",s];
    }
    NSString * format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

-(void)setVideoDurationWithUrl:(NSURL*)videoUrl{
    if (videoUrl == nil)return;
    AVAsset * asset  = [AVAsset assetWithURL:videoUrl];
    Float64 duration = CMTimeGetSeconds(asset.duration);
    self.videoDuration = duration;
    self.videoDuration_label.text = [self getMMSSFromSS:self.videoDuration];
}

@end
