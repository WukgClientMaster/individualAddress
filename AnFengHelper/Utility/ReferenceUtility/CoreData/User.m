//
//  User.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/9/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic userID,userName,avatar;

-(NSString *)description
{
    return [NSString stringWithFormat:@"*****\n userID:%@ userName:%@ avatar: \n*****%@",self.userID,self.userName,self.avatar];
}
@end
