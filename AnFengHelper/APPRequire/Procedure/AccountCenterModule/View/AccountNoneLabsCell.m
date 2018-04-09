//
//  AccountNoneLabsCell.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "AccountNoneLabsCell.h"

@interface AccountNoneLabsCell()
@property(nonatomic,strong) UILabel * grade_label;
@property(nonatomic,strong) UILabel * soldout_label;
@end

@implementation AccountNoneLabsCell
#pragma mark -getter methods
-(UILabel *)grade_label{
    _grade_label = ({
        if (!_grade_label) {
            _grade_label = [UILabel new];
            _grade_label.font = [UIFont systemFontOfSize:APPAdapterScaleFontFamily(13.f)];
            _grade_label.textColor = AdapterColor(44, 128, 245);
            _grade_label.layer.masksToBounds = YES;
            _grade_label.layer.cornerRadius = APPAdapterAdjustHeight(4.f);
        }
        _grade_label;
    });
    return _grade_label;
}
-(UILabel *)soldout_label{
    _soldout_label = ({
        if (!_soldout_label) {
            _soldout_label =[UILabel new];
            _soldout_label.font = [UIFont systemFontOfSize:APPAdapterScaleFontFamily(13.f)];
            _soldout_label.layer.masksToBounds = YES;
            _soldout_label.textColor = AdapterColor(44, 128, 245) ;
            _soldout_label.layer.cornerRadius = APPAdapterAdjustHeight(4.f);
        }
        _soldout_label;
    });
    return _soldout_label;
}


-(void)buildContentView{
    [super buildContentView];
    __weak  typeof(self)weakSelf = self;
    CGFloat padding = APPAdapterScaleWith(20.f);
    [self.contentView addSubview:self.grade_label];
    [self.contentView addSubview:self.soldout_label];
    [self.grade_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.desc_label.mas_left).with.offset(0.f);
        make.top.mas_equalTo(weakSelf.desc_label.mas_bottom).with.offset(padding);
    }];
    [self.soldout_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.grade_label.mas_right).with.offset(padding/2.f);
        make.centerY.mas_equalTo(weakSelf.grade_label.mas_centerY).with.offset(0.f);

    }];
}

-(void)setContentViewStyle{
    [super setContentViewStyle];
}

-(void)loadContentData{
    [super loadContentData];
    if (self.cellData == nil)return;
    if ([self.cellData isKindOfClass:[CellViewModel class]]) {
        CellViewModel * viewModel = (CellViewModel*)self.cellData;
        self.grade_label.text = viewModel.grade;
        self.soldout_label.text = viewModel.soldout;
        self.grade_label.backgroundColor = viewModel.gradeBackgroundColor;
        self.soldout_label.backgroundColor = viewModel.soldoutBackgroundColor;
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
