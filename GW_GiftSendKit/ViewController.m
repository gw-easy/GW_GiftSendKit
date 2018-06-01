//
//  ViewController.m
//  GW_GiftNumberShowView
//
//  Created by gw on 2018/5/30.
//  Copyright © 2018年 gw. All rights reserved.
//

#import "ViewController.h"
#import "GW_BaseShowView.h"
#import "GW_GiftShowView.h"
#import "GW_GiftShowModel.h"
#import "NSObject+GW_Model.h"
#import "GW_GiftManager.h"
static const float Btn_Tap = 200;
@interface ViewController ()
@property (strong, nonatomic, nullable) GW_BaseShowView *customGiftShow;
@property (strong, nonatomic, nullable) NSArray <GW_GiftNumberModel *>* giftArr;
@property (strong, nonatomic, nullable) NSArray *giftDataSource;
@property (strong, nonatomic, nullable) GW_UserModel *firstUser;
@property (strong, nonatomic, nullable) GW_UserModel *secondUser;
@property (strong, nonatomic, nullable) GW_UserModel *thirdUser;
@property (strong, nonatomic, nullable) GW_UserModel *fourthUser;
@property (strong, nonatomic, nullable) GW_UserModel *fifthUser;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化按钮
    NSArray * titles = @[@"first",@"second",@"third",@"fourth",@"fifth"];
    NSInteger maxCount = titles.count;
    for (NSInteger i = 0; i<maxCount; i++) {
        [self createBtnWithTag:i+Btn_Tap title:titles[i] maxCount:maxCount];
    }
    
    //初始化数据源
    self.giftArr = [GW_GiftNumberModel GW_JsonToModel:self.giftDataSource];
    
    [self.view addSubview:self.customGiftShow];
    //初始化弹幕视图
    [self customGiftShow];
    
}



/*
 以下是测试方法：
 分别是三种添加视图的方法
 animatedWithGiftModel:   从1开始动画展示到 model.toNumber 的效果，会累加；
 addLiveGiftShowModel:   普通的从1显示礼物视图，会+=1；
 addLiveGiftShowModel: showNumber: 普通的礼物显示视图，指定显示特定数字。
 */

- (void)v15BtnClicked:(UIButton *)clickedBtn{
    switch (clickedBtn.tag) {
        case 200:{
            GW_GiftShowModel * model = [[GW_GiftShowModel alloc] init];
            model.giftModel = self.giftArr[0];
            model.userModel = self.firstUser;
            model.appendNum = 5;
            model.interval = 0.15;
            [self.customGiftShow animatedWithGiftModel:model];
            break;
        }
        case 201:{
            GW_GiftShowModel * model = [[GW_GiftShowModel alloc] init];
            model.giftModel = self.giftArr[1];
            model.userModel = self.secondUser;
            model.appendNum = 5;
            model.interval = 0.15;
            [self.customGiftShow addGiftShowModel:model];
            break;
        }
        case 202:{
            GW_GiftShowModel * model = [[GW_GiftShowModel alloc] init];
            model.giftModel = self.giftArr[2];
            model.userModel = self.thirdUser;
            model.appendNum = 5;
            model.interval = 0.15;
            [self.customGiftShow addGiftShowModel:model showNumber:99];
            break;
        }
        case 203:{
            GW_GiftShowModel * model = [[GW_GiftShowModel alloc] init];
            model.giftModel = self.giftArr[3];
            model.userModel = self.fourthUser;
            model.appendNum = 3;
            model.interval = 0.55;
            [self.customGiftShow animatedWithGiftModel:model];
            break;
        }
        case 204:{
            GW_GiftShowModel * model = [[GW_GiftShowModel alloc] init];
            model.giftModel = self.giftArr[4];
            model.userModel = self.fifthUser;
            model.appendNum = 1;
            model.interval = 0.15;
            [self.customGiftShow animatedWithGiftModel:model];
            break;
        }
        default:
            break;
    }
}


/*
 礼物视图支持很多配置属性，开发者按需选择。
 */
- (GW_BaseShowView *)customGiftShow{
    if (!_customGiftShow) {
        _customGiftShow = [[GW_BaseShowView alloc] initWithFrame:CGRectMake(0, 100, 244, 300)];
        _customGiftShow.addMode = GW_GiftAddModeReplace;
        _customGiftShow.showMode = GW_GiftShowModeFromTopToBottom;
        _customGiftShow.numMode = GW_NumberShowModeInside;
        _customGiftShow.appearMode = GW_GiftAppearModeLeft;
        _customGiftShow.hiddenMode = GW_GiftHiddenModeRight;
    }
    return _customGiftShow;
}

- (GW_UserModel *)firstUser {
    if (!_firstUser) {
        _firstUser = [[GW_UserModel alloc]init];
        _firstUser.name = @"first";
        _firstUser.iconUrl = @"http://ww1.sinaimg.cn/large/c6a1cfeagy1ffbg8tb6wqj20gl0qogni.jpg";
    }
    return _firstUser;
}

- (GW_UserModel *)secondUser {
    if (!_secondUser) {
        _secondUser = [[GW_UserModel alloc]init];
        _secondUser.name = @"second";
        _secondUser.iconUrl = @"http://ww1.sinaimg.cn/large/c6a1cfeagy1ffbgd5cr5nj209s0akgly.jpg";
    }
    return _secondUser;
}

- (GW_UserModel *)thirdUser {
    if (!_thirdUser) {
        _thirdUser = [[GW_UserModel alloc]init];
        _thirdUser.name = @"third";
        _thirdUser.iconUrl = @"http://ww1.sinaimg.cn/large/c6a1cfeagy1ffbgeuwk21j205k05kq2w.jpg";
    }
    return _thirdUser;
}

- (GW_UserModel *)fourthUser {
    if (!_fourthUser) {
        _fourthUser = [[GW_UserModel alloc]init];
        _fourthUser.name = @"fourth";
        _fourthUser.iconUrl = @"http://ww1.sinaimg.cn/large/c6a1cfeagy1ffbgfpf5bgj205k07v3yk.jpg";
    }
    return _fourthUser;
}

- (GW_UserModel *)fifthUser {
    if (!_fifthUser) {
        _fifthUser = [[GW_UserModel alloc]init];
        _fifthUser.name = @"fifth";
        _fifthUser.iconUrl = @"http://ww1.sinaimg.cn/large/c6a1cfeagy1ffbgg5427qj205k05k748.jpg";
    }
    return _fifthUser;
}

- (UIButton *)createBtnWithTag:(NSInteger)tag title:(NSString *)title maxCount:(NSInteger)maxCount{
    CGFloat btnWidth = ([UIScreen mainScreen].bounds.size.width - 20)/maxCount;
    
    NSInteger number = tag - Btn_Tap;
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10+number * btnWidth, [UIScreen mainScreen].bounds.size.height-100, btnWidth, 40)];
    btn.backgroundColor = randomColor;
    btn.tag = tag;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(v15BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    return btn;
}

- (NSArray *)giftDataSource{
    if (!_giftDataSource) {
        _giftDataSource = @[
                            @{
                                @"name": @"松果",
                                @"rewardMsg": @"扔出一颗松果",
                                @"personSort": @"0",
                                @"goldCount": @"3",
                                @"type": @"0",
                                @"picUrl": @"http://ww3.sinaimg.cn/large/c6a1cfeagw1fbks9dl7ryj205k05kweo.jpg",
                                },
                            @{
                                @"name": @"花束",
                                @"rewardMsg": @"献上一束花",
                                @"personSort": @"6",
                                @"goldCount": @"66",
                                @"type": @"1",
                                @"picUrl": @"http://ww1.sinaimg.cn/large/c6a1cfeagw1fbksa4vf7uj205k05kaa0.jpg",
                                },
                            @{
                                @"name": @"果汁",
                                @"rewardMsg": @"递上果汁",
                                @"personSort": @"3",
                                @"goldCount": @"18",
                                @"type": @"2",
                                @"picUrl": @"http://ww2.sinaimg.cn/large/c6a1cfeagw1fbksajipb8j205k05kjri.jpg",
                                },
                            @{
                                @"name": @"棒棒糖",
                                @"rewardMsg": @"递上棒棒糖",
                                @"personSort": @"2",
                                @"goldCount": @"8",
                                @"type": @"3",
                                @"picUrl": @"http://ww2.sinaimg.cn/large/c6a1cfeagw1fbksasl9qwj205k05kt8k.jpg",
                                },
                            @{
                                @"name": @"泡泡糖",
                                @"rewardMsg": @"一起吃泡泡糖",
                                @"personSort": @"2",
                                @"goldCount": @"8",
                                @"type": @"4",
                                @"picUrl": @"http://a3.qpic.cn/psb?/V12A6SP10iIW9i/AL.CfLAFH*W.Ge1n*.LwpXSImK.Hm1eCMtt4rm5WvCA!/b/dFOyjUpCBwAA&bo=yADIAAAAAAABACc!&rf=viewer_4"
                                },
                            ];
    }
    return _giftDataSource;
}

@end
