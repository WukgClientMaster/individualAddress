//
//  TextImageCell.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/24.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextImageCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;
@property (strong, nonatomic) UIImageView * imageView;
- (void)setSelected:(BOOL)selected;
+ (NSString *)reuseIdentifier;
@end
