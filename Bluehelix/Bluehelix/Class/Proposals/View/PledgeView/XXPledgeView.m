//
//  XXPledgeView.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXPledgeView.h"
#import "XXTokenModel.h"
@interface XXPledgeView ()
/**委托数据模型*/
@property (nonatomic, strong) XXTokenModel *tokenModel;
/**撤销委托数据模型*/
@property (nonatomic, strong) XXHadDelegateModel *hadDelegateModel;

@end
@implementation XXPledgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        [self setupUI];
        [self loadData];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    self.contentSize = CGSizeMake(0, 500);
    // 提币主视图
    [self addSubview:self.mainView];
    
    /** 提醒内容  */
    [self.mainView addSubview:self.transferTipView];
    
    /** 委托数量 */
    [self.mainView addSubview:self.amountView];
    
    /**实际委托数量*/
    //[self.mainView addSubview:self.trueAmountView];

    /** 手续费 */
    [self.mainView addSubview:self.feeView];

    /** 加速视图 */
//    [self.mainView addSubview:self.speedView];

    /** 提示语视图 */
    [self.mainView addSubview:self.tipView];
}

- (void)loadData{

}
- (void)refreshAssets:(XXTokenModel*)tokenModel{
    self.tokenModel = tokenModel;
    self.amountView.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizedString(@"ValidatorAvilable"),self.tokenModel.amount,[kMainToken uppercaseString]];
    self.feeView.textField.text = kMinFee;
}
- (void)reloadTransferData{
    self.amountView.textField.text = [NSString stringWithFormat:@"%@",self.tokenModel.amount];
}

#pragma mark lazy load
/** 地址视图 */
- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 500)];
        _mainView.backgroundColor = kWhiteColor;
    }
    return _mainView;
}

- (XXTransferTipView *)transferTipView {
    if (_transferTipView == nil) {
        _transferTipView = [[XXTransferTipView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 136)];
    }
    return _transferTipView;
}

/** 委托数量 */
- (XXTransferAmountView *)amountView {
    @weakify(self)
    if (_amountView == nil) {
        _amountView = [[XXTransferAmountView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.transferTipView.frame), kScreen_Width, 110)];
        _amountView.userInteractionEnabled = YES;
        [_amountView.allButton setTitle:LocalizedString(@"DelegateAll") forState:UIControlStateNormal];
        _amountView.textField.placeholder = @"";
        _amountView.nameLabel.text = LocalizedString(@"ProposalPledgeAmount");
        _amountView.allButtonActionBlock = ^{
            @strongify(self)
            [self reloadTransferData];
        };
    }
    return _amountView;
}
///** 实际委托数量 */
//- (XXWithdrawFeeView *)trueAmountView {
//    if (_trueAmountView == nil) {
//        _trueAmountView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.amountView.frame), kScreen_Width, 96)];
//        _trueAmountView.nameLabel.text = LocalizedString(@"DelegateTrueAmount");
//        _trueAmountView.textField.enabled = NO;
//        _trueAmountView.unitLabel.text = [kMainToken uppercaseString];
//    }
//    return _trueAmountView;
//}

/** 手续费 */
- (XXWithdrawFeeView *)feeView {
    if (_feeView == nil) {
        _feeView = [[XXWithdrawFeeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.amountView.frame), kScreen_Width, 96)];
        //_feeView.textField.placeholder = LocalizedString(@"PleaseEnterFee");
        _feeView.textField.enabled = YES;
        _feeView.unitLabel.text = [kMainToken uppercaseString];
    }
    return _feeView;
}

/** 提币加速视图 */
- (XXWithdrawSpeedView *)speedView {
    if (_speedView == nil) {
        _speedView = [[XXWithdrawSpeedView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.feeView.frame), kScreen_Width, 72)];
        _speedView.nameLabel.text = LocalizedString(@"TransferSpeed");
//        [_speedView.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _speedView;
}

/** 提示语视图 */
- (XXWithdrawTipView *)tipView {
    if (_tipView == nil) {
        _tipView = [[XXWithdrawTipView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.speedView.frame), kScreen_Width, 10)];
    }
    return _tipView;
}

@end
