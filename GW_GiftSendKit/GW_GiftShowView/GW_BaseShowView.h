//
//  GW_BaseShowView.h
//  GW_GiftNumberShowView
//
//  Created by gw on 2018/5/30.
//  Copyright © 2018年 gw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GW_GiftShowModel.h"
#import "GW_GiftManager.h"
@interface GW_BaseShowView : UIView
@property (assign, nonatomic) CGFloat GW_ExchangeAnimationTime;//交换动画时长
@property (assign, nonatomic) CGFloat GW_AppearAnimationTime;//出现时动画时长

//最大展示数量 默认3
@property (assign, nonatomic) NSInteger maxGiftShowCount;
//展示模式
@property (assign, nonatomic) GW_GiftShowMode showMode;
//添加模式 默认添加
@property (assign, nonatomic) GW_GiftAddMode addMode;
//弹出模式
@property (assign, nonatomic) GW_GiftAppearMode appearMode;
//消失模式
@property (assign, nonatomic) GW_GiftHiddenMode hiddenMode;
//数字展示
@property (assign, nonatomic) GW_NumberShowMode numMode;
/**
 增加或者更新一个礼物视图
 
 @param showModel 礼物模型
 */
- (void)addGiftShowModel:(GW_GiftShowModel *)showModel;
/**
 增加或者更新一个礼物视图
 
 @param showModel 礼物模型
 @param showNumber 如果传值，则显示改值，否则从1开始自增1
 */
- (void)addGiftShowModel:(GW_GiftShowModel *)showModel showNumber:(NSInteger)showNumber;

/**
 添加一个礼物视图，若该礼物不在视图上则从数字1显示到指定数字的效果，否则继续增加指定数字
 
 @param showModel 礼物模型
 */
- (void)animatedWithGiftModel:(GW_GiftShowModel *)showModel;
@end
