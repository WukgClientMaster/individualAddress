//
//  CollectionViewCell.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/5/20.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell()
@property(nonatomic,strong) UIImageView * imageView;
@end

@implementation CollectionViewCell
#pragma mark - getter methods
-(UIImageView *)imageView{
    _imageView = ({
        if (!_imageView) {
            _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _imageView.backgroundColor = UIColorFromRGB(0xf7f7f7);
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.and.bottom.mas_equalTo(self.contentView);
    }];
}

-(void)setModel:(CollectionModel *)model{
    _model = model;
    NSURL * url = [self urlFormatWithUrlString:_model.urlString];
    [self.imageView sd_setImageWithURL:url placeholderImage:nil];
}
-(NSURL*)urlFormatWithUrlString:(NSString*)urlString{    
    NSString *encodedString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            
                                            (CFStringRef)urlString,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8);
    NSURL * url = [NSURL URLWithString:encodedString];
    return url;
}
@end
