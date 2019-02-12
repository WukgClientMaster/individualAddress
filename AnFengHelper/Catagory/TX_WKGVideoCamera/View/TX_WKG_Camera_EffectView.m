//
//  TX_WKG_Camera_EffectView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/11.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Camera_EffectView.h"
#import "TextImageCell.h"

@interface TX_WKG_Camera_EffectView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray *effectArray;
@end

typedef NS_ENUM(NSInteger,DemoFilterType) {
    FilterType_None         = 0,
    FilterType_white        ,   //美白滤镜
    FilterType_langman         ,   //浪漫滤镜
    FilterType_qingxin         ,   //清新滤镜
    FilterType_weimei         ,   //唯美滤镜
    FilterType_fennen         ,   //粉嫩滤镜
    FilterType_huaijiu         ,   //怀旧滤镜
    FilterType_landiao         ,   //蓝调滤镜
    FilterType_qingliang    ,   //清凉滤镜
    FilterType_rixi         ,   //日系滤镜
};

@implementation TX_WKG_Camera_EffectView
#pragma mark - setter methods
-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath{
    _selectedIndexPath = selectedIndexPath;
    TextImageCell *cell = (TextImageCell *)[self.effectCollectionView cellForItemAtIndexPath:_selectedIndexPath];
    [cell setSelected:YES];
    TextImageCell *selectCell = (TextImageCell *)[self.effectCollectionView cellForItemAtIndexPath:self.selectEffectIndexPath];
    [selectCell setSelected:NO];
    self.selectEffectIndexPath = self.selectedIndexPath;
}

#pragma mark - getter methods
- (NSMutableArray *)effectArray{
    if(!_effectArray){
        _effectArray = [[NSMutableArray alloc] init];
        [_effectArray addObject:@"原图"];
        [_effectArray addObject:@"清凉"];
        [_effectArray addObject:@"浪漫"];
        [_effectArray addObject:@"清新"];
        [_effectArray addObject:@"唯美"];
        [_effectArray addObject:@"粉嫩"];
        [_effectArray addObject:@"怀旧"];
        [_effectArray addObject:@"蓝调"];
        [_effectArray addObject:@"日系"];
        [_effectArray addObject:@"冷淡"];
        [_effectArray addObject:@"珊瑚"];
    }
    return _effectArray;
}
-(UICollectionView *)effectCollectionView{
    _effectCollectionView = ({
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        if (_effectCollectionView == nil) {
            _effectCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            _effectCollectionView.showsHorizontalScrollIndicator = NO;
            _effectCollectionView.backgroundColor = [UIColor clearColor];
            _effectCollectionView.delegate   = self;
            _effectCollectionView.dataSource = self;
            [_effectCollectionView registerClass:[TextImageCell class] forCellWithReuseIdentifier:@"ReuseIdentifier"];
        }
        _effectCollectionView;
    });
    return _effectCollectionView;
}

- (NSIndexPath *)selectEffectIndexPath{
    if(!_selectEffectIndexPath){
        _selectEffectIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    return _selectEffectIndexPath;
}

- (void)onSetEffectWithIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(onSetFilter:)]) {
        NSString* lookupFileName = @"";
        switch (index) {
            case 0:
                break;
            case 1:
                lookupFileName = @"qingliang.png";
                break;
            case 2:
                lookupFileName = @"langman.png";
                
                break;
            case 3:
                lookupFileName = @"qingxin.png";
                
                break;
            case 4:
                lookupFileName = @"weimei.png";
                
                break;
            case 5:
                lookupFileName = @"fennen.png";
                
                break;
            case 6:
                lookupFileName = @"huaijiu.png";
                
                break;
            case 7:
                lookupFileName = @"landiao.png";
                
                break;
            case 8:
                lookupFileName = @"rixi.png";
                break;
            case 9:
                lookupFileName = @"filter_cold.png";
                break;
            case 10:
                lookupFileName = @"filter_coral.png";
                break;
            default:
                break;
        }
        NSString * path = [[NSBundle mainBundle] pathForResource:@"FilterResource" ofType:@"bundle"];
        if (path != nil && index != FilterType_None) {
            path = [path stringByAppendingPathComponent:lookupFileName];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [self.delegate onSetFilter:image];
        }else {
            [self.delegate onSetFilter:nil];
        }
    }
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
    self.effectCollectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:self.effectCollectionView];
}
#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.effectArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TextImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];
    cell.label.text = self.effectArray[indexPath.row];
    if(self.selectEffectIndexPath.row == indexPath.row){
        [cell setSelected:YES];
    }
    else{
        [cell setSelected:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TextImageCell *cell = (TextImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(indexPath.row != self.selectEffectIndexPath.row){
        [cell setSelected:YES];
        TextImageCell *selectCell = (TextImageCell *)[collectionView cellForItemAtIndexPath:self.selectEffectIndexPath];
        [selectCell setSelected:NO];
        self.selectEffectIndexPath = indexPath;
        [self onSetEffectWithIndex:indexPath.row];
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return widthEx(12.5f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(widthEx(90), collectionView.frame.size.height);
}
@end
