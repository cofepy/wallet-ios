//
//  XXVotingViewController.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXVotingViewController.h"
#import "XXVotingView.h"
#import "XXPasswordView.h"
#import "XXTokenModel.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXAssetManager.h"

@interface XXVotingViewController ()
@property (nonatomic, strong) XXVotingView *votingView;
/**按钮*/
@property (nonatomic, strong) XXButton *transferButton;

/**资产数据*/
@property (nonatomic, strong) XXAssetModel *assetModel;
/**资产请求*/
@property (nonatomic, strong) XXAssetManager *assetManager;

@property (strong, nonatomic) NSString *text;

/// 交易请求
@property (strong, nonatomic) XXMsgRequest *msgRequest;
@property (nonatomic, strong) NSString *voteResultSting;

@end

@implementation XXVotingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self configAsset];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    self.titleLabel.text = LocalizedString(@"ProposalNavgationTitleVote");
    [self.view addSubview:self.votingView];
    [self.view addSubview:self.transferButton];
}
#pragma mark load data
- (void)configAsset {
    [self.assetManager requestAsset];
    @weakify(self)
    self.assetManager.assetChangeBlock = ^{
        @strongify(self)
        [self refreshPledgeAmount];
    };
}
#pragma mark 刷新资产
- (void)refreshPledgeAmount{
    self.assetModel = [self.assetManager assetModel];
    for (XXTokenModel *tokenModel in self.assetModel.assets) {
        if ([[tokenModel.symbol uppercaseString] isEqualToString:[kMainToken uppercaseString]]) {
            [self.votingView refreshAssets:tokenModel];
            break;
        }
    }
}
#pragma mark privity
- (void)transferVerify {
    @weakify(self)
    if (self.voteResultSting.length >0 &&self.votingView.feeView.textField.text.length) {
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            @strongify(self)
            self.text = text;
            [self requestPledge];
           }];
    } else {
        Alert *alert = [[Alert alloc] initWithTitle:LocalizedString(@"PleaseFillAll") duration:kAlertDuration completion:^{
        }];
        [alert showAlert];
        return;
    }
}
/// 发起委托请求
- (void)requestPledge {
    XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
//    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.votingView.amountView.textField.text];
    NSDecimalNumber *feeAmountDecimal = [NSDecimalNumber decimalNumberWithString:self.votingView.feeView.textField.text];
    NSDecimalNumber *gasPriceDecimal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",self.votingView.speedView.slider.value]];
//    NSString *toAddress = self.pledgeView.addressView.textField.text;
//    NSString *amount = [[amountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *feeAmount = [[feeAmountDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
    NSString *gas = [[[feeAmountDecimal decimalNumberByDividingBy:gasPriceDecimal] decimalNumberByDividingBy:kPrecisionDecimal_U] stringValue];
    
    [MBProgressHUD showActivityMessageInView:@""];
    XXMsg *model = [[XXMsg alloc] initProposalMessageWithfrom:KUser.address
                                                              to:@""
                                                          amount:@""
                                                           denom:tokenModel.symbol
                                                       feeAmount:feeAmount
                                                          feeGas:gas
                                                        feeDenom:tokenModel.symbol
                                                            memo:tokenModel.symbol
                                                            type:kMsgVote
                                                    proposalType:@""
                                                   proposalTitle:@""
                                              proposalDescription:@""
                                                      proposalId:self.proposalModel.proposalId
                                               proposalOption:self.voteResultSting
                                                  withdrawal_fee:@""
                                                            text:self.text];


    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
    _msgRequest.msgSendSuccessBlock = ^{
        [MBProgressHUD hideHUD];
    };
    _msgRequest.msgSendFaildBlock = ^{
        [MBProgressHUD hideHUD];
    };
}

#pragma mark lazy load
- (XXVotingView *)votingView {
    if (!_votingView ) {
        _votingView = [[XXVotingView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 64)];
        @weakify(self)
        _votingView.voteStringBlock = ^(NSString * _Nonnull voteString) {
            @strongify(self)
            self.voteResultSting = voteString;
        };
    }
    return _votingView;
}
/** 按钮 */
- (XXButton *)transferButton {
    if (!_transferButton) {
        MJWeakSelf
        _transferButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, kScreen_Height - 80, kScreen_Width - KSpacing*2, 42) title:@"" font:kFontBold14 titleColor:kMainTextColor block:^(UIButton *button) {
            [weakSelf transferVerify];
        }];
        _transferButton.backgroundColor = kPrimaryMain;
        _transferButton.layer.cornerRadius = 3;
        _transferButton.layer.masksToBounds = YES;
        [_transferButton setTitle:LocalizedString(@"ProposalButtonTitleVote") forState:UIControlStateNormal];

    }
    return _transferButton;
}
- (XXAssetModel*)assetModel{
    if (!_assetModel) {
        _assetModel = [[XXAssetModel alloc]init];
    }
    return _assetModel;
}

- (XXAssetManager *)assetManager {
    if (!_assetManager) {
        @weakify(self)
        _assetManager = [[XXAssetManager alloc] init];
        _assetManager.assetChangeBlock = ^{
            @strongify(self)
            [self refreshPledgeAmount];
        };
    }
    return _assetManager;
}
@end
