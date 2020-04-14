//
//  XXTransactionCell.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

//page = 1;
//"page_size" = 30;
//total = 1;
//txs =     (
//            {
//        activities =             (
//                            {
//                type = "cosmos-sdk/MsgSend";
//                value =                     {
//                    amount =                         (
//                                                    {
//                            amount = 10000000000000000000000;
//                            denom = bht;
//                        }
//                    );
//                    "from_address" = BHN3UUgKNBGrP4TvhFeWseH7ox4pgnbqWnZ;
//                    "to_address" = BHgE934R84XUxETVFoVav46NKs6aakgoq8b;
//                };
//            }
//        );
//        "error_message" = "<null>";
//        fee = "833333333333333333 bht";
//        "gas_used" = 44601;
//        "gas_wanted" = 200000;
//        hash = 72901F2E5E9734CF866F551AD68475B2828924B6BB99CEF213EFEC020063350F;
//        height = 351670;
//        memo = "";
//        success = 1;
//        time = 1586409798;
//    }
//);

#import "XXTransactionCell.h"
#import "XXTransactionModel.h"
@interface XXTransactionCell ()

@property (nonatomic, strong) XXLabel *typeLabel;
@property (nonatomic, strong) XXLabel *timeLabel;
@property (nonatomic, strong) XXLabel *amountLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXLabel *stateLabel;

@end

@implementation XXTransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kViewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)configData:(NSDictionary *)dic {
    self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:[dic[@"time"] longLongValue]];
    NSDictionary *activity = [dic[@"activities"] firstObject];
    XXTransactionModel *model = [[XXTransactionModel alloc] initwithActivity:activity];
    self.typeLabel.text = model.type;
    self.typeLabel.frame = CGRectMake(K375(24), 20, [NSString widthWithText:model.type font:kFontBold(17)], 24);
    self.amountLabel.text = model.amount;
    
    if ([dic[@"success"] intValue]) {
        self.stateLabel.text = LocalizedString(@"Success");
        self.stateLabel.textColor = KRGBA(70, 206, 95, 100);
        self.stateLabel.backgroundColor = KRGBA(212, 245, 220, 100);
        self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"Success") font:kFont10] + 4, 16);
    } else {
        self.stateLabel.text = LocalizedString(@"Failed");
        self.stateLabel.textColor = KRGBA(91, 109, 132, 100);
        self.stateLabel.backgroundColor = KRGBA(235, 239, 246, 100);
        self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"Failed") font:kFont10] + 4, 16);
    }
}

- (XXLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), 20, 0, 24) text:@"" font:kFontBold(17) textColor:kDark100];
    }
    return _typeLabel;
}

- (XXLabel *)stateLabel {
    if (_stateLabel == nil) {
        _stateLabel = [[XXLabel alloc] init];
        _stateLabel.font = kFont(10);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (XXLabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.typeLabel.frame), kScreen_Width - K375(48), 16) font:kFont(13) textColor:kDark50];
    }
    return _timeLabel;
}

- (XXLabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame), 16, kScreen_Width - 16 - CGRectGetMaxX(self.typeLabel.frame), 24) font:kNumberFontBold(17) textColor:kDark100];
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), [[self class] getCellHeight] - 1, kScreen_Width - K375(15), 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 80;
}

@end
