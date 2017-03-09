//
//  Exception.m
//  IpadApp
//  Created by 吴可高 on 16/3/20.
//  Copyright (c) 2016年 吴可高. All rights reserved.
#import "Exception.h"
static dispatch_once_t once;
@interface Exception ()
{
    Exception *_exception;
}

@property(nonatomic,strong)NSMutableDictionary *exceptionDictionary; //exception（key－value） 容器
@end
@implementation Exception
/**
 *  根据error Code 错误码
 *  @param errorCode showToastMessage
 */
+(Exception*)showExceptionErrorCode:(NSString*)errorCode;
{
    Exception *exception  = [[Exception alloc]initWithErrorCodeMsg:errorCode];
    return exception;
}
-(instancetype)initWithErrorCodeMsg:(NSString*)errorCode
{
    dispatch_once(&once, ^{
      _exception = [[Exception alloc]init];
    });
    /**
     *  在添加直接，要去判断是否存在该key所对应value
     */
   // [CommonTool showToast:self.exceptionDictionary[errorCode] delay:2.0f];
    return _exception;
}

+(void)showNotNetWorkExceptionMsg;
{
    //[CommonTool showToast:NETWORKNOSTATUSMSG delay:2.0f];
}
/**
 *  服务器异常，有我们本地Exception Class 现实ToastMsg
 */
+(void)showDefaultExceptionMsg;
{
    //[CommonTool showToast:HTTPREQUESTERRORMSG delay:2.0f];
}

-(NSMutableDictionary*)exceptionDictionary
{
    if (!_exceptionDictionary)
    {
        _exceptionDictionary = [NSMutableDictionary dictionary];
    }
    [_exceptionDictionary setObject:@"\n用户名或密码错误,请确认无误后,再重新操作!\n" forKey:@"password_error"];
    [_exceptionDictionary setObject:@"\n合同金额已经修改过,请确认无误后,再重新操作!\n" forKey:@"already_update"];

    [_exceptionDictionary setObject:@"\n获取验证码超时,请稍后重试!\n" forKey:@"code_timeout"];
    [_exceptionDictionary setObject:@"\n短信验证码可能已过期,请重新获取验证码!\n" forKey:@"code_error"];
    
    [_exceptionDictionary setObject:@"\n系统存在该账号,请重新登录,获取验证码\n" forKey:@"user_exist"];
    [_exceptionDictionary setObject:@"\n系统不存在该账号,请联系系统管理员!\n" forKey:@"phone_not_code"];

    [_exceptionDictionary setObject:@"\n请正确输入手机号!\n" forKey:@"phone_illegal"];
    [_exceptionDictionary setObject:@"\n验证码发送异常,请稍后重试!\n" forKey:@"send_error"];
    [_exceptionDictionary setObject:@"\n手机号不存在,可注册成为用户!\n" forKey:@"phone_not_exist"];
    [_exceptionDictionary setObject:@"\n系统已经存在该手机号码!\n" forKey:@"phone_exist"];
    
    [_exceptionDictionary setObject:@"\n验证码获取错误或手机验证不匹配!\n" forKey:@"code_error"];
    [_exceptionDictionary setObject:@"\n手机暂时无法获取验证码,请稍后重试!\n" forKey:@"code_not_exist"];
    
    [_exceptionDictionary setObject:@"\n填写游客人数与绑定团旗的人数不一致!\n" forKey:@"num_differ"];
    [_exceptionDictionary setObject:@"\n服务接口数据层操作异常,我们已告知服务器开发人员,请稍后重试!\n" forKey:@"server_error"];
    [_exceptionDictionary setObject:@"\n请求参数错误,已经告知开发人员,请稍候重试!\n" forKey:@"param_null"];

    return _exceptionDictionary;
}
@end
