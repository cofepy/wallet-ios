//
//  XXDelegateTransferViewController.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "BaseViewController.h"
#import "XXValidatorPrefixHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXDelegateTransferViewController : BaseViewController
/**委托类型*/
@property (nonatomic, assign) XXDelegateNodeType delegateNodeType;
@end

NS_ASSUME_NONNULL_END