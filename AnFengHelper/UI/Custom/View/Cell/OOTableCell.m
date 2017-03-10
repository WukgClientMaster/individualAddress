//
//  OOTableCell.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "OOTableCell.h"

@interface CellAdapter : NSObject

@property(nonatomic,strong) NSIndexPath * indexPath;
@property(nonatomic,strong) id cellData;
@property(nonatomic,copy) NSString * cellIndefiner;
+(CellAdapter*)cellAdapterWith:(id)cellData withCellIndefiner:(NSString*)cellIndefiner;

+(CellAdapter*)cellAdapterWith:(id)cellData withCellIndefiner:(NSString *)cellIndefiner indexPath:(NSIndexPath*)indexPath;

@end

@implementation CellAdapter

+(CellAdapter*)cellAdapterWith:(id)cellData withCellIndefiner:(NSString*)cellIndefiner;
{
    CellAdapter * cellAdapter = [[CellAdapter alloc]init];
    cellAdapter.cellData = cellData;
    cellAdapter.cellIndefiner = cellIndefiner;
    return cellAdapter;
}

+(CellAdapter*)cellAdapterWith:(id)cellData withCellIndefiner:(NSString *)cellIndefiner indexPath:(NSIndexPath*)indexPath;
{
    CellAdapter * cellAdapter = [CellAdapter cellAdapterWith:cellData withCellIndefiner:cellIndefiner];
    cellAdapter.indexPath = indexPath;
    return cellAdapter;
}

@end

@implementation OOTableCell

+(instancetype)cellReuseWith:(UITableView*)tableView reuseIndefiner:(NSString*)indefiner;
{
    OOTableCell * cell = [tableView dequeueReusableCellWithIdentifier:indefiner];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefiner];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildContentView];
        [self setContentViewStyle];
    }
    return self;
}

-(void)buildContentView
{
    
}

-(void)setContentViewStyle;
{
    
}

-(void)loadContentData
{

}
@end
