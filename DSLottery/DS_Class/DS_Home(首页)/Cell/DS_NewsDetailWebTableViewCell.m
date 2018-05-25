//
//  DS_NewsDetailWebTableViewCell.m
//  DSLottery
//
//  Created by 黄玉洲 on 2018/5/12.
//  Copyright © 2018年 海南达生实业有限公司. All rights reserved.
//

#import "DS_NewsDetailWebTableViewCell.h"

@interface DS_NewsDetailWebTableViewCell () <UIWebViewDelegate>
/** 容器 */
@property (strong, nonatomic) UIView       * containView;

/** 点个赞吧 */
@property (strong, nonatomic) UILabel      * tipLab;

/** 点赞按钮 */
@property (strong, nonatomic) UIButton     * supportButton;

/** 点赞icon */
@property (strong, nonatomic) UIImageView  * praiseIcon;

/** 点赞数量 */
@property (strong, nonatomic) UILabel      * praiseNumberLab;

@property (strong, nonatomic) UIWebView    * webView;



@end

@implementation DS_NewsDetailWebTableViewCell
- (void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    NSLog(@"webView dellock:%@",[self class]);
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutView];
    }
    return self;
}

#pragma mark - 界面
/** 布局 */
- (void)layoutView {
    self.contentView.backgroundColor = COLOR_BACK;
    
    [self.contentView addSubview:self.containView];
    
    [_containView addSubview:self.webView];
    
    [_containView addSubview:self.tipLab];
    
    [_containView addSubview:self.supportButton];
    
    [_containView addSubview:self.praiseIcon];
    
    [_containView addSubview:self.praiseNumberLab];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

#pragma mark - 观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentSize"]){
        CGSize fa = [self.webView sizeThatFits:CGSizeZero];
        _containView.frame = CGRectMake(0, 0, fa.width, fa.height + 150);
        _webView.frame = CGRectMake(0, 0, fa.width, fa.height);
        
        // 提示
        _tipLab.top = _webView.bottom + 25;
        _tipLab.centerX = _containView.width / 2.0;;
        _tipLab.hidden = NO;
        
        // 点赞按钮
        _supportButton.top = _tipLab.bottom;
        _supportButton.centerX = _tipLab.centerX;
        _supportButton.hidden = NO;
        
        // 点赞icon
        _praiseIcon.top = _supportButton.bottom;
        _praiseIcon.centerX = _tipLab.centerX - 10;
        _praiseIcon.hidden = NO;
        
        // 点赞数量
        _praiseNumberLab.top = _praiseIcon.top;
        _praiseNumberLab.left = _praiseIcon.right + 5;
        _praiseNumberLab.hidden = NO;
        
        if (self.webHeightBlock) {
            self.webHeightBlock(fa.height + 150);
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

#pragma mark - setter
- (void)setModel:(DS_NewsModel *)model {
    if (model) {
        _model = model;
        [_webView loadHTMLString:model.content baseURL:nil];
        _praiseNumberLab.text = model.thumbsUpNumb;
        
        if (_model.isPraised) {
            [_supportButton setImage:DS_UIImageName(@"praised") forState:UIControlStateNormal];
            _supportButton.userInteractionEnabled = NO;
        } else {
            [_supportButton setImage:DS_UIImageName(@"praise") forState:UIControlStateNormal];
            _supportButton.userInteractionEnabled = YES;
        }
    }
}

#pragma mark - 懒加载
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, 1)];
        _containView.backgroundColor = [UIColor whiteColor];
    }
    return _containView;
}

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

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.frame = CGRectMake(0, 0, Screen_WIDTH, 20);
        _tipLab.font = FONT(16.0f);
        _tipLab.textColor = COLOR_Font151;
        _tipLab.text = DS_STRINGS(@"kPleasePraise");
        _tipLab.hidden = YES;
        _tipLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLab;
}

- (UIButton *)supportButton {
    if (!_supportButton) {
        _supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _supportButton.frame = CGRectMake(0, 0, 100, 48);
        [_supportButton addTarget:self action:@selector(supportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _supportButton.hidden = YES;
    }
    return _supportButton;
}

- (UIImageView *)praiseIcon {
    if (!_praiseIcon) {
        _praiseIcon = [[UIImageView alloc] init];
        _praiseIcon.frame = CGRectMake(0, 0, 20, 20);
        _praiseIcon.image = DS_UIImageName(@"praise_small");
        _praiseIcon.hidden = YES;
    }
    return _praiseIcon;
}

- (UILabel *)praiseNumberLab {
    if (!_praiseNumberLab) {
        _praiseNumberLab = [[UILabel alloc] init];
        _praiseNumberLab.frame = CGRectMake(0, 0, 150, 20);
        _praiseNumberLab.font = FONT(14.0f);
        _praiseNumberLab.textColor = COLOR_Font151;
        _praiseNumberLab.text = @"0";
        _praiseNumberLab.hidden = YES;
    }
    return _praiseNumberLab;
}





@end
