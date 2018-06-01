//
//  GW_GiftShowView.h
//  GW_GiftNumberShowView
//
//  Created by gw on 2018/5/30.
//  Copyright © 2018年 gw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GW_GiftShowModel.h"
#import "GW_GiftManager.h"
NS_ASSUME_NONNULL_BEGIN
@interface GW_GiftNumberView:UIView
@property (assign, nonatomic) NSInteger giftNumber;/**< 初始化数字 */
/**
 改变数字显示
 
 @param numberStr 显示的数字
 */
- (void)changeNumber:(NSInteger )numberStr;


/**
 获取显示的数字
 
 @return 显示的数字
 */
- (NSInteger)getLastNumber;
@end

@interface GW_GiftShowView : UIView
@property (assign, nonatomic) NSInteger timeOut;//
@property (assign, nonatomic) CGFloat GW_RemoveAnimationTime;/**< 移除动画时长 */
@property (assign, nonatomic) CGFloat GW_NumberAnimationTime;/**< 数字改变动画时长 */
@property (strong, nonatomic, nullable) NSDate * creatDate;/**< 视图创建时间，用于替换旧的视图*/
@property (assign, nonatomic) NSInteger index;/**< 用于判断是第几个视图 */
@property (strong, nonatomic, nullable) GW_GiftShowModel *model;/**< 数据源*/
@property (assign, nonatomic) GW_GiftHiddenMode hiddenMode;/**< 消失模式*/
@property (assign, nonatomic) GW_NumberShowMode numMode;
@property (strong, nonatomic, nullable) GW_GiftNumberView *numberView;

@property (nonatomic ,assign) BOOL isAnimation;/**< 是否正处于动画，用于上下视图交换位置时使用 */
@property (nonatomic ,assign) BOOL isLeavingAnimation;/**< 是否正处于动画，用于视图正在向右飞出时不要交换位置 */
@property (nonatomic, assign) BOOL isAppearAnimation;/**< 是否正处于动画，用于出现动画时和交换位置的动画冲突*/
@property (nonatomic ,copy) void(^GW_GiftShowViewTimeOut)(GW_GiftShowView *showView);

/**
 重置定时器和计数
 
 @param number 计数
 */
- (void)resetTimeAndNumberFrom:(NSInteger)number;

/**
 获取用户名
 
 @return 获取用户名
 */
- (NSString *)getUserName;

/**
 礼物数量自增1使用该方法
 
 @param number 从多少开始计数
 */
- (void)addGiftNumberFrom:(NSInteger)number;

/**
 设置任意数字时使用该方法
 
 @param number 任意数字 >9999 则显示9999
 */
- (void)changeGiftNumber:(NSInteger)number;

@end
NS_ASSUME_NONNULL_END
