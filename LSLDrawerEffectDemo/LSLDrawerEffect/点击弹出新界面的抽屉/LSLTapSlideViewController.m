//
//  LSLTapSlideViewController.m
//  多功能抽屉窗口
//
//  Created by lisilong on 15/10/2.
//  Copyright (c) 2015年 李思龙. All rights reserved.
//

/**  功能介绍: 给某个控件绑定事件，并弹出多功能窗口（抽屉效果）。
 *   使用说明: 1.根据懒加载中的方法，创建多功能窗口；
 *            2.创建一个UINavigationController控制器来管理界面；
 *            3.创建UINavigationController的根控制器（数据源控制器）。
 */

#import "LSLTapSlideViewController.h"

// 动画时间
static CGFloat const AnimationTime = 0.5;
// 左边默认的间距（默认为50）
static CGFloat LeftOffSetX = 50;
// 控制器停靠时的背景颜色的透明度
static CGFloat const navVCViewAlpha = 0.8;
// 窗口背景颜色（灰色）
static CGFloat const bgGrayColor = 150;

// 屏幕的size
#define ScreenSize [UIScreen mainScreen].bounds.size
#define BgAlphaColor(a) [UIColor colorWithRed:bgGrayColor/255.0 green:bgGrayColor/255.0 blue:bgGrayColor/255.0 alpha:(a)/255.0]
#define  BgGrayColor BgAlphaColor(150)

@interface LSLTapSlideViewController ()
/** 导航控制器的根控制器 */
@property(nonatomic,weak)UITableViewController *navRootVC;
/** 导航条控制器 */
@property(nonatomic,strong)UINavigationController *navVC;
/** 导航控制器的宽度 */
@property(nonatomic, assign) CGFloat leftOffSetX;
@end

@implementation LSLTapSlideViewController
#pragma mark - 快速创建的方法
- (instancetype)initTapSlideWithNavigationController:(UINavigationController *)navViewController withNavWidth:(CGFloat)navWidth
{
    if (self = [super init]) {
        // 初始化
        [self setupTapSlideVCWithNavigationController:(UINavigationController *)navViewController WithNavWidth:navWidth];
        
        // 不挡住状态栏
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y = 20;
        frame.size.height -= frame.origin.y;
        self.frame = frame;
        
        // 设置窗口的弹出级别
        self.windowLevel = UIWindowLevelAlert;
        
        self.hidden = NO;
        self.leftOffSetX = [UIScreen mainScreen].bounds.size.width - navWidth;
        
    }
    return self;
}

/** 创建固定偏移量为50的多功能窗口 */
+ (instancetype)tapSlideWithNavigationController:(UINavigationController *)navViewController
{
    return [self tapSlideWithNavigationController:navViewController withNavWidth:ScreenSize.width - LeftOffSetX];
}

/** 创建自定义固定navWidth宽度的多功能窗口 */
+ (instancetype)tapSlideWithNavigationController:(UINavigationController *)navViewController withNavWidth:(CGFloat)navWidth
{
    // 当确定nav控制器的宽度时，计算右边偏移量
    LeftOffSetX = ScreenSize.width - navWidth;
    
    return [[self alloc] initTapSlideWithNavigationController:navViewController withNavWidth:navWidth];
}

/** 创建自定义右边偏移量的多功能窗口 */
+ (instancetype)tapSlideWithNavigationController:(UINavigationController *)navViewController offsetX:(CGFloat)offsetX
{
    // 自定义右边偏移量
    LeftOffSetX = offsetX;
    
    return [self tapSlideWithNavigationController:navViewController withNavWidth:ScreenSize.width - LeftOffSetX];
}


#pragma mark - 初始化
- (void)setupTapSlideVCWithNavigationController:(UINavigationController *)navViewController WithNavWidth:(CGFloat)navWidth
{
    // 1.设置控制器的背景
    self.backgroundColor = BgAlphaColor(0);
    
    [UIView animateWithDuration:1.0 animations:^{
        self.backgroundColor = BgGrayColor;
    }];
    
    // 2.创建导航控制器navVC及其tableView子控制器vc
    [self setupChildVCWithNavigationController:(UINavigationController *)navViewController WithNavWidth:navWidth];
    
    // 3.给导航栏窗口添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.navVC.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 1.获取控制器的x的偏移量
    CGFloat transX = [pan translationInView:self.navVC.view].x;

    // 2.设置控制器的偏移
    CGRect frame = self.navVC.view.frame;
    frame.origin.x += transX;
    
    if (frame.origin.x > self.leftOffSetX) { // 只有大于最小偏移量的时候才需要偏移VC
        self.navVC.view.frame = frame;
        
        // 在拖拽过程中实现了背景颜色的渐变,计算透明度
        CGFloat ratioOne = navVCViewAlpha;
        CGFloat ratio = ratioOne *(1- (frame.origin.x - self.leftOffSetX) / (frame.size.width - self.leftOffSetX));
        self.backgroundColor = BgAlphaColor(ratio * 255);;
    }
    
    // 3.复位
    [pan setTranslation:CGPointZero inView:self.navVC.view];
    
    // 4.松开手势的时候
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 4.1 当x值小于两倍的LeftOffSetX值的时候复位到默认位置
        CGFloat x = frame.origin.x;
        if (x <= (self.leftOffSetX + 100)) {
            frame.origin.x = self.leftOffSetX;
            [UIView animateWithDuration:AnimationTime animations:^{
                self.navVC.view.frame = frame;
            }];
        }else{ // 4.2 当偏移量超过两倍的LeftOffSetX值的时候关闭窗口
            [self close];
        }
    }
}

#pragma mark - 创建窗口的子类(创建导航控制器navVC及其tableView子控制器vc)
- (void)setupChildVCWithNavigationController:(UINavigationController *)navViewController WithNavWidth:(CGFloat)navWidth
{
    // 1.创建导航控制器的根控制器（占位控制器，会被用户自定义的数据源控制器覆盖）
    UITableViewController *navRootVC = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    navRootVC.tableView.separatorStyle = UITableViewScrollPositionNone;
    
    _navRootVC = navRootVC;
    
    // 2.创建导航栏控制器
    UINavigationController *navVC = navViewController;
    
    navVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    
    _navVC = navVC;
    
    self.rootViewController = navVC;
    
    // 3.设置导航栏控制器的frame
    __block CGRect frame = [UIScreen mainScreen].bounds;
    
    frame.origin.x = ScreenSize.width;
    frame.size.width = ScreenSize.width;
    frame.size.height = ScreenSize.height;
    navVC.view.frame = frame;
    
    // 动画显示窗口
    [UIView animateWithDuration:AnimationTime animations:^{
        frame.origin.x = self.leftOffSetX;
        frame.size.width = ScreenSize.width - frame.origin.x;
        navVC.view.frame = frame;
    }];
}

#pragma mark - 点击主窗口时，关闭窗口
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 关闭窗口
    [self close];
}

#pragma mark - 关闭当前窗口
- (void)close
{
    // 动画隐藏窗口
    __block CGRect frame = self.navVC.view.frame;
    [UIView animateWithDuration:AnimationTime animations:^{
        // 子窗口位置
        frame.origin.x = ScreenSize.width;
        self.navVC.view.frame = frame;
        
        // 窗口背景颜色
        self.backgroundColor = BgAlphaColor(0);
    }completion:^(BOOL finished) {
        self.hidden = YES ;
    }];
}

#pragma mark - 显示当前窗口
- (void)show
{
    self.hidden = NO ;
    
    // 动画隐藏窗口
    __block CGRect frame = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:AnimationTime animations:^{
        frame.origin.x = self.leftOffSetX;
        frame.size.width = ScreenSize.width - self.leftOffSetX;
        self.navVC.view.frame = frame;
        
        // 窗口背景颜色
        self.backgroundColor = BgGrayColor;
    }completion:^(BOOL finished) {
        
    }];
}
@end
