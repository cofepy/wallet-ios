//
//  XXSystem.h
//  Bhex
//
//  Created by Bhex on 2019/10/21.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXSystem : NSObject

/** 程序是否处于激活状态 */
@property (assign, nonatomic) BOOL isActive;

/** 1. 是否夜色模式 */
@property (assign, nonatomic) BOOL isDarkStyle;

+ (XXSystem *)sharedSystemData;

/** 2. 状态栏设置为白色 */
- (void)statusBarSetUpWhiteColor;

/** 3. 状态栏设置为黑色 */
- (void)statusBarSetUpDarkColor;

/** 4. 状态栏设置为默认色 */
- (void)statusBarSetUpDefault;

@end

NS_ASSUME_NONNULL_END
