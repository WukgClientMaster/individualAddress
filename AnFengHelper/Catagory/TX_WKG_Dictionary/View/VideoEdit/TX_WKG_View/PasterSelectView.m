//
//  PasterSelectView.m
//  TXLiteAVDemo
//
//  Created by xiang zhang on 2017/10/31.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "PasterSelectView.h"
#import "UIView+Additions.h"

#define PASTER_SPACE  20

@implementation PasterQipaoInfo
@end

@implementation PasterAnimateInfo
@end

@implementation PasterStaticInfo
@end

@implementation PasterSelectView
{
    UIScrollView * _selectView;
    NSArray *      _pasterList;
    NSString *     _boundPath;
    PasterType     _pasterType;
}

- (instancetype) initWithFrame:(CGRect)frame
                    pasterType:(PasterType)pasterType
                     boundPath:(NSString *)boundPath
{
    self = [super initWithFrame:frame];
    if (self) {
        _pasterType =pasterType;
        _boundPath = boundPath;
        
        _selectView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _selectView.backgroundColor = [UIColor grayColor];
        _selectView.contentSize = CGSizeMake((PASTER_SPACE + self.height) * _pasterList.count, self.height);
        [self addSubview:_selectView];
        
        NSString *jsonString = [NSString stringWithContentsOfFile:[_boundPath stringByAppendingPathComponent:@"config.json"] encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [self dictionaryWithJsonString:jsonString];
        _pasterList = dic[@"pasterList"];
        
        for (int i = 0; i < _pasterList.count; i ++) {
            NSString *qipaoIconPath = [boundPath stringByAppendingPathComponent:_pasterList[i][@"icon"]];
            UIImage *qipaoIconImage = [UIImage imageWithContentsOfFile:qipaoIconPath];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(PASTER_SPACE + i  * (self.height + PASTER_SPACE),0, self.height, self.height)];
            [btn setImage:qipaoIconImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(selectBubble:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [_selectView addSubview:btn];
        }
    }
    return self;
}

- (void)selectBubble:(UIButton *)btn
{
    switch (_pasterType) {
        case PasterType_Qipao:
        {
            NSString *qipaoPath = [_boundPath stringByAppendingPathComponent:_pasterList[btn.tag][@"name"]];
            NSString *jsonString = [NSString stringWithContentsOfFile:[qipaoPath stringByAppendingPathComponent:@"config.json"] encoding:NSUTF8StringEncoding error:nil];
            NSDictionary *dic = [self dictionaryWithJsonString:jsonString];
            
            PasterQipaoInfo *info = [PasterQipaoInfo new];
            info.image = [UIImage imageNamed:[qipaoPath stringByAppendingPathComponent:dic[@"name"]]];
            info.width = [dic[@"width"] floatValue];
            info.height = [dic[@"height"] floatValue];
            info.textTop = [dic[@"textTop"] floatValue];
            info.textLeft = [dic[@"textLeft"] floatValue];
            info.textRight = [dic[@"textRight"] floatValue];
            info.textBottom = [dic[@"textBottom"] floatValue];
            info.iconImage = btn.imageView.image;
            [self.delegate onPasterQipaoSelect:info];
        }
            break;
            
        case PasterType_Animate:
        {
            NSString *pasterPath = [_boundPath stringByAppendingPathComponent:_pasterList[btn.tag][@"name"]];
            NSString *jsonString = [NSString stringWithContentsOfFile:[pasterPath stringByAppendingPathComponent:@"config.json"] encoding:NSUTF8StringEncoding error:nil];
            NSDictionary *dic = [self dictionaryWithJsonString:jsonString];
    
            NSArray *imagePathList = dic[@"frameArry"];
            NSMutableArray *imageList = [NSMutableArray array];
            for (NSDictionary *dic in imagePathList) {
                NSString *imageName = dic[@"picture"];
                UIImage *image = [UIImage imageNamed:[pasterPath stringByAppendingPathComponent:imageName]];
                [imageList addObject:image];
            }
            
            PasterAnimateInfo *info = [PasterAnimateInfo new];
            info.imageList = imageList;
            info.path = pasterPath;
            info.width = [dic[@"width"] floatValue];
            info.height = [dic[@"height"] floatValue];
            info.duration = [dic[@"period"] floatValue] / 1000.0;
            info.iconImage = btn.imageView.image;
            [self.delegate onPasterAnimateSelect:info];
        }
            break;
            
        case PasterType_static:
        {
            NSString *pasterPath = [_boundPath stringByAppendingPathComponent:_pasterList[btn.tag][@"name"]];
            NSString *jsonString = [NSString stringWithContentsOfFile:[pasterPath stringByAppendingPathComponent:@"config.json"] encoding:NSUTF8StringEncoding error:nil];
            NSDictionary *dic = [self dictionaryWithJsonString:jsonString];
     
            PasterStaticInfo *info = [PasterStaticInfo new];
            info.image = [UIImage imageNamed:[pasterPath stringByAppendingPathComponent:dic[@"name"]]];
            info.width = [dic[@"width"] floatValue];
            info.height = [dic[@"height"] floatValue];
            info.iconImage = btn.imageView.image;
            [self.delegate onPasterStaticSelect:info];
        }
            break;
            
        default:
            break;
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
