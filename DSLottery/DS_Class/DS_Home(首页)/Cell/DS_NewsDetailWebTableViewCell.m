//
//  DS_NewsDetailWebTableViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsDetailWebTableViewCell.h"

@interface DS_NewsDetailWebTableViewCell () <UIWebViewDelegate>

@property (strong, nonatomic) UIView       * containView;

@property (strong, nonatomic) UIButton     * supportButton;

@property (strong, nonatomic) UIWebView    * webView;
@end

@implementation DS_NewsDetailWebTableViewCell
- (void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    NSLog(@"webView dellock:%@",[self class]);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    self.contentView.backgroundColor = COLOR_BACK;
    
    [self.contentView addSubview:self.containView];
    
    [_containView addSubview:self.webView];
    
    [_containView addSubview:self.supportButton];
    
}

-(void)setWebContent:(NSString *)webContent{
    if(webContent){
        _webContent = webContent;
        [self.webView loadHTMLString:webContent baseURL:nil];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentSize"]){
        CGSize fa = [self.webView sizeThatFits:CGSizeZero];
        _containView.frame = CGRectMake(0, 0, fa.width, fa.height + 60);
        _webView.frame = CGRectMake(0, 0, fa.width, fa.height);
        _supportButton.bottom = _containView.height - 10;
        _supportButton.centerX = _containView.width / 2.0;
        _supportButton.hidden = NO;
        if (self.webHeightBlock) {
            self.webHeightBlock(fa.height + 60);
        }
    }
}


#pragma mark - 按钮回调
/** 支持一下 */
- (void)supportButtonAction:(UIButton *)sender {
    if (self.supportBlock) {
        self.supportBlock();
    }
}

#pragma mark - 懒加载
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, 1)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.scrollEnabled = NO;
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIButton *)supportButton {
    if (!_supportButton) {
        _supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _supportButton.frame = CGRectMake(0, 0, IOS_SiZESCALE(280), IOS_SiZESCALE(40));
        [_supportButton setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        _supportButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_supportButton addTarget:self action:@selector(supportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _supportButton.hidden = YES;
    }
    return _supportButton;
}

- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, 1)];
        _containView.backgroundColor = [UIColor whiteColor];
    }
    return _containView;
}


@end
