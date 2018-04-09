//
//  OOTableCell.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellAdapter;

@interface OOTableCell : UITableViewCell

@property(nonatomic,strong) CellAdapter * cellAdapter;
@property(nonatomic,strong) id  cellData;

+(instancetype)cellReuseWith:(UITableView*)tableView reuseIndefiner:(NSString*)indefiner;

-(void)buildContentView;

-(void)setContentViewStyle;

-(void)loadContentData;
@end
