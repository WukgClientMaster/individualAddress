//
//  PhoneCall.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/6/17.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "PhoneCall.h"

@implementation PhoneCall
+ (void)directPhoneCallWithPhoneNum:(NSString *)phoneNum {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNum]]];
}

+ (void)phoneCallWithPhoneNum:(NSString *)phoneNum contentView:(UIView *)contentView {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNum]]]];
    [contentView addSubview:callWebview];
}
@end
