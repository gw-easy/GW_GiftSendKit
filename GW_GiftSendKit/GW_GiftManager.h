//
//  GW_GiftManager.h
//  GW_GiftNumberShowView
//
//  Created by gw on 2018/5/30.
//  Copyright © 2018年 gw. All rights reserved.
//

#ifndef GW_GiftManager_h
#define GW_GiftManager_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+GW.h"

#define randomColor [UIColor colorWithHue:( arc4random() % 256 / 256.0 ) saturation:( arc4random() % 128 / 256.0 ) + 0.5 brightness:( arc4random() % 128 / 256.0 ) + 0.5 alpha:1]

static CGFloat const GW_NameLabelFont = 12.0;//送礼者
static CGFloat const GW_GiftLabelFont = 10.0;//送出礼物寄语  字体大小
static CGFloat const GW_GiftNumberWidth = 10.0;//礼物数字的宽
static CGFloat const GW_GiftNumberHeight = 15.0;//礼物数字的高
static CGFloat const GW_GiftViewWidth = 200.0;//背景图片宽
static CGFloat const GW_GiftViewHeight = 44.0;//背景图片高
static CGFloat const GW_GiftViewMargin = 30.0;/**< 两个弹幕之间的高度差 */
static CGFloat const GW_GiftIconWidth = 24;//礼物图片宽
static CGFloat const GW_GiftIconHeight = 24;//礼物图片高
static NSString * const GW_GiftViewRemoved = @"GW_GiftViewRemoved";/**< 弹幕已移除的key */
/**
 弹幕展现模式
 
 - fromTopToBottom: 自上而下
 - fromBottomToTop: 自下而上
 */
typedef NS_ENUM(NSUInteger, GW_GiftShowMode) {
    GW_GiftShowModeFromTopToBottom = 0,
    GW_GiftShowModeFromBottomToTop = 1,
};

/**
 弹幕消失模式
 
 - right: 向右移出
 - left: 向左移出
 */
typedef NS_ENUM(NSUInteger, GW_GiftHiddenMode) {
    GW_GiftHiddenModeRight = 0,
    GW_GiftHiddenModeLeft = 1,
    GW_GiftHiddenModeNone = 2,
};

/**
 弹幕出现模式
 
 - none: 无效果
 - left: 从左到右出现（左进）
 */
typedef NS_ENUM(NSUInteger, GW_GiftAppearMode) {
    GW_GiftAppearModeNone = 0,
    GW_GiftAppearModeLeft = 1,
};


/**
 弹幕添加模式（当弹幕达到最大数量后新增弹幕时）,默认替换
 
 - GW_GiftAddModeReplace: 当有新弹幕时会替换
 - GW_GiftAddModeAdd: 当有新弹幕时会进入队列
 */
typedef NS_ENUM(NSUInteger, GW_GiftAddMode) {
    GW_GiftAddModeReplace = 0,
    GW_GiftAddModeAdd     = 1,
};

/**
 数字在背景阴影框里面还是外面
 
 - GW_NumberShowModeInside: 里面 默认
 - GW_NumberShowModeOutside: 外面
 */
typedef NS_ENUM(NSUInteger, GW_NumberShowMode){
    GW_NumberShowModeInside = 0,
    GW_NumberShowModeOutside = 1,
};




#endif /* GW_GiftManager_h */
