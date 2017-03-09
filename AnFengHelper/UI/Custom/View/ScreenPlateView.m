//
//  ScreenPlateView.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/14.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#define kScreenSize [UIScreen mainScreen].bounds.size
#define RGBCOLOR(r, g, b) [UIColor colorWithRed: r/255.f green: g/255.f blue: b/255.f alpha: 1]
#define kButtonMargin 10   // 按钮间距
#define kDestroyButtonTag 1001
#define kNormalButtonTag  2002

#import "ScreenPlateView.h"

@interface ScreenPlateView ()
{
    ///下面的弹出框
    UIView *_actionSheetView;
    ///弹出框上半部分
    UIView *_actionSheetTopView;
    ///弹出框下半部分
    UIView *_actionSheetBottomView;
    ///记录title的数组
    NSMutableArray *_titlesArray;
    ///毁灭性的按钮的标题
    NSString *  _destroyItemTitle;
}
@end

@implementation ScreenPlateView

-(instancetype)initWithTitle:(NSString *)title destoryItemTitle:(NSString *)destoryTitle otherItems:(NSArray *)others
{
    if (self = [super init])
    {
        // 动画方式显示
        CATransition *fadeAnimation = [CATransition animation];
        fadeAnimation.duration = 0.3;
        fadeAnimation.type = kCATransitionReveal;
        [self.layer addAnimation: fadeAnimation forKey: nil];
        // 背景半透明
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0.5];
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTapsRequired = 1;
        [tap addTarget: self action: @selector(hide)];
        [self addGestureRecognizer: tap];
        // 添加下面的弹出框
        _actionSheetView = [[UIView alloc] init];
        _actionSheetView.backgroundColor = RGBCOLOR(230, 230, 230);
        _actionSheetView.userInteractionEnabled = YES;
        // 弹出框非交互区域添加事件，防止触发self的tap事件
        UITapGestureRecognizer *actionSheetTap = [[UITapGestureRecognizer alloc] init];
        [_actionSheetView addGestureRecognizer: actionSheetTap];
        // 添加动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.2;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        [_actionSheetView.layer addAnimation: animation forKey: nil];
        [self addSubview:_actionSheetView];
        // title数组
        _titlesArray = [NSMutableArray array];
        // 弹出框上面添加两部分view
        if(title != nil && ![title isEqual: @""]) {
            _actionSheetTopView = [[UIView alloc] init];
            _actionSheetTopView.frame = CGRectMake(0, 0, kScreenSize.width, 40);
            [_actionSheetView addSubview: _actionSheetTopView];
            // 往上半部分视图上添加标题和取消按钮
            _title = title;
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = title;
            titleLabel.textColor = RGBCOLOR(65, 65, 65);
            titleLabel.font = [UIFont systemFontOfSize: 12.f];
            titleLabel.frame = CGRectMake(0, 0, _actionSheetTopView.frame.size.width, _actionSheetTopView.frame.size.height);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [_actionSheetTopView addSubview: titleLabel];
            
            // 取消按钮
            UIButton *btnCancel = [UIButton buttonWithType: UIButtonTypeCustom];
            btnCancel.backgroundColor = RGBCOLOR(222, 222, 222);
            btnCancel.layer.cornerRadius = 2;
            btnCancel.layer.masksToBounds = YES;
            btnCancel.layer.borderColor = RGBCOLOR(211, 211, 211).CGColor;
            btnCancel.layer.borderWidth = 0.5;
            btnCancel.frame = CGRectMake(_actionSheetTopView.frame.size.width - 5 - 47, 10, 47, 45 - 20);
            [btnCancel setTitle: @"取消" forState: UIControlStateNormal];
            [btnCancel setTitleColor: RGBCOLOR(65, 65, 65) forState: UIControlStateNormal];
            btnCancel.titleLabel.font = [UIFont systemFontOfSize: 12];
            [btnCancel addTarget: self action: @selector(hide) forControlEvents: UIControlEventTouchUpInside];
            [_actionSheetTopView addSubview: btnCancel];
            
            // 添加上下分割线
            UIImageView *line = [[UIImageView alloc] init];
            line.backgroundColor = RGBCOLOR(211, 211, 211);
            line.frame = CGRectMake(0, 45, kScreenSize.width, 1);
            [_actionSheetView addSubview: line];
        }
        
        _actionSheetBottomView = [[UIView alloc] init];
        CGFloat height = _destroyItemTitle ? (others.count+1)*45+(others.count)*kButtonMargin+kButtonMargin*2:others.count*45+(others.count-1)*kButtonMargin+kButtonMargin*2;
        _actionSheetBottomView.frame = CGRectMake(0, _actionSheetTopView == nil? 0: 46, kScreenSize.width, height);
        [_actionSheetView addSubview:_actionSheetBottomView];
        
        // 往下半部分视图上添加按钮
        if(destoryTitle) {
            _destroyItemTitle = destoryTitle;
            // 有毁灭性按钮
            if(others == nil || others.count == 0) {
                // 没有其他按钮
                UIButton *btnDestroy = [UIButton buttonWithType: UIButtonTypeCustom];
                [btnDestroy setBackgroundImage: [UIImage imageNamed: @"btn_menu_red_n.png"] forState: UIControlStateNormal];
                btnDestroy.frame = CGRectMake(20, kButtonMargin, kScreenSize.width-20*2, 45);
                [btnDestroy setTitle: destoryTitle forState: UIControlStateNormal];
                btnDestroy.titleLabel.font = [UIFont systemFontOfSize: 15];
                [btnDestroy addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                
                btnDestroy.tag = kDestroyButtonTag;
                
                [_actionSheetBottomView addSubview: btnDestroy];
            } else {
                // 有其他按钮，先加载其他按钮
                [_titlesArray addObjectsFromArray: others];
                for(NSInteger i = 0;i < others.count;i++) {
                    UIButton *btnNormal = [UIButton buttonWithType: UIButtonTypeCustom];
                    [btnNormal setBackgroundImage: [UIImage imageNamed: @"btn_menu_grey_n.png"] forState: UIControlStateNormal];
                    btnNormal.frame = CGRectMake(20, kButtonMargin*(i+1)+45*i, kScreenSize.width-20*2, 45);
                    [btnNormal setTitle: others[i] forState: UIControlStateNormal];
                    btnNormal.titleLabel.font = [UIFont systemFontOfSize: 15];
                    [btnNormal addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                    
                    btnNormal.tag = kNormalButtonTag+i;
                    [_actionSheetBottomView addSubview: btnNormal];
                }
                // 然后加载毁灭性按钮
                UIButton *btnDestroy = [UIButton buttonWithType: UIButtonTypeCustom];
                [btnDestroy setBackgroundImage: [UIImage imageNamed: @"btn_menu_red_n.png"] forState: UIControlStateNormal];
                btnDestroy.frame = CGRectMake(20, kButtonMargin*(others.count+1)+45*others.count, kScreenSize.width-20*2, 45);
                [btnDestroy setTitle: destoryTitle forState: UIControlStateNormal];
                btnDestroy.titleLabel.font = [UIFont systemFontOfSize: 15];
                [btnDestroy addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                btnDestroy.tag = kDestroyButtonTag;
                [_actionSheetBottomView addSubview: btnDestroy];
            }
        } else {
            // 没有毁灭性按钮
            if(others == nil || others.count == 0) {
                // 没有其他按钮
            } else {
                // 有其他按钮，先加载其他按钮
                [_titlesArray addObjectsFromArray: others];
                for(NSInteger i = 0;i < others.count;i++) {
                    UIButton *btnNormal = [UIButton buttonWithType: UIButtonTypeCustom];
                    [btnNormal setBackgroundImage: [UIImage imageNamed: @"btn_menu_grey_n.png"] forState: UIControlStateNormal];
                    btnNormal.frame = CGRectMake(20, kButtonMargin*(i+1)+45*i, kScreenSize.width-20*2, 45);
                    [btnNormal setTitle: others[i] forState: UIControlStateNormal];
                    btnNormal.titleLabel.font = [UIFont systemFontOfSize: 15];
                    [btnNormal addTarget: self action: @selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside];
                    
                    btnNormal.tag = kNormalButtonTag+i;
                    
                    [_actionSheetBottomView addSubview: btnNormal];
                }
            }
        }
        // 毁灭性按钮的tag设为-1
        _itemDidSelectedIdx  = -1;
    }
    return self;
}
- (void)showInSuperView
{
    UIView *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    CGFloat actionSheetHeight = _actionSheetTopView.frame.size.height + _actionSheetBottomView.frame.size.height;
    _actionSheetView.frame = CGRectMake(0, self.frame.size.height - actionSheetHeight, self.frame.size.width, actionSheetHeight);
    [window addSubview: self];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = _actionSheetView.frame;
        rect.origin.y += rect.size.height;
        _actionSheetView.frame = rect;
        self.backgroundColor = [UIColor colorWithWhite: 0 alpha: 0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
// 按钮点击事件
- (void)buttonAction:(UIButton *)btn
{
    [self hide];
    if(btn.tag == kDestroyButtonTag) {
        
        if ([_delegate respondsToSelector:@selector(screenPlate:clickedItemIndex:)])
        {
            [_delegate screenPlate:self clickedItemIndex:_itemDidSelectedIdx];
        }
    } else if(btn.tag >= kNormalButtonTag) {
        if ([_delegate respondsToSelector:@selector(screenPlate:clickedItemIndex:)])
        {
            [_delegate screenPlate:self clickedItemIndex:btn.tag -kNormalButtonTag];
        }
    }
}
- (NSString *)itemTitleWithAtIndex:(NSInteger)index
{
    if(index == _itemDidSelectedIdx) {
        if(_destroyItemTitle == nil || [_destroyItemTitle isEqual: @""]) {
            return nil;
        }
        return _destroyItemTitle;
    } else {
        if(index > _titlesArray.count) return nil;
        return _titlesArray[index];
    }
}
@end
