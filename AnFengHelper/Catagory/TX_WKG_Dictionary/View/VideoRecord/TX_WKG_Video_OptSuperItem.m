//
//  TX_WKG_Video_OptSuperItem.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Video_OptSuperItem.h"

@interface TX_WKG_Video_OptSuperItem()
@property (strong,readwrite,nonatomic) UIImageView * imageView;
@property (copy,readwrite,nonatomic) NSString * indefiner;
@property (copy, nonatomic) NSString * highlight;
@property (copy, nonatomic) NSString * normal;
@property (copy, nonatomic) UIImage * normalImage;
@property (copy, nonatomic) UIImage * highlightImage;
@end

@implementation TX_WKG_Video_OptSuperItem
#pragma mark - IBOutlet Events
-(void)optEvents:(UIControl*)control{
    if (self.callback) {
        self.callback(self);
    }
}

-(void)touchUpOutsideEvents:(UIControl*)control{
}

#pragma mark - getter methods
-(UIImageView *)imageView{
    _imageView = ({
        if (!_imageView) {
            _imageView = [[UIImageView alloc]init];
            _imageView.contentMode = UIViewContentModeCenter;
        }
        _imageView;
    });
    return _imageView;
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
    [self setUserInteractionEnabled:YES];
    [self addSubview:self.imageView];
    __weak typeof(self)weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0.f);
    make.centerX.mas_equalTo(weakSelf.mas_centerX).with.offset(0.f);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.imageView.image = self.highlightImage;
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.imageView.image = self.normalImage;
    if (self.callback) {
        self.callback(self);
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.imageView.image = self.normalImage;
    if (self.callback) {
        self.callback(self);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)configParamImgString:(NSString*)imgString highlight:(NSString*)highlight indefiner:(NSString*)indefiner{
    [self configParamImgString:imgString indefiner:indefiner];
    self.highlight = highlight;
    self.normal = imgString;
    self.normalImage =[UIImage imageNamed:self.normal];
    self.highlightImage =[UIImage imageNamed:self.highlight];
}

-(void)configParamImgString:(NSString *)imgString indefiner:(NSString *)indefiner{
    [self configParamImgString:imgString];
    NSAssert(indefiner,@"indefiner is not nil");
    self.indefiner = indefiner;
    self.normal    =  imgString;
    self.highlight = imgString;
    self.normalImage =[UIImage imageNamed:self.normal];
    self.highlightImage =[UIImage imageNamed:self.highlight];
}

-(void)configParamImgString:(NSString*)imgString{
    NSAssert(imgString,@"imgString is not nil");
    self.imageView.image = [UIImage imageNamed:imgString];
    self.highlight = imgString;
    self.normal = imgString;
    self.normalImage =[UIImage imageNamed:self.normal];
    self.highlightImage =[UIImage imageNamed:self.highlight];
}
@end
