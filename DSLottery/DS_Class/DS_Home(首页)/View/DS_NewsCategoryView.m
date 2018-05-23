//
//  DS_NewsCategoryView.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsCategoryView.h"
#import "DS_NewsCategoryCollectionViewCell.h"
@interface DS_NewsCategoryView () <UICollectionViewDelegate, UICollectionViewDataSource>

/** 列表 */
@property (strong, nonatomic) UICollectionView * collectionView;

@end

@implementation DS_NewsCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    
    UIView * backView = [[UIView alloc] init];
    backView.userInteractionEnabled = NO;
    backView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.width, self.height - NAVIGATIONBAR_HEIGHT);
    backView.backgroundColor = COLOR_Alpha(0, 0, 0, 0.5);
    [self addSubview:backView];
    
    [self addSubview:self.collectionView];
}

#pragma mark - setter
- (void)setNewsCategorys:(NSArray<DS_CategoryModel *> *)newsCategorys {
    if (newsCategorys) {
        _newsCategorys = newsCategorys;
        [self.collectionView reloadData];
    }
}

#pragma mark - other
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_newsCategorys count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DS_NewsCategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:DS_NewsCategoryCollectionViewCellID forIndexPath:indexPath];
    cell.model = _newsCategorys[indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
/**
 *  item点击
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self removeFromSuperview];
    DS_CategoryModel * model = _newsCategorys[indexPath.row];
    if (self.newsCategoryBlock) {
        self.newsCategoryBlock(model.ID);
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

/**
 *  item大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.width, IOS_SiZESCALE(40));
}

/**
 *  item横向间距（需要调整cell宽度）
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

/**
 *  item纵向间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Screen_WIDTH - self.width / 3, NAVIGATIONBAR_HEIGHT, self.width / 3, self.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[DS_NewsCategoryCollectionViewCell class] forCellWithReuseIdentifier:DS_NewsCategoryCollectionViewCellID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

@end
