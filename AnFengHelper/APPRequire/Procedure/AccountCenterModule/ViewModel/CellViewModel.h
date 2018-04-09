//
//  CellViewModel.h
//  AnFengHelper
//
//  Created by 吴可高 on 2018/4/8.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "AccountModel.h"

@interface CellViewModel : AccountModel
@property(nonatomic,strong) UIColor * labsBackgroundColor;
@property(nonatomic,strong) UIColor * priceBackgroundColor;
@property(nonatomic,strong) UIColor * gradeBackgroundColor;
@property(nonatomic,strong) UIColor * soldoutBackgroundColor;
@property(nonatomic,strong) UIColor * reduceBackgroundColor;
@property(nonatomic,strong) UIColor * freeAdmissBackgroundColor;
@end
