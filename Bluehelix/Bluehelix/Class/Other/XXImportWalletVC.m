//
//  XXImportWalletVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXImportWalletVC.h"
#import "XXImportMnemonicWordsVC.h"
#import "XXImportPrivateKeyVC.h"
#import "XXImportWayView.h"
#import "XXImportKeystoreVC.h"

@interface XXImportWalletVC ()

@property (nonatomic, strong) XXLabel *tipLabel;
@property (nonatomic, strong) XXImportWayView *mnemonicPhraseBtn;
@property (nonatomic, strong) XXImportWayView *keystoreBtn;
@property (nonatomic, strong) XXImportWayView *securityBtn;

@end

@implementation XXImportWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"ImportWallet");
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.mnemonicPhraseBtn];
    [self.view addSubview:self.keystoreBtn];
    [self.view addSubview:self.securityBtn];
}

- (XXLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), kNavHeight + 20, kScreen_Width - K375(48), 0) text:LocalizedString(@"ChooseImportWay") font:kFontBold(20) textColor:kGray900];
        _tipLabel.numberOfLines = 0;
        [_tipLabel sizeToFit];
    }
    return _tipLabel;
}

- (XXImportWayView *)mnemonicPhraseBtn {
    if (!_mnemonicPhraseBtn) {
        MJWeakSelf
        _mnemonicPhraseBtn = [[XXImportWayView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.tipLabel.frame) + 36, kScreen_Width - K375(48), 88) title:LocalizedString(@"ImportMnemonicPhrase") imageName:@"importPhrase"];
        _mnemonicPhraseBtn.clickBlock = ^{
            XXImportMnemonicWordsVC *importVC = [[XXImportMnemonicWordsVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        };
        _mnemonicPhraseBtn.backgroundColor = kWhiteColor;
        _mnemonicPhraseBtn.layer.cornerRadius = kBtnBorderRadius;
        _mnemonicPhraseBtn.layer.masksToBounds = YES;
        _mnemonicPhraseBtn.layer.borderColor = [kPrimaryMain CGColor];
        _mnemonicPhraseBtn.layer.borderWidth = 2;
    }
    return _mnemonicPhraseBtn;
}

- (XXImportWayView *)keystoreBtn {
    if (!_keystoreBtn) {
        MJWeakSelf
        _keystoreBtn = [[XXImportWayView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.mnemonicPhraseBtn.frame) + K375(24), kScreen_Width - K375(48), 88) title:LocalizedString(@"ImportKeystore") imageName:@"importKeystore"];
        _keystoreBtn.clickBlock = ^{
            XXImportKeystoreVC *importVC = [[XXImportKeystoreVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        };
        _keystoreBtn.backgroundColor = kWhiteColor;
        _keystoreBtn.layer.cornerRadius = kBtnBorderRadius;
        _keystoreBtn.layer.masksToBounds = YES;
        _keystoreBtn.layer.borderColor = [kPrimaryMain CGColor];
        _keystoreBtn.layer.borderWidth = 2;
    }
    return _keystoreBtn;
}

- (XXImportWayView *)securityBtn {
    if (!_securityBtn) {
        MJWeakSelf
        _securityBtn = [[XXImportWayView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.keystoreBtn.frame) + K375(24), kScreen_Width - K375(48), 88) title:LocalizedString(@"ImportSecurity") imageName:@"importKey"];
        _securityBtn.clickBlock = ^{
            XXImportPrivateKeyVC *importVC = [[XXImportPrivateKeyVC alloc] init];
            [weakSelf.navigationController pushViewController:importVC animated:YES];
        };
        _securityBtn.backgroundColor = kWhiteColor;
        _securityBtn.layer.cornerRadius = kBtnBorderRadius;
        _securityBtn.layer.masksToBounds = YES;
        _securityBtn.layer.borderColor = [kPrimaryMain CGColor];
        _securityBtn.layer.borderWidth = 2;
    }
    return _securityBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
