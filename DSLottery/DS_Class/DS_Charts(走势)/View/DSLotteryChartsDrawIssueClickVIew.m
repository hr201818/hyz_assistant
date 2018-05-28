//
//  DSLotteryChartsDrawIssueClickVIew.m
//  ALLTIMELOTTERY
//
//  Created by wangzhijie on 2018/5/25.
//  Copyright © 2018年 科技有限公司. All rights reserved.
//

#import "DSLotteryChartsDrawIssueClickVIew.h"
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >> 8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define labelTextClor UIColorFromHex(0x5f646e)
@interface DSLotteryChartsDrawIssueClickVIew()
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *towBtn;
@property (weak, nonatomic) IBOutlet UIButton *ThreeBtn;

@end
@implementation DSLotteryChartsDrawIssueClickVIew
+(DSLotteryChartsDrawIssueClickVIew *)lotteryChartsDrawIssueClickView
{
    DSLotteryChartsDrawIssueClickVIew *   lotteryChartsDrawIssueClickView  = [[[NSBundle mainBundle] loadNibNamed:@"DSLotteryChartsDrawIssueClickVIew" owner:self options:nil] objectAtIndex:0];
    return lotteryChartsDrawIssueClickView;
}
- (void)awakeFromNib{
    [super awakeFromNib];
      [self.oneBtn setTitleColor:[UIColor colorWithRed:0.95f green:0.21f blue:0.21f alpha:1.00f] forState:UIControlStateNormal];
     [self.towBtn setTitleColor:labelTextClor forState:UIControlStateNormal];
     [self.ThreeBtn setTitleColor:labelTextClor forState:UIControlStateNormal];
}

- (IBAction)p_btnclick:(UIButton *)sender {
    if (sender.tag == 1) {
        [self.oneBtn setTitleColor:[UIColor colorWithRed:0.95f green:0.21f blue:0.21f alpha:1.00f] forState:UIControlStateNormal];
         [self.towBtn setTitleColor:labelTextClor forState:UIControlStateNormal];
         [self.ThreeBtn setTitleColor:labelTextClor forState:UIControlStateNormal];
    }else if (sender.tag == 2){
        [self.towBtn setTitleColor:[UIColor colorWithRed:0.95f green:0.21f blue:0.21f alpha:1.00f] forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:labelTextClor forState:UIControlStateNormal];
        [self.ThreeBtn setTitleColor:labelTextClor forState:UIControlStateNormal];
    }else{
        [self.ThreeBtn setTitleColor:[UIColor colorWithRed:0.95f green:0.21f blue:0.21f alpha:1.00f] forState:UIControlStateNormal];
        [self.towBtn setTitleColor:labelTextClor forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:labelTextClor forState:UIControlStateNormal];
    }
    if (self.issueClickBlock) {
        self.issueClickBlock(sender.tag);
    }
}
@end







