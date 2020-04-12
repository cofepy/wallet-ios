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
        imageArr = @[@"receiveMoney",@"payMoney",@"withdrawMoney",@"inMoney"];
        titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"PayMoney"),LocalizedString(@"WithdrawMoney"),LocalizedString(@"InMoney")];
    } else {
        if (self.tokenModel.is_native) {
            imageArr = @[@"receiveMoney",@"payMoney"];
            titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"PayMoney")];
        } else {
            imageArr = @[@"receiveMoney",@"payMoney",@"chainReceiveMoney",@"chainPayMoney"];
            titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"PayMoney"),LocalizedString(@"ChainReceiveMoney"),LocalizedString(@"ChainPayMoney")];
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

        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake((itemButton.width - 48)/2.0, 16, 48, 48)];
        shadowView.backgroundColor = kViewBackgroundColor;
        shadowView.layer.cornerRadius = 24.0;
        shadowView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        shadowView.layer.shadowOpacity = 1;
        shadowView.layer.shadowColor = (KUser.isNightType ? KRGBA(4,11.5,18,100) : kDark20).CGColor;
        shadowView.userInteractionEnabled = NO;
        [itemButton addSubview:shadowView];

        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((shadowView.width - 24)/2.0, (shadowView.height - 24)/2.0, 24, 24)];
        iconImageView.image = [UIImage imageNamed:imageArr[i]];
        [shadowView addSubview:iconImageView];

        XXLabel *nameLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(shadowView.frame), itemButton.width, 32) text:titleArr[i] font:kFont12 textColor:kDark100 alignment:NSTextAlignmentCenter];
        [itemButton addSubview:nameLabel];
    }
}

- (void)buttonClick:(UIButton *)sender {
    self.actionBlock(sender.tag - 100);
}

@end
