//
//  GW_GiftShowModel.h
//  GW_GiftNumberShowView
//
//  Created by gw on 2018/5/30.
//  Copyright © 2018年 gw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GW_UserModel:NSObject
@property (copy, nonatomic, nullable) NSString *name;
@property (copy, nonatomic, nullable) NSString *iconUrl;
@end

@interface GW_GiftNumberModel:NSObject
//礼物名称
@property (copy, nonatomic, nullable) NSString *name;
//人物分类
@property (copy, nonatomic, nullable) NSString *personSort;
//金币
@property (copy, nonatomic, nullable) NSString *goldCount;
//高亮图片
@property (copy, nonatomic, nullable) NSString *highlightImage;
//礼物类型
@property (copy, nonatomic, nullable) NSString *type;
//礼物图片url
@property (copy, nonatomic, nullable) NSString *picUrl;
//礼物配置语句
@property (copy, nonatomic, nullable) NSString *rewardMsg;
@end

@interface GW_GiftShowModel : NSObject
//用户model
@property (strong, nonatomic, nullable) GW_UserModel *userModel;
//礼物model
@property (strong, nonatomic, nullable) GW_GiftNumberModel *giftModel;
//当前数量
@property (assign, nonatomic) NSInteger currentNum;
//点击每次增加数量 默认是1
@property (assign, nonatomic) NSInteger appendNum;
//礼物动画时间间隔
@property (assign, nonatomic) float interval;
//礼物定时器
@property (strong, nonatomic, nullable) dispatch_source_t animatedTimer;

@end
