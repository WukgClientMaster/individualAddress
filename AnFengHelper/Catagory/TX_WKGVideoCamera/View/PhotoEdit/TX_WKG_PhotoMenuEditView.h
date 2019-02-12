//
//  TX_WKG_PhotoMenuEditView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TX_WKG_PhotoMenuOptionalView.h"
#import "TX_WKG_Photo_PasterMenu_View.h"
#import "TX_WKG_Photo_TextView.h"
#import "TX_WKG_Photo_EffectView.h"
#import "TX_WKG_Photo_AdpaterView.h"
#import "TX_WKG_Photo_ClipsView.h"


@protocol TX_WKG_PhotoOptionalDelegate <NSObject>
-(void)tx_Wkg_photoDidSelectedMainMenu:(NSString*)title;
@end

typedef void (^TX_WKG_PhotoOptionalAssetsCallBack)(NSString* menu,NSString* title);

@interface TX_WKG_PhotoMenuEditView : UIView
@property (copy, nonatomic) TX_WKG_PhotoOptionalAssetsCallBack optionalAssetsCallback;
@property (strong, nonatomic) NSIndexPath * selectIndexPath;
@property (strong,readonly,nonatomic) UICollectionView * collectionView;
@property (weak, nonatomic) id <TX_WKG_PhotoOptionalDelegate>mainMenuDelegate;
@property (strong, nonatomic) TX_WKG_PhotoMenuOptionalView * optionalView;
@property (strong,readonly,nonatomic) TX_WKG_Photo_PasterMenu_View * pasterMenuView;
@property (strong, nonatomic) TX_WKG_Photo_ClipsView * clipsView;
@property (strong,readonly,nonatomic) TX_WKG_Photo_TextView * textView;
@property (strong,readonly,nonatomic) TX_WKG_Photo_EffectView * effectView;
@property (strong, nonatomic) TX_WKG_Photo_AdpaterView * adaperView;

-(void)settingPhotoOptionViewHidden:(BOOL)hidden;

-(void)replaceMianMenuViewWithTitle:(NSString*)title;

-(void)closeMenuView;
@end
