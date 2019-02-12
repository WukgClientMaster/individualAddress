//
//  TX_WKG_Photo_ScrawlViewCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_ScrawlViewCell.h"


@interface TX_WKG_Photo_ScrawlViewCell()
@property (strong, nonatomic) UIView * scrawlContentView;

@end

@implementation TX_WKG_Photo_ScrawlViewCell
#pragma mark - getter methods
-(UIView *)scrawlContentView{
    _scrawlContentView = ({
        if (!_scrawlContentView) {
            _scrawlContentView = [[UIView alloc]initWithFrame:CGRectZero];
            _scrawlContentView.backgroundColor = [UIColor clearColor];
        }
        _scrawlContentView;
    });
    return _scrawlContentView;
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
    [self addSubview:self.scrawlContentView];
    __weak typeof(self)weakSelf = self;
    [self.scrawlContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
    make.top.mas_equalTo(weakSelf.contentView.mas_top).with.mas_offset(heightEx(6.f));
    make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.mas_offset(-heightEx(6.f));
    }];
}

-(void)setScrawlNode:(TX_WKG_Scrawl_Node *)scrawlNode{
    _scrawlNode = scrawlNode;
    _scrawlContentView.backgroundColor = _scrawlNode.color;
    __weak typeof(self)weakSelf = self;
    if (_scrawlNode.selected) {
        [self.scrawlContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.top.mas_equalTo(weakSelf.contentView.mas_top).with.mas_offset(heightEx(0.f));
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.mas_offset(heightEx(0.f));
        }];
    }else{
        
        [self.scrawlContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.top.mas_equalTo(weakSelf.contentView.mas_top).with.mas_offset(heightEx(6.f));
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.mas_offset(-heightEx(6.f));
        }];
    }
    
    if ([_scrawlNode.color isEqual:UIColorFromRGB(0xffffff)]) {
        _scrawlContentView.layer.masksToBounds = YES;
        _scrawlContentView.layer.borderWidth = widthEx(1.f);
        _scrawlContentView.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    }else{
        _scrawlContentView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
