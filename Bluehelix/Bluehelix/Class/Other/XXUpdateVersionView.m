//
//  XXUpdateVersionView.m
//  Bhex
//
//  Created by Bhex on 2020/02/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXUpdateVersionView.h"
#import "XYHNumbersLabel.h"
@interface XXUpdateVersionView()

@property (nonatomic, strong) UIVisualEffectView *backView;
@property (nonatomic, strong) UIView *versionView;
@property (nonatomic, strong) UIImageView *rocketImageView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel;
@property (nonatomic, strong) UIButton *updateBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation XXUpdateVersionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)buildUIWithContent:(NSString *)content forceUpdate:(BOOL)forceFlag {
    [self addSubview:self.backView];
    [self addSubview:self.versionView];
    [self.versionView addSubview:self.rocketImageView];
//    [self.versionView addSubview:self.dismissBtn];
    [self.versionView addSubview:self.titleLabel];
    [self.versionView addSubview:self.contentLabel];
    [self.contentLabel setText:content];
    self.versionView.frame = CGRectMake(K375(24), (self.height - 280 -self.contentLabel.height)/2, kScreen_Width - K375(48), 280 + self.contentLabel.height);
    [self.versionView addSubview:self.updateBtn];
    if (forceFlag) {
        self.updateBtn.frame = CGRectMake(K375(24), self.versionView.height - 60, self.versionView.width - K375(48), 44);
//        self.dismissBtn.hidden = YES;
    } else {
        [self.versionView addSubview:self.cancelBtn];
        self.updateBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) + 8, self.versionView.height - 60, (self.versionView.width - K375(40))/2, 44);
//        self.dismissBtn.hidden = NO;
    }
}

+ (void)showWithUpdateVersionContent:(NSString *)content withSureBtnBlock:(void (^)(void))sureBtnBlock withCancelBtnBlock:(void (^)(void))cancelBtnBlock {
    
    XXUpdateVersionView *versionAlert = [[XXUpdateVersionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [versionAlert buildUIWithContent:content forceUpdate:NO];
    [KWindow addSubview:versionAlert];
    
    versionAlert.sureBtnBlock = sureBtnBlock;
    versionAlert.cancelBtnBlock = cancelBtnBlock;
    
    versionAlert.versionView.alpha = 1;
    versionAlert.backView.alpha = 0;
    versionAlert.versionView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        versionAlert.backView.alpha = 1;
        versionAlert.versionView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            versionAlert.versionView.transform = CGAffineTransformIdentity;
        }];
    }];
}

+ (void)showWithUpdateVersionContent:(NSString *)content withSureBtnBlock:(void (^)(void))sureBtnBlock {
    XXUpdateVersionView *versionAlert = [[XXUpdateVersionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [versionAlert buildUIWithContent:content forceUpdate:YES];
    [KWindow addSubview:versionAlert];
    versionAlert.sureBtnBlock = sureBtnBlock;
    
    versionAlert.versionView.alpha = 1;
    versionAlert.backView.alpha = 0;
    versionAlert.versionView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        versionAlert.backView.alpha = 1;
        versionAlert.versionView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            versionAlert.versionView.transform = CGAffineTransformIdentity;
        }];
    }];
}


+ (void)dismiss {
    XXUpdateVersionView *view = (XXUpdateVersionView *)[self currentView];
    if (view) {
        [UIView animateWithDuration:0.25f animations:^{
            view.versionView.alpha = 0;
            view.backView.alpha = 0;
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
}

+ (UIView *)currentView {
    for (UIView *view in [KWindow subviews]) {
        if ([view isKindOfClass:[self class]]) {
            return view;
        }
    }
    return nil;
}

- (void)updateAction {
    if (self.sureBtnBlock) {
        self.sureBtnBlock();
    }
    [[self class] dismiss];
}

- (void)cancelAction {
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock();
    }
    [[self class] dismiss];
}

- (UIVisualEffectView *)backView {
    if (_backView == nil) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _backView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _backView.alpha = 0.3f;
        _backView.frame = self.bounds;
    }
    return _backView;
}

- (UIView *)versionView {
    if (_versionView == nil) {
        _versionView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), (self.height - 304)/2, kScreen_Width - K375(48), 304)];
        _versionView.backgroundColor = [UIColor whiteColor];
        _versionView.layer.cornerRadius = 8;
//        _versionView.layer.masksToBounds = YES;
    }
    return _versionView;
}

- (UIImageView *)rocketImageView {
    if (_rocketImageView == nil) {
        _rocketImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -26, self.versionView.width, K375(194))];
        _rocketImageView.image = [UIImage imageNamed:@"updateVersion"];
    }
    return _rocketImageView;
}

//- (UIButton *)dismissBtn {
//    if (_dismissBtn == nil ) {
//        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - K375(30) - K375(50), 0, K375(50), K375(50))];
//        [_dismissBtn setImage:[UIImage imageNamed:@"versionUpdateDismiss"] forState:UIControlStateNormal];
//        [_dismissBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _dismissBtn;
//}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(K375(24), K375(164), kScreen_Width - K375(80), 24)];
        _titleLabel.text = LocalizedString(@"UpgradeAPP");
        _titleLabel.font = kFontBold18;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (XYHNumbersLabel *)contentLabel {
    if (_contentLabel ==nil) {
        _contentLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.titleLabel.frame) + 6, self.versionView.width - K375(48), 10) font:kFont14];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor blackColor];
    }
    return _contentLabel;
}

- (UIButton *)updateBtn {
    if (_updateBtn == nil) {
        _updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(K375(154), self.versionView.height - 60, 100, 44)];
        [_updateBtn setTitle:LocalizedString(@"Upgrade") forState:UIControlStateNormal];
        [_updateBtn setBackgroundColor:kPrimaryMain];
        [_updateBtn.titleLabel setFont:kFontBold17];
        [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_updateBtn addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
        _updateBtn.layer.cornerRadius = 4;
        _updateBtn.layer.masksToBounds = YES;
    }
    return _updateBtn;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(K375(16), self.versionView.height - 60, (self.versionView.width - K375(40))/2, 44)];
        [_cancelBtn setTitle:LocalizedString(@"Cancel") forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:KRGBA(244, 244, 245, 100)];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:kFontBold17];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.cornerRadius = 4;
        _cancelBtn.layer.masksToBounds = YES;
    }
    return _cancelBtn;
}
@end
