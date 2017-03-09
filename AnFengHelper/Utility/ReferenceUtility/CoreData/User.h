//
//  User.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/9/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface User : NSManagedObject
{
    NSString * _userID;
    NSString * _userName;
    NSString * _avatar;
}
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *avatar;

@end
