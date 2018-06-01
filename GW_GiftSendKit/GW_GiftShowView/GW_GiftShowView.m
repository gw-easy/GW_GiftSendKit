//
//  GW_GiftShowView.m
//  GW_GiftNumberShowView
//
//  Created by gw on 2018/5/30.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "GW_GiftShowView.h"
#import "UIImageView+WebCache.h"
static const float rightMargicNum = 2;
@interface GW_GiftNumberView()
@property (strong, nonatomic, nullable) UIImageView * ge_numView;
@property (strong, nonatomic, nullable) UIImageView * shi_numView;
@property (strong, nonatomic, nullable) UIImageView * bai_numView;
@property (strong, nonatomic, nullable) UIImageView * qian_numView;
@property (strong, nonatomic, nullable) UIImageView * x_Icon;
@property (assign, nonatomic) NSInteger lastNumber;/**< 最后显示的数字 */
@property (assign, nonatomic) NSInteger length;
@property (assign, nonatomic) CGFloat vWidth;
@property (assign, nonatomic) GW_NumberShowMode numMode;
@end
@implementation GW_GiftNumberView

@synthesize giftNumber = _giftNumber;
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.qian_numView];
        [self addSubview:self.bai_numView];
        [self addSubview:self.shi_numView];
        [self addSubview:self.ge_numView];
        [self addSubview:self.x_Icon];
        self.vWidth = frame.size.width;
    }
    return self;
}

- (void)setGiftNumber:(NSInteger)giftNumber{
    _giftNumber = giftNumber;
    self.lastNumber = giftNumber;
}

- (NSInteger)giftNumber{
    _giftNumber = self.lastNumber ;
    self.lastNumber += 1;
    return _giftNumber;
}

- (NSInteger)getLastNumber{
    return _lastNumber - 1;
}

- (void)changeNumber:(NSInteger)numberStr{
    if (numberStr <= 0) {
        return;
    }
    
    NSInteger num = numberStr;
    NSInteger qian = num / 1000;
    NSInteger qianYu = num % 1000;
    NSInteger bai = qianYu / 100;
    NSInteger baiYu = qianYu % 100;
    NSInteger shi = baiYu / 10;
    NSInteger shiYu = baiYu % 10;
    NSInteger ge = shiYu;
    
    if (numberStr > 9999) {
        qian = 9;
        bai = 9;
        shi = 9;
        ge = 9;
    }

    self.length = 1;
    
    self.ge_numView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"w_%zi",ge] ofType:@"png"]];

    if (self.numMode == 1) {
        self.x_Icon.left = GW_GiftNumberWidth+5;
    }
    
    if (qian > 0) {
        self.length = 4;
        self.qian_numView.hidden = NO;
        self.bai_numView.hidden = NO;
        self.shi_numView.hidden = NO;
        
        self.qian_numView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"w_%zi",qian] ofType:@"png"]];
        self.bai_numView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"w_%zi",bai] ofType:@"png"]];
        self.shi_numView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"w_%zi",shi] ofType:@"png"]];
        
        if (self.numMode == 1) {
            self.qian_numView.left = self.x_Icon.right;
            self.bai_numView.left = self.qian_numView.right;
            self.shi_numView.left = self.bai_numView.right;
            self.ge_numView.left = self.shi_numView.right;
            return;
        }
    }else if (bai > 0){
        self.length = 3;
        self.qian_numView.hidden = YES;
        self.bai_numView.hidden = NO;
        self.shi_numView.hidden = NO;
        
        self.bai_numView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"w_%zi",bai] ofType:@"png"]];
        self.shi_numView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"w_%zi",shi] ofType:@"png"]];
        if (self.numMode == 1) {
            self.bai_numView.left = self.x_Icon.right;
            self.shi_numView.left = self.bai_numView.right;
            self.ge_numView.left = self.shi_numView.right;
            return;
        }
    }else if (shi > 0){
        self.length = 2;
        self.qian_numView.hidden = YES;
        self.bai_numView.hidden = YES;
        self.shi_numView.hidden = NO;
        
        self.shi_numView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"w_%zi",shi] ofType:@"png"]];
        if (self.numMode == 1) {
            self.shi_numView.left = self.x_Icon.right;
            self.ge_numView.left = self.shi_numView.right;
            return;
        }
    }else {
        self.length = 1;
        self.qian_numView.hidden = YES;
        self.bai_numView.hidden = YES;
        self.shi_numView.hidden = YES;
        if (self.numMode == 1) {
            self.ge_numView.left = self.x_Icon.right;
            return;
        }
    }
    //在动画中导致width，位置不准确，所以在initWithFrame，将宽保存下来
    self.x_Icon.left = self.vWidth - GW_GiftNumberWidth*(self.length + rightMargicNum);
//    NSLog(@"self.x_Icon.left ========= %ld",(long)self.x_Icon.left);

}


- (UIImageView *)ge_numView{
    if (!_ge_numView) {
        _ge_numView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-GW_GiftNumberWidth*rightMargicNum, 0, GW_GiftNumberWidth, GW_GiftNumberHeight)];
        _ge_numView.centerY = self.height/2;
    }
    return _ge_numView;
}
- (UIImageView *)shi_numView{
    if (!_shi_numView) {
        _shi_numView = [[UIImageView alloc] initWithFrame:CGRectMake(self.ge_numView.left-GW_GiftNumberWidth, 0, self.ge_numView.width, self.ge_numView.height)];
        _shi_numView.centerY = self.ge_numView.centerY;
        _shi_numView.hidden = YES;
    }
    return _shi_numView;
}
- (UIImageView *)bai_numView{
    if (!_bai_numView) {
        _bai_numView = [[UIImageView alloc] initWithFrame:CGRectMake(self.shi_numView.left-GW_GiftNumberWidth, 0, self.ge_numView.width, self.ge_numView.height)];
        _bai_numView.centerY = self.ge_numView.centerY;
        _bai_numView.hidden = YES;
    }
    return _bai_numView;
}
- (UIImageView *)qian_numView{
    if (!_qian_numView) {
        _qian_numView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bai_numView.left-GW_GiftNumberWidth, 0, self.ge_numView.width, self.ge_numView.height)];
        _qian_numView.centerY = self.ge_numView.centerY;
        _qian_numView.hidden = YES;

    }
    return _qian_numView;
}
- (UIImageView *)x_Icon{
    if (!_x_Icon) {
        _x_Icon = [[UIImageView alloc] initWithFrame:self.shi_numView.frame];
        _x_Icon.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"w_x" ofType:@"png"]];
//        _x_Icon.backgroundColor = [UIColor greenColor];
        _x_Icon.centerY = self.ge_numView.centerY+2;
    }
    return _x_Icon;
}
@end
@interface GW_GiftShowView()
@property (strong, nonatomic, nullable) UIImageView *backIV;/**< 背景图 */
@property (strong, nonatomic, nullable) UIImageView *iconIV;/**< 头像 */
@property (strong, nonatomic, nullable) UILabel *nameLabel;/**< 名称 */
@property (strong, nonatomic, nullable) UILabel *sendLabel;/**< 送出 */
@property (strong, nonatomic, nullable) UIImageView *giftIV;/**< 礼物图片 */
@property (strong, nonatomic, nullable) NSTimer *liveTimer;/**< 定时器控制自身移除 */
@property (assign, nonatomic) NSInteger liveTimerForSecond;
@property (assign, nonatomic) BOOL isSetNumber;

@end
@implementation GW_GiftShowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.liveTimerForSecond = 0;
        [self setupContentContraints];
        self.creatDate = [NSDate date];
        self.timeOut = 3;
        self.GW_RemoveAnimationTime = 0.5;
        self.GW_NumberAnimationTime = 0.25;
    }
    return self;
}

- (void)setModel:(GW_GiftShowModel *)model{
    if (!model) {
        return;
    }
    _model = model;
    
    self.nameLabel.text = model.userModel.name;
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.userModel.iconUrl] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LiveDefaultIcon" ofType:@"png"]]];
    
    self.sendLabel.text = model.giftModel.rewardMsg;
    [self.giftIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.giftModel.picUrl]] placeholderImage:nil];
    
}

- (void)setNumMode:(GW_NumberShowMode)numMode{
    _numMode = numMode;
    self.numberView.numMode = numMode;
    if (numMode == 1) {
        self.backIV.width = self.giftIV.right + GW_GiftNumberWidth;
    }
}

//UI布局
- (void)setupContentContraints{
    [self addSubview:self.backIV];
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLabel];
    [self addSubview:self.sendLabel];
    [self addSubview:self.giftIV];
    [self addSubview:self.numberView];
}

- (void)resetTimeAndNumberFrom:(NSInteger)number{
    self.numberView.giftNumber = number;
    [self addGiftNumberFrom:number];
}

- (void)addGiftNumberFrom:(NSInteger)number{
    if (!self.isSetNumber) {
        self.numberView.giftNumber = number;
        self.isSetNumber = YES;
    }
    //每调用一次self.numberView.giftNumber get方法 自增1
    NSInteger giftNum = self.numberView.giftNumber;
//    改变发送数量
    [self.numberView changeNumber:giftNum];
//    开启定时和动画
    [self handleNumber:giftNum];
//    当前数量
    self.model.currentNum = giftNum;
//    创建时间
    self.creatDate = [NSDate date];
}

- (NSString *)getUserName{
    return self.nameLabel.text;
}

- (void)changeGiftNumber:(NSInteger)number{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.numberView changeNumber:number];
        [self handleNumber:number];
    });
}

/**
 处理显示数字 开启定时器
 
 @param number 显示数字的值
 */
- (void)handleNumber:(NSInteger )number{
//    定时器计数归0
    self.liveTimerForSecond = 0;
//    如果有动画就移除
    if (!CGAffineTransformIsIdentity(self.numberView.transform)) {
        [self.numberView.layer removeAllAnimations];
    }
//    添加动画
    self.numberView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:self.GW_NumberAnimationTime animations:^{
        self.numberView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        if (finished) {
            self.numberView.transform = CGAffineTransformIdentity;
        }
    }];
    
//    继续
    [self.liveTimer setFireDate:[NSDate date]];
}

- (void)liveTimerRunning{
    self.liveTimerForSecond += 1;
    if (self.liveTimerForSecond > self.timeOut) {
        if (self.isAnimation == YES) {
            self.isAnimation = NO;
            return;
        }
        self.isAnimation = YES;
        self.isLeavingAnimation = YES;
        CGFloat xChanged = [UIScreen mainScreen].bounds.size.width;
        
        if (self.hiddenMode == GW_GiftHiddenModeLeft) {
            xChanged = -xChanged;
        }
        
        if (self.hiddenMode == GW_GiftHiddenModeNone) {
            self.isLeavingAnimation = NO;
            if (self.GW_GiftShowViewTimeOut) {
                self.GW_GiftShowViewTimeOut(self);
            }
            [self removeFromSuperview];
        } else {
            [UIView animateWithDuration:self.GW_RemoveAnimationTime delay:self.GW_NumberAnimationTime options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.transform = CGAffineTransformTranslate(self.transform, xChanged, 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isLeavingAnimation = NO;
                    if (self.GW_GiftShowViewTimeOut) {
                        self.GW_GiftShowViewTimeOut(self);
                    }
                    [self removeFromSuperview];
                }
            }];
        }
        
        [self stopTimer];
    }
    
}

- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc] initWithFrame:self.bounds];
        _backIV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"w_liveGiftBack" ofType:@"png"]];
    }
    return _backIV;
}

- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, 30, 30)];
        _iconIV.backgroundColor = [UIColor lightGrayColor];
        _iconIV.centerY = self.height/2;
        _iconIV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LiveDefaultIcon" ofType:@"png"]];
        _iconIV.layer.cornerRadius = 15;
        _iconIV.layer.masksToBounds = YES;
    }
    return _iconIV;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconIV.right+6, 9, 70, 14)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:GW_NameLabelFont];
    }
    return _nameLabel;
}

- (UILabel *)sendLabel{
    if (!_sendLabel) {
        _sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.height-9-14, self.nameLabel.width, self.nameLabel.height)];
        _sendLabel.font = [UIFont systemFontOfSize:GW_GiftLabelFont];
        _sendLabel.textColor = [UIColor orangeColor];
    }
    return _sendLabel;
}


- (UIImageView *)giftIV{
    if (!_giftIV) {
        _giftIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.nameLabel.right, 0, GW_GiftIconWidth, GW_GiftIconHeight)];
        _giftIV.backgroundColor = randomColor;
        _giftIV.centerY = self.height/2;
    }
    return _giftIV;
}

- (GW_GiftNumberView *)numberView{
    if (!_numberView) {
        _numberView = [[GW_GiftNumberView alloc]initWithFrame:CGRectMake(self.giftIV.right, 0, self.width-self.giftIV.right, self.height)];
//        _numberView.backgroundColor  =[UIColor redColor];
    }
    return _numberView;
}

- (NSTimer *)liveTimer{
    if (!_liveTimer) {
        _liveTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(liveTimerRunning) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_liveTimer forMode:NSRunLoopCommonModes];
    }
    return _liveTimer;
}

- (void)stopTimer{
    if (_liveTimer) {
        [_liveTimer invalidate];
        _liveTimer = nil;
    }
}

- (void)dealloc{
    [self stopTimer];
}

@end
