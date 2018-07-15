//
//  TableViewCell.h
//  AnFengHelper
//
//  Created by 吴可高 on 2018/7/14.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoJsonModel.h"
#import "VideoPlayerView.h"
@interface TableViewCell : UITableViewCell
@property(nonatomic,strong) VideoJsonModel * jsonModel;
@property(nonatomic,strong) VideoPlayerView * playerView;

+(instancetype)tableViewCellWithTableView:(UITableView*)tableView;
-(void)videoConfigPlayerView:(VideoPlayerView*)playerView;
-(void)resetPlayerViews;
@end
