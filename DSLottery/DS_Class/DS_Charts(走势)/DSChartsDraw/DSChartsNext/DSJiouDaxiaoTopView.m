//
//  DSJiouDaxiaoTopView.m
//  DS_lottery
//
//  Created by pro on 2018/5/10.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DSJiouDaxiaoTopView.h"

@implementation DSJiouDaxiaoTopView

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)titleName leftName:(NSString *)leftName rightName:(NSString *)rightName;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR(255, 242, 242);
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height/2)];
        title.text = titleName;
        title.font = [UIFont systemFontOfSize:13];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor =COLOR(214, 31, 0);
        [self addSubview:title];

        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height/2, self.width, 0.5)];
        line.backgroundColor = COLOR(220, 220, 220);
        [self addSubview:line];

        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(self.width/2 - 0.2, self.height/2, 0.3, self.height/2)];
        line1.backgroundColor = COLOR(220, 220, 220);
        [self addSubview:line1];

        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(self.width - 0.3, 0, 0.3, self.height)];
        line2.backgroundColor = COLOR(220, 220, 220);
        [self addSubview:line2];

        UILabel * leftText = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height/2, self.width/2, self.height/2)];
        leftText.text = leftName;
        leftText.font = [UIFont systemFontOfSize:13];
        leftText.textAlignment = NSTextAlignmentCenter;
        leftText.textColor = COLOR(228, 87, 34);
        [self addSubview:leftText];

        UILabel * rightText = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2, self.height/2, self.width/2, self.height/2)];
        rightText.text = rightName;
        rightText.font = [UIFont systemFontOfSize:13];
        rightText.textAlignment = NSTextAlignmentCenter;
        rightText.textColor = COLOR(26, 152, 248);
        [self addSubview:rightText];

    }
    return self;
}


@end
