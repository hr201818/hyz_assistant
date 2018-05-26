//
//  DS_HomeLotteryNoticeCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/23.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_HomeLotteryNoticeCell.h"
#import "YM_DrawDigitalRoundView.h"
#import "DS_BaseTabBarController.h"
@interface DS_HomeLotteryNoticeCell ()

/** 分隔线左侧视图 */
@property (strong, nonatomic) UIView * leftContainView;

/** 分隔线右侧视图 */
@property (strong, nonatomic) UIView * rightContainView;

/* 存放开奖结果的View父视图 */
@property (strong, nonatomic) UIView  * backView;

/** 彩种图片 */
@property (strong, nonatomic) UIImageView * lotteryImageView;

/** 彩种标题 */
@property (strong, nonatomic) UILabel * titleLab;

/** cell右侧按钮 */
@property (strong, nonatomic) UIButton * rightButton;

@end

@implementation DS_HomeLotteryNoticeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* 布局视图*/
        [self layoutView];
        
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    
    // 左侧容器视图
    [self.contentView addSubview:self.leftContainView];
    [_leftContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
    
    // 图片
    [_leftContainView addSubview:self.lotteryImageView];
    [self.lotteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(_leftContainView);
        make.centerY.mas_equalTo(_leftContainView);
    }];
    
    // 右侧容器视图
    [self.contentView addSubview:self.rightContainView];
    [_rightContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftContainView.mas_right);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    // 彩种标题
    [_rightContainView addSubview:self.titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(20);
        make.height.mas_greaterThanOrEqualTo(0); // 自动适配高度
    }];
    
    //圆球的父视图，方便清除
    [_rightContainView addSubview:self.backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLab);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(65);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(5);
    }];
    
    [_rightContainView addSubview:self.rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_rightContainView);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(25);
    }];
    
    UIView * lineHorizontal = [[UIView alloc] init];
    lineHorizontal.backgroundColor = COLOR_Line;
    [self.contentView addSubview:lineHorizontal];
    [lineHorizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - setter
- (void)setModel:(DS_LotteryNoticeModel *)model {
    _model = model;
    
    NSString * title = model.playGroupName;
    
    if (_isLottery) {
        
        
        // 获取字符
        NSString * periodStr = [NSString stringWithFormat:@"  %@期",model.number];
        NSString * timeStr = [DS_FunctionTool timestampTo:model.openTime formatter:@"  yyyy-MM-dd HH:mm"];
        NSString * allStr = [NSString stringWithFormat:@"%@%@%@", title, periodStr, timeStr];
        
        // 配置富文本
        NSRange allStrRange = NSMakeRange(0, allStr.length);
        NSRange timeStrRange = [allStr rangeOfString:timeStr];
        NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:allStr];
        [mAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:allStrRange];
        [mAttribute addAttribute:NSFontAttributeName value:FONT(13.0f) range:allStrRange];
        [mAttribute addAttribute:NSForegroundColorAttributeName value:COLOR_Font151 range:timeStrRange];
        [mAttribute addAttribute:NSFontAttributeName value:FONT(12.0f) range:timeStrRange];
        
        // 展示富文本
        _titleLab.text = allStr;
        _titleLab.attributedText = mAttribute;
        
    } else {
        // 获取字符
        NSString * periodStr = [NSString stringWithFormat:@"  第%@期开奖",model.number];
        NSString * allStr = [NSString stringWithFormat:@"%@%@", title, periodStr];
        
        // 配置富文本
        NSRange allStrRange = NSMakeRange(0, allStr.length);
        NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:allStr];
        [mAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:allStrRange];
        [mAttribute addAttribute:NSFontAttributeName value:FONT(13.0f) range:allStrRange];
        
        // 展示富文本
        _titleLab.text = allStr;
        _titleLab.attributedText = mAttribute;
    }
    
    
    _lotteryImageView.image = [UIImage imageNamed:[DS_FunctionTool imageNameWithImageID:model.playGroupId]];
    
    // 获取彩种颜色
    UIColor * color = [DS_FunctionTool lotteryColorWithLotteryID:_model.playGroupId];
    
    NSArray *array = [model.openCode componentsSeparatedByString:@","];
    CGFloat left = IOS_SiZESCALE(0);
    CGFloat top = IOS_SiZESCALE(0);
    NSInteger all = 0;
    for (int i = 0; i < array.count; i++) {
        if (i % 7 == 0 && i != 0) {
            left = IOS_SiZESCALE(0);
            top += IOS_SiZESCALE(30);
        } else if (i != 0) {
            left += IOS_SiZESCALE(30);
        }
        
        YM_DrawDigitalRoundView * digitalView = [[YM_DrawDigitalRoundView alloc] initWithFrame:CGRectMake(left, top, IOS_SiZESCALE(25), IOS_SiZESCALE(25)) number:[array[i] integerValue]];
        digitalView.isFill = YES;
        digitalView.textFont = FONT(15.0f);
        digitalView.textColor = [UIColor whiteColor];
        digitalView.borderColor = color;
        [_backView addSubview:digitalView];
        
        // 双色球单独处理
        if ([model.playGroupId isEqualToString:@"12"] && i == array.count - 1) {
            digitalView.textColor = [UIColor blueColor];
        }
        
        [digitalView redraw];
        
        // 获取开奖总数
        all+= [array[i] integerValue];
    }
    
    left = -2;
    for (int i = 0; i < 5; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(left, top + IOS_SiZESCALE(25) + 5, 25, 25)];
        label.textColor = color;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [_backView addSubview:label];
        left += IOS_SiZESCALE(30);
        switch (i) {
            case 0:
                label.text = [NSString stringWithFormat:@"%ld",all];
                break;
            case 1:
                if(all % 2 == 0){
                    label.text = @"双";
                }else{
                    label.text = @"单";
                }
                break;
            case 2:
                if(all <= 22){
                    label.text = @"小";
                }else{
                    label.text = @"大";
                }
                break;
            case 3:
                if([array[0] integerValue] == [array[4] integerValue]){
                    label.text= @"和";
                }else if([array[0] integerValue] > [array[4] integerValue]){
                    label.text= @"龙";
                }else{
                    label.text= @"虎";
                }
                break;
            case 4:
                if ([[array firstObject] integerValue] > [[array lastObject] integerValue]) {
                    label.text = @"尾大";
                } else {
                    label.text = @"尾小";
                }
                break;
            default:
                break;
        }
    }
}

- (void)setIsLottery:(BOOL)isLottery {
    _isLottery = isLottery;
    if (isLottery) {
        [_rightButton setTitle:DS_STRINGS(@"kDetail") forState:UIControlStateNormal];
        _rightButton.backgroundColor = [UIColor clearColor];
        _rightButton.layer.cornerRadius = 0;
        [_rightButton setTitleColor:COLOR_HexRGB(@"219ED1") forState:UIControlStateNormal];
        _rightButton.userInteractionEnabled = NO;
    } else {
        [_rightButton setTitle:DS_STRINGS(@"kBetting") forState:UIControlStateNormal];
        _rightButton.backgroundColor =  [UIColor colorFromHexRGB:@"#2F9BD3"];
        _rightButton.layer.cornerRadius = 25 / 2;
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    for (UIView *view in self.backView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark - 按钮事件
/** 投注按钮 */
- (void)bettingButtonAction:(UIButton *)sender {
    NSLog(@"点击了投注");
    DS_BaseTabBarController * viewController = (DS_BaseTabBarController *)KeyWindows.rootViewController;
    [viewController selectedIndex:1];
    weakifySelf
}

#pragma mark - 懒加载
- (UIView *)leftContainView {
    if (!_leftContainView) {
        _leftContainView = [[UIView alloc] init];
    }
    return _leftContainView;
}

- (UIView *)rightContainView {
    if (!_rightContainView) {
        _rightContainView = [[UIView alloc] init];
    }
    return _rightContainView;
}

- (UIImageView *)lotteryImageView {
    if (!_lotteryImageView) {
        _lotteryImageView = [[UIImageView alloc] init];
        _lotteryImageView.image = [UIImage imageNamed:@"chongqing"];
    }
    return _lotteryImageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 0;

    }
    return _titleLab;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:DS_STRINGS(@"kBetting") forState:UIControlStateNormal];
        _rightButton.backgroundColor =  [UIColor colorFromHexRGB:@"#2F9BD3"];
        _rightButton.layer.cornerRadius = 25 / 2;
        _rightButton.titleLabel.font = FONT(13.0f);
        [_rightButton addTarget:self action:@selector(bettingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end
