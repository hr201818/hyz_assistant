//
//  DS_LotteryListViewModel.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/28.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_LotteryListViewModel.h"

/** cell */
#import "DS_LotteryListCell.h"

@implementation DS_LotteryListViewModel

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = [[DS_FunctionTool allLottery] count];
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DS_LotteryListCell * cell = [tableView dequeueReusableCellWithIdentifier:DS_LotteryListCellID];
    if (!cell) {
        cell = [[DS_LotteryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DS_LotteryListCellID];
    }
    
    cell.lotteryID = [DS_FunctionTool allLottery][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DS_LotteryListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectLotteryBlock) {
        self.selectLotteryBlock([DS_FunctionTool allLottery][indexPath.row]);
    }
}

@end
