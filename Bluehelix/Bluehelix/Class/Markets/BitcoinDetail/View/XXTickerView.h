//
//  XXTickerView.h
//  Bhex
//
//  Created by BHEX on 2018/6/28.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXTickerView : UIView

/** 左标签 */
@property (strong, nonatomic) XXLabel *leftLabel;

/** 右标签 */
@property (strong, nonatomic) XXLabel *rightLabel;


- (void)show;
- (void)dismiss;
- (void)cleanData;
@end
