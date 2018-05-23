//
//  DS_ShopTableViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/15.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_ShopTableViewCell.h"

@interface DS_ShopTableViewCell ()

@property (strong, nonatomic) UIImageView * imageIcon;

@property (strong, nonatomic) UILabel     * title;

@property (strong, nonatomic) UILabel     * content;

@end

@implementation DS_ShopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = COLOR_Line;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.bottom.equalTo(@0);
        make.height.equalTo(@0.6);
    }];
    
    // 图片
    [self.contentView addSubview:self.imageIcon];
    [_imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(@55);
        make.centerY.equalTo(@0);
        make.left.equalTo(@5);
    }];
    
    // 名称
    [self.contentView addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageIcon.mas_right).offset(10);
        make.right.equalTo(@0);
        make.height.equalTo(@25);
        make.top.equalTo(@10);
    }];
    
    // 地址
    [self.contentView addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageIcon.mas_right).offset(10);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(-8));
        make.top.equalTo(self.title.mas_bottom).offset(0);
    }];
    
}

#pragma mark - setter
- (void)setModel:(BMKPoiInfo *)model {
    _model = model;
    
    // 百度地图商铺图片
    NSString * urlStr = [NSString stringWithFormat:@"http://api.map.baidu.com/panorama/v2?ak=TS9nyRMSTDTX3RRMgWGsL0WivcEcUvLM&location=%lf,%lf&poiid=%@",model.pt.longitude,model.pt.latitude,model.uid];
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    self.title.text = _model.name;
    self.content.text = _model.address;
}

#pragma mark - 懒加载
- (UIImageView *)imageIcon {
    if (!_imageIcon) {
        _imageIcon = [[UIImageView alloc]init];
        _imageIcon.backgroundColor = COLOR_BACK;
        _imageIcon.layer.masksToBounds = YES;
        _imageIcon.layer.cornerRadius = 5;
        _imageIcon.clipsToBounds = YES;
        _imageIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageIcon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = COLOR_Font53;
        _title.font = [UIFont systemFontOfSize:16];
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textColor = COLOR_Font151;
        _content.font = [UIFont systemFontOfSize:13];
        _content.numberOfLines = 0;
    }
    return _content;
}



@end
