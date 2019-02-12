//
//  CategoryCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/28.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "CategoryCell.h"
#import "PhotoDowloadTool.h"

@interface CategoryCell ()
@property (strong, nonatomic) UIImageView * avatar_imageView;
@property (strong, nonatomic) UILabel * title_label;
@property (strong, nonatomic) UILabel * num_label;
@end

@implementation CategoryCell

#pragma mark - getter methods
-(UIImageView *)avatar_imageView{
    _avatar_imageView = ({
        if (!_avatar_imageView) {
            _avatar_imageView  = [[UIImageView alloc]initWithFrame:CGRectZero];
            _avatar_imageView.image = [Tools placeholderColorImage];
            _avatar_imageView.contentMode = UIViewContentModeScaleAspectFill;
            _avatar_imageView.layer.masksToBounds = YES;
        }
        _avatar_imageView;
    });
    return _avatar_imageView;
}

-(UILabel *)title_label{
    _title_label = ({
        if (!_title_label) {
            _title_label = [UILabel new];
            _title_label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12.f];
            _title_label.textColor = UIColorFromRGB(0x333333);
            _title_label.text = @"";
        }
        _title_label;
    });
    return _title_label;
}
-(UILabel *)num_label{
    _num_label = ({
        if (!_num_label) {
            _num_label = [UILabel new];
            _num_label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15.f];
            _num_label.textColor = UIColorFromRGB(0x999999);
            _num_label.text = @"";
        }
        _num_label;
    });
    return _num_label;
}

+(CategoryCell *) cellWithTableView:(UITableView*)tableView{
    CategoryCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[CategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadContentView];
        [self loadCellStyle];
    }
    return self;
}
-(void)loadCellStyle{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)loadContentView{
    [self.contentView addSubview:self.avatar_imageView];
    [self.contentView addSubview:self.title_label];
    [self.contentView addSubview:self.num_label];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.avatar_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).with.offset(8.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-8.f);
        make.width.mas_equalTo(self.contentView.mas_height).with.offset(16.f);
    }];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatar_imageView.mas_right).with.offset(12.f);
        make.centerY.mas_equalTo(self.avatar_imageView.mas_centerY);
    }];
    [self.num_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-8.f);
    }];
}
-(void)setModel:(DazzleAssetCollectionModel *)model{
    _model = model;
    if (_model == nil)return;
    self.title_label.text = model.collectionName;
    self.num_label.text = [NSString stringWithFormat:@"%zd",model.assetCount];
    if (_model.coverImage) {
        self.avatar_imageView.image = _model.coverImage;
        return;
    }
    PHAsset * phAsset = [model.dazzleAssets firstObject];
    CGSize size = CGSizeMake(100, 100);
    [PhotoDowloadTool getHighQualityFormatPhoto:phAsset size:size startRequestIcloud:^(PHImageRequestID cloudRequestId) {
        
    } progressHandler:^(double progress) {
        
    } completion:^(UIImage *image) {
        _avatar_imageView.image = image;
        _model.coverImage = image;
    } failed:^(NSDictionary *info) {
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
