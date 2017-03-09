//
//  DraggingTableCell.h
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DraggingTableCell;
static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";


typedef NS_ENUM(NSInteger,kCellState)
{
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight,
};

@interface NSMutableArray(UtilityItem)

- (void)setUtilityWithColor:(UIColor *)color title:(NSString *)title;
- (void)setUtilityWithColor:(UIColor *)color icon:(UIImage *)icon;

@end

@protocol DraggingViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(DraggingTableCell *)cell didTriggerLeftUtilityWithIndex:(NSInteger)index;

- (void)swippableTableViewCell:(DraggingTableCell *)cell didTriggerRightUtilityWithIndex:(NSInteger)index;

- (void)swippableTableViewCell:(DraggingTableCell *)cell scrollingToState:(kCellState)state;

@end

@interface DraggingTableCell : UITableViewCell

@property (strong, nonatomic) NSArray * leftUtilityItems;
@property (strong, nonatomic) NSArray * rightUtlityItems;
@property (weak, nonatomic)  id <DraggingViewCellDelegate> draggingDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
        containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityItems    rightUtilityButtons:(NSArray *)rightUtilityItems;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityItemsAnimated:(BOOL)animated;

@end
