//
//  XXValidatorDetailViewController.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "BaseViewController.h"
#import "XXValidatorListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XXValidatorDetailViewController : BaseViewController
@property (nonatomic, strong) XXValidatorListModel *validatorModel;
/**有效或者无效*/
@property (nonatomic, copy) NSString *validOrInvalid;
@end

NS_ASSUME_NONNULL_END
