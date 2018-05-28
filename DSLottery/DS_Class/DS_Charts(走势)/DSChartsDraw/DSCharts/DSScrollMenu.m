//
//  DSScrollMenu.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/20.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DSScrollMenu.h"
#import "JJMenuItemCell.h"
static int  const kMenuHeight = 40;
static int const kLineHeight = 2;
static NSString *const kMenuItemCellIdentifier = @"JJMenuItemCell";
@interface DSScrollMenu()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
/**
 *  头部
 */
@property (nonatomic, strong) UICollectionView *menuCollectionView;
/**
 *  线
 */
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, assign) CGFloat minMenuItemSpace;
@end
@implementation DSScrollMenu
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}
/**
 * 初始化
 */
- (void)commonInit {
    /*
     * 初始化默认值
     */
    _menuTitles = [NSArray array];
    _currentIndex = 0;
    _menuBackgroundColor =[UIColor  whiteColor];
    _lineDsColor = [UIColor  clearColor];
    _normalFontColor = [UIColor colorWithRed:0.36f green:0.37f blue:0.37f alpha:1.00f];
    _selectedFontColor = [UIColor redColor];
    _normalFontSize = IOS_SiZESCALE(15);
    _selectedFontSize = IOS_SiZESCALE(16);
    _minMenuItemSpace = 20;
    /*
     * 标题栏
     */
    UICollectionViewFlowLayout *menuLayout = [[UICollectionViewFlowLayout alloc] init];
    menuLayout.minimumInteritemSpacing = 0;
    menuLayout.minimumLineSpacing = 0;
    menuLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:menuLayout];
    _menuCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _menuCollectionView.backgroundColor = _menuBackgroundColor;
    _menuCollectionView.showsHorizontalScrollIndicator = NO;
    _menuCollectionView.showsVerticalScrollIndicator = NO;
    _menuCollectionView.delegate = self;
    _menuCollectionView.dataSource = self;
    [_menuCollectionView registerClass:[JJMenuItemCell class] forCellWithReuseIdentifier:kMenuItemCellIdentifier];
    [self addSubview:_menuCollectionView];
    
    
    
    [_menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(kMenuHeight);
        make.top.offset(0);
    }];
    /*
     * 线
     */
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = _lineDsColor;
    [_menuCollectionView addSubview:_lineView];
    
    _line = [[UILabel alloc] init];
    _line.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [self addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.4);
        make.bottom.left.right.offset(0);
    }];
    
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_menuTitles.count > 0) {
        NSString *title = _menuTitles[(NSUInteger) indexPath.item];
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_selectedFontSize]}];
        size = CGSizeMake(size.width + _minMenuItemSpace, kMenuHeight);
        return size;
    }
    return CGSizeMake(0, 0);
}

#pragma mark - DataSource
- ( __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                            cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JJMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuItemCellIdentifier forIndexPath:indexPath];
    cell.normalFontColor = _normalFontColor;
    cell.normalFontSize = _normalFontSize;
    cell.selectedFontColor = _selectedFontColor;
    cell.selectedFontSize = _selectedFontSize;
    cell.title = _menuTitles[(NSUInteger) indexPath.item];
    cell.selected = _currentIndex == indexPath.item;
//    /*
//     * 默认点击
//     */
//    if ([collectionView indexPathsForSelectedItems].count <= 0) {
//        _currentIndex = -1;
//        [self selectItemAtIndex:0];
//    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuTitles.count;
}

#pragma mark - Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectItemAtIndex:indexPath.item];

}

#pragma mark - Action
/**
 * 选中某个菜单标签做出的反应
 */
- (void)selectItemAtIndex:(NSInteger)index {
    if (_currentIndex == index) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    /*
     * 默认选中时
     */
    BOOL animated = _currentIndex != -1;
    _currentIndex = index;
    [_menuCollectionView selectItemAtIndexPath:indexPath
                                      animated:animated
                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [self resizeLineViewWithIndexPath:indexPath animated:animated];
    // ***** 实现协议方法 返回标题
    if (self.selectedItemBlock) {
        if (_menuTitles.count > 0) {
         self.selectedItemBlock(index);
         }
    }
}
/**
 * 处理标示线
 */
- (void)resizeLineViewWithIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated{
    CGRect frame;
    JJMenuItemCell *cell = (JJMenuItemCell *) [_menuCollectionView cellForItemAtIndexPath:indexPath];
    if (!cell) {
        UICollectionViewLayoutAttributes *attributes = [_menuCollectionView layoutAttributesForItemAtIndexPath:indexPath];
        frame = attributes.frame;
    } else {
        frame = cell.frame;
    }
    CGRect rect = CGRectMake(CGRectGetMinX(frame)+ _minMenuItemSpace / 2, kMenuHeight - kLineHeight - 2, CGRectGetWidth(frame) - _minMenuItemSpace, kLineHeight);
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             _lineView.frame = rect;
                         }];
    } else {
        _lineView.frame = rect;
    }
}
- (void)setMenuTitles:(NSArray *)menuTitles {
    
    _menuTitles = menuTitles;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat totalWidth = 0;
    if (menuTitles.count > 0) {
        for (NSString *menuTitle in menuTitles) {
            totalWidth = totalWidth + [menuTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_selectedFontSize]}].width;
        }
    }
    if ((totalWidth + _minMenuItemSpace * _menuTitles.count) < screenWidth) {
        _minMenuItemSpace = (screenWidth - totalWidth) / _menuTitles.count;
    }
    
    [_menuCollectionView reloadData];
}

- (void)dealloc{
    NSLog(@"dealloc %@",[self class]);
}
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end




















































