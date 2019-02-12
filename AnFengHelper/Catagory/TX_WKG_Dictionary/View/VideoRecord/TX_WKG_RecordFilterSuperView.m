//
//  TX_WKG_RecordFilterSuperView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/11.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_RecordFilterSuperView.h"
#import "BeautySettingPanel.h"

@interface TX_WKG_RecordFilterSuperView()<BeautySettingPanelDelegate,BeautyLoadPituDelegate>
@property (strong, nonatomic) BeautySettingPanel * vBeauty;

@end

@implementation TX_WKG_RecordFilterSuperView
#pragma mark - BeautyLoadPituDelegate
- (void)onLoadPituStart{
}

- (void)onLoadPituProgress:(CGFloat)progress{
}

- (void)onLoadPituFinished{
}

- (void)onLoadPituFailed{
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
    NSUInteger controlHeight = [BeautySettingPanel getHeight];
    _vBeauty = [[BeautySettingPanel alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, controlHeight)];
    _vBeauty.delegate = self;
    _vBeauty.pituDelegate = self;
    [self addSubview:_vBeauty];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - BeautySettingPanelDelegate
- (void)onSetBeautyStyle:(int)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel{
   // [[TXUGCRecord shareInstance] setBeautyStyle:beautyStyle beautyLevel:beautyLevel whitenessLevel:whitenessLevel ruddinessLevel:ruddinessLevel];
}

- (void)onSetEyeScaleLevel:(float)eyeScaleLevel{
    //[[TXUGCRecord shareInstance] setEyeScaleLevel:eyeScaleLevel];
}

- (void)onSetFaceScaleLevel:(float)faceScaleLevel{
    //[[TXUGCRecord shareInstance] setFaceScaleLevel:faceScaleLevel];
}

- (void)onSetFilter:(UIImage*)filterImage{
    //[[TXUGCRecord shareInstance] setFilter:filterImage];
}

- (void)onSetGreenScreenFile:(NSURL *)file{
    //[[TXUGCRecord shareInstance] setGreenScreenFile:file];
}

- (void)onSelectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir{
    //[[TXUGCRecord shareInstance] selectMotionTmpl:tmplName inDir:tmplDir];
}

- (void)onSetFaceVLevel:(float)faceVLevel{
    //[[TXUGCRecord shareInstance] setFaceVLevel:faceVLevel];
}

- (void)onSetChinLevel:(float)chinLevel{
    //[[TXUGCRecord shareInstance] setChinLevel:chinLevel];
}

- (void)onSetNoseSlimLevel:(float)slimLevel{
    //[[TXUGCRecord shareInstance] setNoseSlimLevel:slimLevel];
}

- (void)onSetFaceShortLevel:(float)faceShortlevel{
    //[[TXUGCRecord shareInstance] setFaceShortLevel:faceShortlevel];
}

- (void)onSetMixLevel:(float)mixLevel{
    //[[TXUGCRecord shareInstance] setSpecialRatio:mixLevel / 10.0];
}

@end
