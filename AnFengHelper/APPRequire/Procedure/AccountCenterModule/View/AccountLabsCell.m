//
//  AccountLabsCell.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "AccountLabsCell.h"

@interface  AccountLabsCell()
@property(nonatomic,strong) UILabel * grade_label;
@property(nonatomic,strong) UILabel * soldout_label;
@property (strong, nonatomic) UILabel *reduce_label;
@property (strong, nonatomic) UILabel *freeAdmiss_label;
@property (strong, nonatomic) NSMutableArray * labelContainers;
@property (strong, nonatomic) NSMutableArray * statusLabelContainers;

@end
@implementation AccountLabsCell
#pragma mark -getter methods
-(NSMutableArray *)statusLabelContainers{
    _statusLabelContainers = ({
        if (!_statusLabelContainers) {
            _statusLabelContainers = [NSMutableArray array];
        }
        _statusLabelContainers;
    });
    return _statusLabelContainers;
}

-(NSMutableArray *)labelContainers{
    _labelContainers = ({
        if (!_labelContainers) {
            _labelContainers = [NSMutableArray array];
        }
        _labelContainers;
    });
    return _labelContainers;
}

-(UILabel *)reduce_label{
    _reduce_label = ({
        if (!_reduce_label) {
            _reduce_label = [UILabel new];
            _reduce_label.layer.masksToBounds = YES;
            _reduce_label.layer.cornerRadius = APPAdapterAdjustHeight(4.f);
            _reduce_label.text = @" 减 ";
            _reduce_label.font = [UIFont systemFontOfSize:APPAdapterScaleFontFamily(12.f)];
            _reduce_label.textColor = AdapterColor(44, 128, 245);
            _reduce_label.backgroundColor = AdapterColor(247, 240,221);
        }
        _reduce_label;
    });
    return _reduce_label;
}
-(UILabel *)freeAdmiss_label{
    _freeAdmiss_label = ({
        if (!_freeAdmiss_label) {
            _freeAdmiss_label = [UILabel new];
            _freeAdmiss_label.layer.masksToBounds = YES;
            _freeAdmiss_label.layer.cornerRadius = APPAdapterAdjustHeight(4.f);
            _freeAdmiss_label.text = @" 返 ";
            _freeAdmiss_label.font = [UIFont systemFontOfSize:APPAdapterScaleFontFamily(12.f)];
            _freeAdmiss_label.textColor = AdapterColor(44, 128, 245);
            _freeAdmiss_label.backgroundColor = AdapterColor(247, 240,221);
        }
        _freeAdmiss_label;
    });
    return _freeAdmiss_label;
}

-(UILabel *)grade_label{
    _grade_label = ({
        if (!_grade_label) {
            _grade_label = [UILabel new];
            _grade_label.font = [UIFont systemFontOfSize:APPAdapterScaleFontFamily(13.f)];
            _grade_label.textColor = AdapterColor(44, 128, 245) ;
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
    [self.contentView addSubview:self.grade_label];
    [self.contentView addSubview:self.soldout_label];
    [self.contentView addSubview:self.freeAdmiss_label];
    [self.contentView addSubview:self.reduce_label];
}

-(void)setContentViewStyle{
    [super setContentViewStyle];
}
-(void)loadContentData{
    [super loadContentData];
    if (self.cellData==nil)return;
    __weak  typeof(self)weakSelf = self;
    CGFloat padding = APPAdapterScaleWith(20.f);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.labelContainers enumerateObjectsUsingBlock:^(UILabel * label, NSUInteger idx, BOOL * _Nonnull stop) {
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
    }];
    [self.statusLabelContainers enumerateObjectsUsingBlock:^(UILabel * label, NSUInteger idx, BOOL * _Nonnull stop) {
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
    }];
    [self.labelContainers makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.labelContainers removeAllObjects];
    dispatch_semaphore_signal(semaphore);
    if ([self.cellData isKindOfClass:[CellViewModel class]]) {
        CellViewModel * viewModel = (CellViewModel*)self.cellData;
        for (int i = 0; i < viewModel.labels.count; i++) {
            UILabel * label = [UILabel new];
            label.textColor = AdapterColor(44, 128, 245);
            label.backgroundColor = AdapterColor(180, 180, 180);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = viewModel.labels[i];
            label.font = [UIFont systemFontOfSize:APPAdapterScaleFontFamily(12.f)];
            label.backgroundColor = viewModel.labsBackgroundColor;
            [self.contentView addSubview:label];
            [self.labelContainers addObject:label];
        }
        //layout
        __block UILabel * anchor_X = nil;
        __block UILabel * anchor_Y = nil;
        [self.labelContainers enumerateObjectsUsingBlock:^(UILabel* _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            NSUInteger i = idx % 3;
            NSUInteger j = idx / 3;
            if (i== 0 && j==0) {
                anchor_Y = nil;
                anchor_X = nil;
            }if (i!=0 && j==0) {
                anchor_X = strongSelf.labelContainers[idx -1];
                anchor_Y = nil;
            }if (i==0 && j!=0) {
                NSInteger idx_xy = idx % 3 + (idx/3 -1)*3;
                anchor_Y = strongSelf.labelContainers[idx_xy];
                anchor_X = nil;
            }if (i!=0 && j!=0) {
                NSInteger idx_y = idx % 3 + (idx/3 -1)*3;
                anchor_X = strongSelf.labelContainers[idx -1];
                anchor_Y = strongSelf.labelContainers[idx_y];
            }
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                if (anchor_X == nil && anchor_Y == nil) {
                    make.top.mas_equalTo(weakSelf.desc_label.mas_bottom).with.offset(padding/2.f);
                    make.left.mas_equalTo(weakSelf.avatarImageView.mas_right).with.offset(padding/2.f);
                }else if (anchor_X !=nil && anchor_Y == nil){
                    make.top.mas_equalTo(weakSelf.desc_label.mas_bottom).with.offset(padding/2.f);
                    make.left.mas_equalTo(anchor_X.mas_right).with.offset(padding/2.f);
                }else if (anchor_X == nil && anchor_Y !=nil){
                    make.left.mas_equalTo(weakSelf.avatarImageView.mas_right).with.offset(padding/2.f);
                    make.top.mas_equalTo(anchor_Y.mas_bottom).with.offset(padding/2.f);
                }else if (anchor_X !=nil && anchor_Y !=nil){
                    make.left.mas_equalTo(anchor_X.mas_right).with.offset(padding/2.f);
                    make.top.mas_equalTo(anchor_Y.mas_bottom).with.offset(padding/2.f);
                }
            }];
        }];
        [self.statusLabelContainers addObject:self.reduce_label];
        [self.statusLabelContainers addObject:self.freeAdmiss_label];
        [self.statusLabelContainers addObject:self.grade_label];
        [self.statusLabelContainers addObject:self.soldout_label];
        UILabel * lastlayoutLabel = [self.labelContainers lastObject];
        [self.grade_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.desc_label.mas_left).with.offset(0.f);
            make.top.mas_equalTo(lastlayoutLabel.mas_bottom).with.offset(padding/2.f);
        }];
        [self.soldout_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.grade_label.mas_right).with.offset(padding/2.f);
            make.centerY.mas_equalTo(weakSelf.grade_label.mas_centerY).with.offset(0.f);
        }];
        [self.reduce_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.soldout_label.mas_centerY);
            make.left.mas_equalTo(weakSelf.soldout_label.mas_right).with.offset(padding/2.f);
        }];
        
        [self.freeAdmiss_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.reduce_label.mas_centerY);
            make.left.mas_equalTo(weakSelf.reduce_label.mas_right).with.offset(padding/2.f);
        }];
        self.grade_label.text = viewModel.grade;
        self.soldout_label.text = viewModel.soldout;
        self.grade_label.backgroundColor = viewModel.gradeBackgroundColor;
        self.soldout_label.backgroundColor = viewModel.soldoutBackgroundColor;
        self.reduce_label.backgroundColor = viewModel.reduceBackgroundColor;
        self.freeAdmiss_label.backgroundColor = viewModel.freeAdmissBackgroundColor;
    }
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
