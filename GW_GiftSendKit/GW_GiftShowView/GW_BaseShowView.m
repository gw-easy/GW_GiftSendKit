//
//  GW_BaseShowView.m
//  GW_GiftNumberShowView
//
//  Created by gw on 2018/5/30.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "GW_BaseShowView.h"
#import "GW_GiftShowView.h"



@interface GW_BaseShowView(){
    dispatch_semaphore_t _signal_t;
}
@property (nonatomic ,strong) NSMutableDictionary * showViewDict;/**< key([self getDictKey]):value(LiveGiftShowView*) */
//用来记录模型的顺序
@property (nonatomic ,strong) NSMutableArray *showViewArr;/**< [LiveGiftShowView, @"kGiftViewRemoved"] */
@property (nonatomic, strong) NSMutableArray<GW_GiftShowModel *> * waitQueueArr;// 待展示礼物队列

@end
@implementation GW_BaseShowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.GW_ExchangeAnimationTime = 0.25;
        self.GW_AppearAnimationTime = 0.25;
        self.maxGiftShowCount = 3;
        self.addMode = GW_GiftAddModeAdd;
        self.showMode = GW_GiftShowModeFromTopToBottom;
        self.hiddenMode = GW_GiftHiddenModeRight;
        self.appearMode = GW_GiftAppearModeLeft;
        self.numMode = GW_NumberShowModeInside;
//        self.backgroundColor = [UIColor greenColor];
        _signal_t = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)addGiftShowModel:(GW_GiftShowModel *)showModel{
    [self addGiftShowModel:showModel showNumber:0];
}

- (void)addGiftShowModel:(GW_GiftShowModel *)showModel showNumber:(NSInteger)showNumber{
    if (!showModel || ![showModel isKindOfClass:[GW_GiftShowModel class]]) {
        return;
    }
    
    GW_GiftShowView *oldShow = [self.showViewDict objectForKey:[self getDictKey:showModel]];
    //判断是否强制修改显示的数字
    BOOL isResetNumber = showNumber > 0 ? YES : NO;
    if (!oldShow) {
        if (self.showViewArr.count >= self.maxGiftShowCount && ![self.showViewArr containsObject:GW_GiftViewRemoved]) {
            if (self.addMode == 0) {
                //排序 创建时间最小的在第一个
                NSArray * sortArr = [self.showViewArr sortedArrayUsingComparator:^NSComparisonResult(GW_GiftShowView * obj1, GW_GiftShowView * obj2) {
                    return [obj1.creatDate compare:obj2.creatDate];
                }];
                GW_GiftShowView * oldestView = sortArr.firstObject;
                //重置模型 注意：将时间最早的替换掉
                [self resetView:oldestView nowModel:showModel isChangeNum:isResetNumber number:showNumber];
            }
            return;
        }
        
        //计算视图Y值
        CGFloat   showViewY = 0;
        if (self.showMode == GW_GiftShowModeFromTopToBottom) {
            showViewY = (GW_GiftViewHeight + GW_GiftViewMargin) * [self.showViewDict allKeys].count;
        } else if (self.showMode == GW_GiftShowModeFromBottomToTop) {
            showViewY = - ((GW_GiftViewHeight + GW_GiftViewMargin) * [self.showViewDict allKeys].count);
        }
        
        //获取已移除的key的index
        NSInteger removedViewIndex = [self.showViewArr indexOfObject:GW_GiftViewRemoved];
        if ([self.showViewArr containsObject:GW_GiftViewRemoved]) {
            if (self.showMode == GW_GiftShowModeFromTopToBottom) {
                showViewY = removedViewIndex * (GW_GiftViewHeight + GW_GiftViewMargin);
            } else if (self.showMode == GW_GiftShowModeFromBottomToTop) {
                showViewY = - (removedViewIndex * (GW_GiftViewHeight + GW_GiftViewMargin));
            }
        }
        
        //创建新模型
        CGRect frame = CGRectMake(0, showViewY, GW_GiftViewWidth, GW_GiftViewHeight);
        if (self.appearMode == GW_GiftAppearModeLeft) {
            frame.origin.x = -[UIScreen mainScreen].bounds.size.width;
        }
        GW_GiftShowView * newShowView = [[GW_GiftShowView alloc] initWithFrame:frame];
        //赋值
        newShowView.model = showModel;
        newShowView.hiddenMode = self.hiddenMode;
        newShowView.numMode = self.numMode;
        //改变礼物数量
        if (isResetNumber) {
            [newShowView resetTimeAndNumberFrom:showNumber];
        }else{
            [newShowView addGiftNumberFrom:1];
        }
        [self appearWith:newShowView];
        
        //超时移除
        __weak __typeof(self)weakSelf = self;
        newShowView.GW_GiftShowViewTimeOut = ^(GW_GiftShowView * willReMoveShowView){
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(giftDidRemove:)]) {
//                [weakSelf.delegate giftDidRemove:willReMoveShowView.model];
//            }
            //从数组移除 将移除的view替换成GW_GiftViewRemoved，做上标记
            [weakSelf.showViewArr replaceObjectAtIndex:willReMoveShowView.index withObject:GW_GiftViewRemoved];
            //从字典移除
            NSString * willReMoveShowViewKey = [weakSelf getDictKey:willReMoveShowView.model];
            [weakSelf.showViewDict removeObjectForKey:willReMoveShowViewKey];
            
//            NSLog(@"移除了第%zi个,移除后数组 = %@ ,词典 = %@",willReMoveShowView.index,weakSelf.showViewArr,weakSelf.showViewDict);
            
            //比较数量大小排序
            [weakSelf sortShowArr];
//            从新排序设置各个view的y值
            [weakSelf resetY];
            if (weakSelf.addMode == GW_GiftAddModeAdd) {
//                将等待展示的view，展示出来
                [weakSelf showWaitView];
            } else if (weakSelf.addMode == GW_GiftAddModeReplace) {
//                关闭定时器
                if (willReMoveShowView.model.animatedTimer) {
                    dispatch_cancel(willReMoveShowView.model.animatedTimer);
                }
            }
        };
        
        [self addSubview:newShowView];
        
        //加入数组
//        如果包含需要移除的index，就替换
        if ([self.showViewArr containsObject:GW_GiftViewRemoved]) {
            newShowView.index = removedViewIndex;
            [self.showViewArr replaceObjectAtIndex:removedViewIndex withObject:newShowView];
        }else{
            newShowView.index = self.showViewArr.count;
            [self.showViewArr addObject:newShowView];
        }
        //加入字典
        [self.showViewDict setObject:newShowView forKey:[self getDictKey:showModel]];
    }else{
//        已存在的模型
        //修改数量大小
        if (isResetNumber) {
            [oldShow resetTimeAndNumberFrom:showNumber];
        }else{
            [oldShow addGiftNumberFrom:1];
        }
        //比较数量大小排序
        [self sortShowArr];
        //排序后调整Y值
        [self resetY];
    }
}

- (void)animatedWithGiftModel:(GW_GiftShowModel *)showModel{
    if (!showModel){
        return;
    }
    if (self.addMode == GW_GiftAddModeAdd) {
        GW_GiftShowView *oldShowView = [self.showViewDict objectForKey:[self getDictKey:showModel]];
        if (!oldShowView) {// 不存在旧视图
            NSUInteger showCount = 0;
            for (id object in self.showViewArr) {
                if ([object isKindOfClass:[GW_GiftShowView class]]) {
                    showCount ++;
                }
            }
            if (showCount >= self.maxGiftShowCount) {//弹幕数量大于最大数量
                [self addToWaitQueueArr:showModel];
                return;
            }
        }
    }
    
//    定时器礼物增加
    dispatch_source_t tt = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(tt, dispatch_walltime(NULL, 0), showModel.interval*NSEC_PER_SEC, 0);
    __block NSInteger i = 0;
    __weak __typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(tt, ^{
        if (i < showModel.appendNum) {
            i ++;
            showModel.animatedTimer = tt;
            [weakSelf addGiftShowModel:showModel];
        } else {
            dispatch_cancel(tt);
        }
    });
    dispatch_resume(tt);
}

- (void)addToWaitQueueArr:(GW_GiftShowModel *)showModel {
    if (!showModel) {
        return;
    }
    NSString * key = [self getDictKey:showModel];
    NSUInteger oldNumber = 0;
    for (NSUInteger i = 0; i<self.waitQueueArr.count; i++) {
        GW_GiftShowModel *oldModel = self.waitQueueArr[i];
        NSString * oldKey = [self getDictKey:oldModel];
//        如果有相同的，就先移除，再添加
        if ([oldKey isEqualToString:key]) {
            oldNumber = oldModel.appendNum;
            showModel.appendNum += oldNumber;
            [self.waitQueueArr removeObject:oldModel];
            break;
        }
    }
    [self.waitQueueArr addObject:showModel];
}

- (void)showWaitView {
    NSUInteger showCount = 0;
    for (id object in self.showViewArr) {
        if ([object isKindOfClass:[GW_GiftShowView class]]) {
            showCount ++;
        }
    }
    if (showCount < self.maxGiftShowCount) {
        GW_GiftShowModel *model = self.waitQueueArr.firstObject;
        [self animatedWithGiftModel:model];
        [self.waitQueueArr removeObject:model];
    }
}

- (void)resetY {
    for (int i = 0; i < self.showViewArr.count; i++) {
        GW_GiftShowView * show = self.showViewArr[i];
        if ([show isKindOfClass:[GW_GiftShowView class]]) {
            CGFloat showY = i * (GW_GiftViewHeight + GW_GiftViewMargin);
            if (self.showMode == GW_GiftShowModeFromBottomToTop) {
                showY = -showY;
            }
            if (show.frame.origin.y != showY) {
                if (!show.isLeavingAnimation) {
                    // 避免出现动画和交换动画冲突
                    if (show.isAppearAnimation) {
                        [show.layer removeAllAnimations];
                    }
                    [UIView animateWithDuration:self.GW_ExchangeAnimationTime animations:^{
                        CGRect showF = show.frame;
                        showF.origin.y = showY;
                        show.frame = showF;
                    } completion:^(BOOL finished) {
                        
                    }];
                    show.isAnimation = YES;
                    NSLog(@"%@ 重置动画",show);
                }
            }
        }
    }
}


- (void)sortShowArr{
    dispatch_semaphore_wait(_signal_t, DISPATCH_TIME_FOREVER);
    //如果当前数组包含kGiftViewRemoved 则将kGiftViewRemoved替换到LiveGiftShowView之后
    for (int i = 0; i < self.showViewArr.count; i++) {
        id current = self.showViewArr[i];
        if ([current isKindOfClass:[NSString class]]){
            if (i+1 < self.showViewArr.count) {
                [self searchLiveShowViewFrom:i+1];
            }
        }
    }
    //以当前 数字大小 比较，降序
    for (int i = 0; i < self.showViewArr.count; i++) {
        for (int j = i; j < self.showViewArr.count; j++) {
            GW_GiftShowView * showViewI = self.showViewArr[i];
            GW_GiftShowView * showViewJ = self.showViewArr[j];
            if ([showViewI isKindOfClass:[GW_GiftShowView class]] && [showViewJ isKindOfClass:[GW_GiftShowView class]]) {
                if ([showViewI.numberView getLastNumber] < [showViewJ.numberView getLastNumber]) {
                    showViewI.index = j;
                    showViewI.isAnimation = YES;
                    showViewJ.index = i;
                    showViewJ.isAnimation = YES;
                    [self.showViewArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    dispatch_semaphore_signal(_signal_t);
//    NSLog(@"排序后数组==>>> %@",self.showViewArr);
}

- (void)searchLiveShowViewFrom:(int)i{
    for (int j = i; j < self.showViewArr.count; j++) {
        GW_GiftShowView * next = self.showViewArr[j];
        if ([next isKindOfClass:[GW_GiftShowView class]]) {
            if (next.frame.origin.x == [UIScreen mainScreen].bounds.size.width) {
                continue;
            }
            next.index = i-1;
            [self.showViewArr exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
            return;
        }
    }
}

- (void)appearWith:(GW_GiftShowView *)showView {
    // 出现的动画
    if (self.appearMode == GW_GiftAppearModeLeft) {
        showView.isAppearAnimation = YES;
        [UIView animateWithDuration:self.GW_AppearAnimationTime animations:^{
            CGRect f = showView.frame;
            f.origin.x = 0;
            showView.frame = f;
        } completion:^(BOOL finished) {
            if (finished) {
                showView.isAppearAnimation = NO;
            }
        }];
    }
}

- (void)resetView:(GW_GiftShowView *)view nowModel:(GW_GiftShowModel *)model isChangeNum:(BOOL)isChange number:(NSInteger)number{
    NSString * oldKey = [self getDictKey:view.model];
    NSString * dictKey = [self getDictKey:model];
    //找到时间早的那个视图 替换模型 重置数字
    view.model = model;
    if (isChange) {
        [view resetTimeAndNumberFrom:number];
    }else{
        [view resetTimeAndNumberFrom:1];
    }
    [self.showViewDict removeObjectForKey:oldKey];
    [self.showViewDict setObject:view forKey:dictKey];
}

- (NSString *)getDictKey:(GW_GiftShowModel *)model{
    //默认以 用户名+礼物类型 为key
    NSString * key = [NSString stringWithFormat:@"%@%@",model.userModel.name,model.giftModel.type];
    return key;
}

- (NSMutableArray<GW_GiftShowModel *> *)waitQueueArr {
    if (!_waitQueueArr) {
        _waitQueueArr = [[NSMutableArray alloc]init];
    }
    return _waitQueueArr;
}

- (NSMutableDictionary *)showViewDict{
    if (!_showViewDict) {
        _showViewDict = [[NSMutableDictionary alloc]init];
    }
    return _showViewDict;
}

-(NSMutableArray *)showViewArr{
    if (!_showViewArr) {
        _showViewArr = [[NSMutableArray alloc]init];
    }
    return _showViewArr;
}

@end
