//
//  MusicSegmentView.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.

#import "MusicSegmentView.h"
#import "SegmentSelectedModel.h"
#import "MusicSegmentObserver.h"
@interface MusicSegmentView()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView * segmentScrollView;
@property(nonatomic,strong) UIView * scrollViewContentView;
@property(nonatomic,strong) NSMutableArray * segmentItmes;
@property(nonatomic,strong) MusicSegmentObserver * segmentObserver;
@property(nonatomic,assign) NSInteger  traggerFromCollectionView;
@end
@implementation MusicSegmentView
#pragma  mark  事件操作按钮
-(void)selectCollViewDidScrollViewFromIdx:(NSInteger)fromIdx toIdx:(NSInteger)toIdx flage:(BOOL)flage{
    if (toIdx >0|| toIdx <= self.segments.count) {
        __block UIButton * anchor =  self.segmentItmes[toIdx];
        if (anchor) {
            self.traggerFromCollectionView =flage;
            [self scrollViewClassOptional:anchor];
        }
    }
}

-(void)scrollViewClassOptional:(UIButton*)args{
    __block NSInteger _currentOptionalIndex = -1;
    CGFloat itemMinX = CGRectGetMinX(args.frame);
    CGFloat scrollWidth = CGRectGetWidth(self.segmentScrollView.frame);
    CGFloat scrollContentViewSizeX = CGRectGetWidth(self.scrollViewContentView.frame);
    CGFloat offSetX = 0.f;
    if (itemMinX < scrollWidth /2.f) {
        offSetX = 0.f;
    }else if(itemMinX > scrollWidth/2.f && itemMinX < (scrollContentViewSizeX-(CGRectGetWidth(args.frame) + scrollWidth/2.f))){
        offSetX = itemMinX - scrollWidth/2.f + CGRectGetWidth(args.frame)/2.f ;
    }else{
        offSetX = scrollContentViewSizeX - scrollWidth;
    }
    //当前按钮索引
    NSString * title = args.currentTitle;
    __weak typeof(self)weakSelf = self;
    [self.segments enumerateObjectsUsingBlock:^(SegmentSelectedModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong  typeof(weakSelf)strongSelf = weakSelf;
        UIButton * item = strongSelf.segmentItmes[idx];
        [item setSelected:NO];
        if ([obj.title isEqualToString:title]) {
            _currentOptionalIndex = idx;
        }
    }];
    if (_currentOptionalIndex != -1) {
        [args setSelected:YES];
    }
    [self.segmentScrollView setContentOffset:CGPointMake(offSetX, 0)];
    if (self.delegate && self.traggerFromCollectionView == 0 && _currentOptionalIndex != -1) {
        [self.delegate musicSegmentViewDidSelected:_currentOptionalIndex flage:1];
    }
}

-(void)segmentClicked:(UIButton*)args{
     self.traggerFromCollectionView = 0;
    [self scrollViewClassOptional:args];
}
#pragma mark -gettter
-(MusicSegmentObserver *)segmentObserver{
    _segmentObserver = ({
        if (!_segmentObserver) {
            _segmentObserver = [[MusicSegmentObserver alloc]init];
        }
        _segmentObserver;
    });
    return _segmentObserver;
}

-(UIView *)scrollViewContentView{
    _scrollViewContentView =({
        if (!_scrollViewContentView) {
            _scrollViewContentView = [[UIView alloc]initWithFrame:CGRectZero];
            _scrollViewContentView.backgroundColor = [UIColor clearColor];
        }
        _scrollViewContentView;
    });
    return _scrollViewContentView;
    
}
-(NSMutableArray *)segmentItmes{
    _segmentItmes = ({
        if (!_segmentItmes) {
            _segmentItmes = [NSMutableArray array];
        }
        _segmentItmes;
    });
    return _segmentItmes;
}

-(void)setSegments:(NSArray *)segments{
    _segments = segments;
    [self setSubViews];
}

-(UIScrollView *)segmentScrollView{
    _segmentScrollView = ({
        if(_segmentScrollView == nil){
            _segmentScrollView = [[UIScrollView alloc]init];
            _segmentScrollView.showsHorizontalScrollIndicator = NO;
            _segmentScrollView.showsVerticalScrollIndicator = NO;
        }
        _segmentScrollView;
    });
    return _segmentScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    __weak  typeof(self)weakSelf = self;
    [self addSubview:self.segmentScrollView];
    [self.segmentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.mas_equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf.mas_height);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(0.f);
    }];
    [self.segmentScrollView  addSubview:self.scrollViewContentView];
    [self.scrollViewContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.segmentScrollView).insets(UIEdgeInsetsZero);
        make.height.mas_equalTo(weakSelf.segmentScrollView.mas_height);
    }];
    [self setSubViews];
}

-(void)setSubViews{
    [self.scrollViewContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.segmentItmes removeAllObjects];
    if (self.segments == nil || self.segments.count ==0)return;
    __weak  typeof(self)weakSelf = self;
    for (int i = 0; i < self.segments.count; i++) {
        SegmentSelectedModel * model = self.segments[i];
        UIButton * segmentItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [segmentItem setTitle:model.title forState:UIControlStateNormal];
        [segmentItem setTitleColor:model.selectedStateColor forState:UIControlStateSelected];
        [segmentItem setTitleColor:model.normalStateColor forState:UIControlStateNormal];
        segmentItem.titleLabel.textAlignment = NSTextAlignmentLeft;
        CGFloat fontSize = model.fontSize == 0 ? widthEx(14.f) : model.fontSize;
        segmentItem.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [segmentItem addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventTouchUpInside];
        [segmentItem sizeToFit];
        [segmentItem setSelected:model.isSelected];
        [self.scrollViewContentView addSubview:segmentItem];
        [self.segmentItmes addObject:segmentItem];
    }
    //layout
    __block  UIButton * anchor = nil;
    __block  CGFloat  margin = 12;
    if (self.segmentItmes == nil)return;
    [self.segmentItmes enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.scrollViewContentView.mas_centerY).with.offset(0.f);
            make.height.mas_equalTo(weakSelf.scrollViewContentView.mas_height);
            if (anchor == nil) {
                make.left.mas_equalTo(weakSelf.scrollViewContentView.mas_left).with.offset(widthEx(margin));
            }else{
                make.left.mas_equalTo(anchor.mas_right).with.offset(widthEx(30.f));
            }
        }];
        anchor = obj;
    }];
    [self.scrollViewContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(anchor.mas_right).with.offset(widthEx(margin));
    }];
}
@end
