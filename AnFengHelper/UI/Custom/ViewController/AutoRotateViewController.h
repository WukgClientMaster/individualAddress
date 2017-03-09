//
//  AutoRotateViewController.h
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//

#import "OOBaseViewController.h"

typedef void(^RotateReponseBlcok)(NSInteger);
@interface AutoRotateViewController : OOBaseViewController

-(instancetype)initWithRotateCustomViewArray:(NSArray *)targetArray rotateReponseBlcok:(RotateReponseBlcok)block;

@end
