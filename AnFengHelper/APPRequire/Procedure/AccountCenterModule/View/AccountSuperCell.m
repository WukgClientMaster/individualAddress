//
//  AccountSuperCell.m
//  AnFengHelper
//
//  Created by 智享城市iOS开发 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "AccountSuperCell.h"

@interface AccountSuperCell()
@property(nonatomic,readwrite,strong) UIImageView * avatarImageView;
@property(nonatomic,readwrite,strong) UILabel * desc_label;
@property(nonatomic,readwrite,strong) UILabel * price_label;
@end
@implementation AccountSuperCell

#pragma mark - getter methods
-(UIImageView *)avatarImageView{
    _avatarImageView = ({
        if (!_avatarImageView) {
            _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _avatarImageView.backgroundColor = AdapterColor(200, 200, 200);
            _avatarImageView.layer.masksToBounds = YES;
            _avatarImageView.layer.cornerRadius = APPAdapterAdjustHeight(8.f);
        }
        _avatarImageView;
    });
    return _avatarImageView;
}

-(UILabel *)desc_label{
    _desc_label = ({
        if (!_desc_label) {
            _desc_label = [UILabel new];
            _desc_label.textColor = [UIColor darkGrayColor];
            _desc_label.font = [UIFont systemFontOfSize:APPAdapterScaleFontFamily(14.f)];
            _desc_label.numberOfLines = 1.f;
            _desc_label.textAlignment = NSTextAlignmentLeft;
        }
        _desc_label;
    });
    return _desc_label;
}

-(UILabel *)price_label{
    _price_label = ({
        if (!_price_label) {
            _price_label =[UILabel new];
            _price_label.textColor  = [UIColor redColor];
            _price_label.textAlignment = NSTextAlignmentCenter;
            _price_label.backgroundColor = AdapterColor(200, 200, 200);
            _price_label.layer.masksToBounds = YES;
            _price_label.layer.cornerRadius = APPAdapterAdjustHeight(4.f);
        }
        _price_label;
    });
    return _price_label;
}


-(void)buildContentView{
    [super buildContentView];
    __weak  typeof(self)weakSelf = self;
    CGFloat padding = APPAdapterScaleWith(20.f);
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.desc_label];
    [self.contentView addSubview:self.price_label];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(padding);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY).with.offset(0.f);
        make.size.mas_equalTo(CGSizeMake(APPAdapterScaleWith(85), APPAdapterAdjustHeight(90)));
    }];
    [self.desc_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avatarImageView.mas_right).with.offset(padding/2.f);
        make.top.mas_equalTo(weakSelf.avatarImageView.mas_top).with.offset(0.f);
    }];
    [self.price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-padding/2.f);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-padding/2.f);
    }];
}

-(void)setContentViewStyle{
    [super setContentViewStyle];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)loadContentData{
    [super loadContentData];
    if (self.cellData == nil) return;
    if ([self.cellData isKindOfClass:[CellViewModel class]]) {
        CellViewModel * model = (CellViewModel*)self.cellData;
        NSURL * url = [NSURL URLWithString:model.avatarurl];
        [self.avatarImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        self.desc_label.text = model.desc;
        self.price_label.text = model.price;
        self.price_label.backgroundColor = model.priceBackgroundColor;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
