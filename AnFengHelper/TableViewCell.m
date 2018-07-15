//
//  TableViewCell.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/7/14.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell()
@property(nonatomic,strong) UIImageView *  coverImageView;
@end

@implementation TableViewCell

+(instancetype)tableViewCellWithTableView:(UITableView*)tableView{
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[TableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        [self loadContentView];
    }
    return self;
}

-(void)loadContentView{
    __weak typeof(self)weakSelf = self;
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark -getter methods
-(UIImageView *)coverImageView{
    _coverImageView = ({
        if (_coverImageView == nil) {
            _coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        }
        _coverImageView;
    });
    return _coverImageView;
}
-(void)videoConfigPlayerView:(VideoPlayerView*)playerView{
    if (playerView == nil)return;
    if (_jsonModel == nil)return;
    _playerView = playerView;
    __weak typeof(self)weakSelf = self;
    [self.playerView setVideo:_jsonModel.video];
    if (![[self.coverImageView subviews]containsObject:self.playerView]) {
        [self.coverImageView addSubview:self.playerView];
        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.coverImageView).insets(UIEdgeInsetsZero);
        }];
    }
}

-(void)resetPlayerViews{
    if (self.playerView) {
        [self.playerView stopVideo];
        [self.playerView removeFromSuperview];
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
    }
}

-(void)setJsonModel:(VideoJsonModel *)jsonModel{
    if (jsonModel == nil)return;
    _jsonModel = jsonModel;
    NSURL * cover = [NSURL URLWithString:_jsonModel.cover];
    [self.coverImageView sd_setImageWithURL:cover];
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
