//
//  ScratchCardView.h
//  RGBTool
//
//  Created by admin on 23/08/2017.
//  Copyright © 2017 gcg. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef TX_WKG_XScratchView
#define TX_WKG_XScratchView
typedef NS_ENUM(NSInteger, KTX_WKG_XScratchType){
    KTX_WKG_XScratchTypeClear,
    KTX_WKG_XScratchTypeWrite
};
#endif

@interface XScratchView : UIView

/** masoicImage(放在底层) */
@property (nonatomic, strong) UIImage *mosaicImage;
/** surfaceImage(放在顶层) */
@property (nonatomic, strong) UIImage *surfaceImage;
@property (assign, nonatomic) KTX_WKG_XScratchType  scratchType;

-(void)clearAllOptData;
//清除所有
-(void)clearAllScreen;
//向前撤销
-(void)rollback;
//向后撤销
-(void)undoRollback;
//保存
-(UIImage*)save;


@end
