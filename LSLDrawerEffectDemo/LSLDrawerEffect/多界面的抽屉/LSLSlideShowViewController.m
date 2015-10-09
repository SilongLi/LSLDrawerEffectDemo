//
//  LSLSlideShowViewController.m
//  多界面的抽屉
//
//  Created by lisilong
//  github地址：https://github.com/SilongLi
//

/**
 *  功能介绍: 当选择tableView的cell时,弹出多功能窗口，拖拽时隐藏窗口）
 */

#import "LSLSlideShowViewController.h"

// 屏幕size
#define ScreenSize [UIScreen mainScreen].bounds.size

@interface LSLSlideShowViewController ()
/** 占位控制器 */
@property(nonatomic,weak)UIViewController *rootVC;
@end

// 动画时间
static CGFloat const AnimationTime = 0.5;
// 动画时间
static CGFloat LeftOffSetX = 50;
// 导航条的最大Y值
static CGFloat const NavMaxY = 64;

@implementation LSLSlideShowViewController
#pragma mark - 快速创建的类方法
/** 创建固定偏移量为50的多功能窗口 */
+ (instancetype)slideShowViewControllerWithViewController:(UIViewController *)viewController
{
    LSLSlideShowViewController *showVc = [[self alloc] init];
    
    // 动画显示view
    showVc.view.frame = CGRectMake(ScreenSize.width, NavMaxY, ScreenSize.width, ScreenSize.height - NavMaxY);
    
    [UIView animateWithDuration:AnimationTime animations:^{
        showVc.view.frame = CGRectMake(LeftOffSetX, NavMaxY, ScreenSize.width, ScreenSize.height - NavMaxY);
    }];
        
    // 1.创建导航控制器navVC及其tableView子控制器vc
    [showVc setupChildVCWithViewController:viewController];
    
    return showVc;
}

/** 创建自定义右边偏移量的多功能窗口 */
+ (instancetype)slideShowViewControllerWithViewController:(UIViewController *)viewController offsetX:(CGFloat)offsetX
{
    LeftOffSetX = offsetX;
    
    return [self slideShowViewControllerWithViewController:viewController];
}

/** 创建自定义固定viewController宽度的多功能窗口 */
+ (instancetype)slideShowViewControllerWithViewController:(UIViewController *)viewController viewControllerWidth:(CGFloat)viewControllerWidth
{
    LeftOffSetX = ScreenSize.width - viewControllerWidth;
    
    return [self slideShowViewControllerWithViewController:viewController];
}

#pragma mark - 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.给导航栏窗口添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.view addGestureRecognizer:pan];
}

#pragma mark - 创建子控件
- (void)setupChildVCWithViewController:(UIViewController *)viewController
{
    UIViewController *rootVC = viewController;
    
    // 1.创建根控制器（占位控制器）leViewController
    if ([viewController isKindOfClass:[UITableViewController class]]) {
        UITableViewController  *rootVC = (UITableViewController *)viewController;
        rootVC.tableView.contentInset = UIEdgeInsetsMake(-NavMaxY, 0, 0, 0);
    }
    
    _rootVC = rootVC;
    
    // 2.设置子窗口的frame
    rootVC.view.frame = self.view.bounds;
    
    [self.view addSubview:rootVC.view];
    
    // 设计原理,如果A控制器的view成为b控制器view的子控件,那么这个A控制器必须成为B控制器的子控制器
    [self addChildViewController:rootVC];
}

#pragma mark - 拖拽手势
- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 1.获取控制器的x的偏移量
    CGFloat transX = [pan translationInView:self.view].x;
    
    // 2.设置控制器的偏移
    CGRect frame = self.view.frame;
    frame.origin.x += transX;
    
    if (frame.origin.x > LeftOffSetX) { // 只有大于最小偏移量的时候才需要偏移VC
        self.view.frame = frame;
    }
    
    // 3.复位
    [pan setTranslation:CGPointZero inView:self.view];
    
    // 4.松开手势的时候
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 4.1 当x值小于两倍的LeftOffSetX值的时候复位到默认位置
        CGFloat x = frame.origin.x;
        if (x <= (LeftOffSetX * 2)) {
            frame.origin.x = LeftOffSetX;
            [UIView animateWithDuration:AnimationTime animations:^{
                self.view.frame = frame;
            }];
        }else{ // 4.2 当偏移量超过两倍的LeftOffSetX值的时候关闭窗口
            [self close];
        }
    }
}

// 判断是否正在执行close动画
static BOOL isClosing = NO;
#pragma mark - 关闭当前窗口
- (void)close
{
    if (!isClosing) {
        isClosing = YES; // 在未执行完前关闭
        
        // 动画隐藏窗口
        __block CGRect frame = self.view.frame;
        frame.origin.x = LeftOffSetX;
        [UIView animateWithDuration:AnimationTime animations:^{
            // 子窗口位置
            frame.origin.x = ScreenSize.width;
            self.view.frame = frame;
            
        }completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self.rootVC removeFromParentViewController];
            [self removeFromParentViewController];
            
            isClosing = NO;
        }];
    }
}
@end
