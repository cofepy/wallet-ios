//
//  XXWithdrawAmountReceivedView.h
//  Bhex
//
//  Created by Bhex on 2019/12/18.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXFloadtTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXWithdrawAmountReceivedView : UIView

/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 背景图 */
@property (strong, nonatomic) UIView *banView;

/** 单位标签 */
@property (strong, nonatomic) XXLabel *unitLabel;

/** 输入框 */
@property (strong, nonatomic) XXFloadtTextField *textField;

/** 输入框输入回调 */
@property (strong, nonatomic) void(^textFieldBoock)(void);
@end

NS_ASSUME_NONNULL_END
