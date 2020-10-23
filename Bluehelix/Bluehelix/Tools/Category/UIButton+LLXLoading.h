//
//  UIButton+LLXLoading.h
//  LLXButtonLoading
//
//  Created by 李林轩 on 2018/3/1.
//  Copyright © 2018年 李林轩. All rights reserved.
//
/**
 **/

#import <UIKit/UIKit.h>
typedef void (^LLX_ActionBlock)(UIButton * _Nullable button);

@interface UIButton (LLXLoading)

/**
 *  绑定button
 **/
-(void)BindingBtnactionBlock:(LLX_ActionBlock)actionBlock;

/**
 *  加载完毕停止旋转
 *  title:停止后button的文字
 *  textColor :字体色 如果颜色不变就为nil
 *  backgroundColor :背景色 如果颜色不变就为nil
 **/

-(void)stopLoading:(NSString*_Nullable)title textColor:(UIColor*_Nullable)textColor backgroundColor:(UIColor*_Nullable)backColor;

-(void)stopLoadingWithImage:(UIImage *)image;
/**
 *  设置加载圆圈的宽度 默认是5
 **/
@property(nonatomic,assign)NSInteger lineWidths;


/**
 *  设置加载圆圈距离上下边距的宽度 默认是5
 **/
@property(nonatomic,assign)NSInteger topHeight;

/*
 
 注意 ：  加载的圆圈颜色渐变值默认是button的背景色和字体色；
        如果设置以下圆圈颜色渐变值 颜色就不会随着字体和背景颜色变化了
 
 */

/**
 *  设置开始加载时候的圆圈颜色渐变值 1
 **/
@property(nonatomic,strong)UIColor * _Nullable startColorOne;
/**
 *  设置开始加载时候的圆圈颜色渐变值 2
 **/
@property(nonatomic,strong)UIColor * _Nullable startColorTwo;



















@end
