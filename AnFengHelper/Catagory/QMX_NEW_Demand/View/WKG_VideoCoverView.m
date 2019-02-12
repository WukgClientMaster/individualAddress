//
//  WKG_VideoCoverView.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/25.
//  Copyright © 2018年 NRH. All rights reserved.
//

typedef NS_ENUM(NSInteger,DraggerOritention){
    kDraggerOritention_Left,
    kDraggerOritention_Right
};

#import "WKG_VideoCoverView.h"
#import "WKG_VideoCollectionCell.h"
#import "VideoClipsTool.h"
static NSString * definer = @"VideoCollectionItemCellDefiner";
@interface WKG_VideoCoverView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UILabel * tips_label;
@property(nonatomic,strong) UIView * selected_cover_View;
@property(nonatomic,strong,readwrite) UICollectionView * collectionView;
@property(nonatomic,strong) MASConstraint * leftConstraint;
@property(nonatomic,assign) DraggerOritention oritention;
@property(nonatomic,strong) VideoClipsTool * videoClips;

@end
@implementation WKG_VideoCoverView
#pragma mark - IBOutlet Events
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    /*
     if (![scrollView isKindOfClass:[UICollectionView class]]|| !decelerate)return;
     CGFloat offSetX =  CGRectGetMidX(self.selected_cover_View.frame);
     CGFloat videoOffSetX = 0.f;
     CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
     CGFloat collectionContentSizeWidth = self.collectionView.contentSize.width;
     //collection.offsetX
     CGFloat collectionOffSetX = self.collectionView.contentOffset.x < 0 ? 0 :self.collectionView.contentOffset.x;
     collectionOffSetX = self.collectionView.contentOffset.x > collectionContentSizeWidth ? collectionContentSizeWidth: self.collectionView.contentOffset.x;
     if (offSetX < collectionViewWidth && collectionOffSetX == 0.f) {
     videoOffSetX = offSetX;
     }else if (offSetX < collectionViewWidth && collectionOffSetX !=0){
     videoOffSetX = (offSetX + collectionOffSetX) > collectionContentSizeWidth ? collectionContentSizeWidth: (offSetX + collectionOffSetX);
     }
     */
    /*
     CGFloat second = videoOffSetX / collectionContentSizeWidth;
     __weak typeof(self)weakSelf = self;
     [self.videoClips videoClipsTimeBySecond:second url:self.videoUrl handler:^(UIImage * img) {
     if (weakSelf.callback) {
     weakSelf.callback(img);
     }
     }];
     */
}

-(void)selectedCoverImageOptional:(UIPanGestureRecognizer*)recognizer{
    CGPoint draggingPoint = [recognizer locationInView:self];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (CGRectContainsPoint(self.selected_cover_View.frame, draggingPoint)) {
            self.oritention = kDraggerOritention_Left;
        }
    }
    if (self.oritention == kDraggerOritention_Left) {
        CGFloat margin = widthEx(23.5);
        CGFloat itemWidth = (KScreenWidth - 2 * margin)/8.f;
        CGFloat offSetX = draggingPoint.x - itemWidth/2.f + 6.f;
        self.leftConstraint.offset = offSetX;
        if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
            CGFloat videoOffSetX = 0.f;
            CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
            CGFloat collectionContentSizeWidth = self.collectionView.contentSize.width;
            //collection.offsetX
            CGFloat collectionOffSetX = self.collectionView.contentOffset.x;
            if (offSetX < collectionViewWidth && collectionOffSetX == 0.f) {
                videoOffSetX = offSetX;
            }else if (offSetX < collectionViewWidth && collectionOffSetX !=0){
                videoOffSetX = offSetX + collectionOffSetX;
            }
            CGFloat second = videoOffSetX / collectionContentSizeWidth;
            __weak typeof(self)weakSelf = self;
            if (self.items.count != 8) {
                return;
            }
            [self.videoClips videoClipsTimeBySecond:second url:self.videoUrl handler:^(UIImage * img) {
                if (weakSelf.callback) {
                    weakSelf.callback(img,@"NO");
                }
            }];
        }
    }
}

#pragma mark setter methods
-(void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl = videoUrl;
}

-(void)setItems:(NSMutableArray *)items{
    _items = items;
    if (_items.count >=1) {
        if (self.callback) {
            self.callback(_items[0],@"YES");
        }
    }
    [self.collectionView reloadData];
}
#pragma mark getter methods
-(VideoClipsTool *)videoClips{
    _videoClips = ({
        if (_videoClips==nil) {
            _videoClips
            =[VideoClipsTool shareInstance];
        }
        _videoClips;
    });
    return _videoClips;
}
-(UILabel *)tips_label{
    _tips_label = ({
        if (!_tips_label) {
            _tips_label = [[UILabel alloc]initWithFrame:CGRectZero];
            _tips_label.text = @"拖动滑块选择封面";
            _tips_label.textColor = [UIColor whiteColor];
            _tips_label.textAlignment = NSTextAlignmentCenter;
            _tips_label.font = [UIFont systemFontOfSize:16.f];
        }
        _tips_label;
    });
    return _tips_label;
}

-(UIView *)selected_cover_View{
    _selected_cover_View = ({
        if (!_selected_cover_View) {
            _selected_cover_View = [[UIView alloc]initWithFrame:CGRectZero];
            _selected_cover_View.layer.masksToBounds = YES;
            _selected_cover_View.backgroundColor = [UIColor clearColor];
            _selected_cover_View.layer.borderWidth = 3.f;
            _selected_cover_View.layer.borderColor = UIColorFromRGB(0x09ebcf).CGColor;
            UIPanGestureRecognizer * pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(selectedCoverImageOptional:)];
            _selected_cover_View.userInteractionEnabled = YES;
            [_selected_cover_View addGestureRecognizer:pangesture];
        }
        _selected_cover_View;
    });
    return _selected_cover_View;
}

-(UICollectionView *)collectionView{
    _collectionView = ({
        if (!_collectionView) {
            UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
            layOut.sectionInset = UIEdgeInsetsZero;
            layOut.minimumInteritemSpacing = 0.f;
            layOut.minimumLineSpacing = 0.f;
            layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            CGFloat margin = 23.5f;
            CGFloat itemWidth = (KScreenWidth - 2 * margin)/8.f;
            CGFloat itemHeight  = itemWidth * (90/ 42);
            layOut.itemSize = CGSizeMake(itemWidth,itemHeight);
            
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
            _collectionView.dataSource = self;
            _collectionView.delegate = self;
            _collectionView.backgroundColor = [Tools colorWithHexString:@"191b2a"];
            [_collectionView registerClass:[WKG_VideoCollectionCell class] forCellWithReuseIdentifier:definer];
            return _collectionView;
        }
        _collectionView;
    });
    return _collectionView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    __weak  typeof(self)weakSelf = self;
    [self addSubview:self.tips_label];
    [self.tips_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(0.f);
        make.centerX.mas_equalTo(weakSelf.mas_centerX).with.offset(0.f);
    }];
    __block  CGFloat margin = widthEx(23.5f);
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(margin);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-margin);
    make.top.mas_equalTo(weakSelf.tips_label.mas_bottom).with.offset(heightEx(30.f));
        CGFloat itemWidth = (KScreenWidth - 2 * margin)/8.f;
        CGFloat itemHeight  = itemWidth * (90/ 42);
        make.height.mas_equalTo(@(itemHeight));
    }];
    [self addSubview:self.selected_cover_View];
    [self.selected_cover_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(weakSelf.collectionView.mas_left);
        weakSelf.leftConstraint = make.left.equalTo(weakSelf.collectionView.mas_left).with.offset(0).priorityHigh();
        make.right.lessThanOrEqualTo(weakSelf.collectionView.mas_right).with.offset(0.f);
        make.top.mas_equalTo(weakSelf.collectionView.mas_top).offset(-3.f);
        make.bottom.mas_equalTo(weakSelf.collectionView.mas_bottom).with.offset(3.f);
        CGFloat margin = widthEx(23.5);
        CGFloat itemWidth = (KScreenWidth - 2 * margin)/8.f;
        CGFloat itemHeight  = itemWidth * (90/ 42);
        make.size.mas_equalTo(CGSizeMake(itemWidth + 3*2, itemHeight+3*2));
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WKG_VideoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:definer forIndexPath:indexPath];
    cell.coverImage = self.items[indexPath.row];
    return cell;
}

@end


