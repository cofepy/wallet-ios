//
//  XXSymbolDetailFooterView.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSymbolDetailFooterView.h"
#import "XXTokenModel.h"

@interface XXSymbolDetailFooterView ()

@property (nonatomic, strong) XXButton *firstBtn;
@property (nonatomic, strong) XXButton *secondBtn;
@property (nonatomic, strong) XXButton *thirdBtn;
@property (nonatomic, strong) XXButton *forthBtn;

@end

@implementation XXSymbolDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setTokenModel:(XXTokenModel *)tokenModel {
    _tokenModel = tokenModel;
    [self buildUI];
}

- (void)buildUI {
    NSArray *imageArr;
    NSArray *titleArr;
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        imageArr = kIsNight ? @[@"receiveMoney_Night",@"payMoney_Night",@"withdrawMoney_Night",@"inMoney_Night"] : @[@"receiveMoney",@"payMoney",@"withdrawMoney",@"chainReceiveMoney"];
        titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"Transfer"),LocalizedString(@"WithdrawMoney"),LocalizedString(@"DelegateAndRelieve")];
    } else {
        if (self.tokenModel.is_native) {
            if ([[XXSqliteManager sharedSqlite] existMapModel:self.tokenModel.symbol]) {
                imageArr = kIsNight ? @[@"receiveMoney_Night",@"payMoney_Night",@"chainPayMoney_Night"] : @[@"receiveMoney",@"payMoney",@"chainReceiveMoney"];
                titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"Transfer"),LocalizedString(@"Exchange")];
            } else {
                imageArr = kIsNight ? @[@"receiveMoney_Night",@"payMoney_Night"] : @[@"receiveMoney",@"payMoney"];
                titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"Transfer")];
            }
        } else {
            if ([[XXSqliteManager sharedSqlite] existMapModel:self.tokenModel.symbol]) {
                imageArr = kIsNight ? @[@"receiveMoney_Night",@"payMoney_Night",@"chainReceiveMoney_Night",@"chainPayMoney_Night"] : @[@"receiveMoney",@"payMoney",@"chainInOut",@"chainReceiveMoney"];
                titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"Transfer"),LocalizedString(@"ChainDepositTip2"),LocalizedString(@"Exchange")];
            } else {
                imageArr = kIsNight ? @[@"receiveMoney_Night",@"payMoney_Night",@"chainReceiveMoney_Night",@"chainPayMoney_Night"] : @[@"receiveMoney",@"payMoney",@"chainInOut"];
                titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"Transfer"),LocalizedString(@"ChainDepositTip2")];
            }
        }
    }
    CGFloat btnWidth = (kScreen_Width - K375(15))/titleArr.count;
    for (NSInteger i=0; i < imageArr.count; i ++) {
        MJWeakSelf
        XXButton *itemButton = [XXButton buttonWithFrame:CGRectMake(K375(7.5) + btnWidth*i, 0, btnWidth, 107) block:^(UIButton *button) {
            [weakSelf buttonClick:button];
        }];
        itemButton.tag = 100 + i;
        [self addSubview:itemButton];
        
        CGFloat shadowViewWidth = 48;
        if (i > 1) {
            shadowViewWidth = shadowViewWidth*4/3;
        }
        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake((itemButton.width - shadowViewWidth)/2.0, 16, shadowViewWidth, 48)];
        shadowView.backgroundColor = kBackgroundLeverSecond;
        shadowView.layer.cornerRadius = 18.0;
        shadowView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        shadowView.layer.shadowOpacity = 1;
        shadowView.layer.shadowColor = [kShadowColor CGColor];
        shadowView.layer.shadowRadius = 6.0f;
        shadowView.userInteractionEnabled = NO;
        [itemButton addSubview:shadowView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((shadowView.width - 24)/2.0, (shadowView.height - 24)/2.0, 24, 24)];
        iconImageView.backgroundColor = kBackgroundLeverSecond;
        iconImageView.image = [UIImage imageNamed:imageArr[i]];
        [shadowView addSubview:iconImageView];
        
        if (i > 1) {
            UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame), (shadowView.height - 16)/2.0, 16, 16)];
            arrowImageView.backgroundColor = kBackgroundLeverSecond;
            arrowImageView.image = [UIImage imageNamed:@"arrowdown"];
            [shadowView addSubview:arrowImageView];
        }
        
        XXLabel *nameLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(shadowView.frame), itemButton.width, 42) text:titleArr[i] font:kFont12 textColor:kGray900 alignment:NSTextAlignmentCenter];
        nameLabel.numberOfLines = 0;
        [itemButton addSubview:nameLabel];
    }
}

- (void)buttonClick:(UIButton *)sender {
    self.actionBlock(sender.tag - 100);
}

@end
