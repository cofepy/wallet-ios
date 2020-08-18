//
//  XXBDetailHeaderView.h
//  Bhex
//
//  Created by BHEX on 2018/6/13.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBDetailHeaderView : UIView

/** 是否全屏 */
@property (assign, nonatomic) BOOL isScreen;

- (void)show;
- (void)dismiss;
- (void)cleanData;
@end
