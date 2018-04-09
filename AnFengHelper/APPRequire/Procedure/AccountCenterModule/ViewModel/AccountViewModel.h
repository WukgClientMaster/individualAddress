//
//  AccountViewModel.h
//  AnFengHelper
//
//  Created by 吴可高 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AccountViewModel : NSObject

+(instancetype)shareInstance;

-(void)startViewModelSerialize:(NSMutableArray*)items serializeCallback:(void(^)(id respnse,BOOL status))block;

@end
