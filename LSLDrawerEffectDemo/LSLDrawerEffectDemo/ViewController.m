//
//  ViewController.m
//  LSLDrawerEffectDemo
//
//  Created by lisilong
//  github地址：https://github.com/SilongLi
//

#import "ViewController.h"
#import "SlideViewController.h"
#import "LSLMainViewController.h"
#import "LSLTapSlideViewController.h"
#import "LSLTestViewController.h"

// 弱引用
#define CHWeakSelf __weak typeof(self) weakSelf = self

@interface ViewController ()
/** 多功能窗口 */
@property(nonatomic,strong)LSLTapSlideViewController *window_;

/** 数据源窗口 */
@property(nonatomic,strong)LSLTestViewController *testVC;

/**  */
@property(nonatomic,strong)UIView *wind;
@end

@implementation ViewController
/******************************************************************************/
/************************************ demo 1 **********************************/
/******************************************************************************/
#pragma mark - 懒加载
/** 创建窗口 */
- (LSLTapSlideViewController *)window_
{
    if (!_window_) {
        // 1.自定义一个数据源控制器：可以是tableView也可时viewController等
       self.testVC = [[LSLTestViewController alloc] initWithStyle:UITableViewStylePlain];
        
        // 2.创建一个导航控制器（可自定义）
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.testVC];
        
        // 3.创建抽屉window窗口(有三种定义方法)
        // 3.1 直接根据类方法(tapSlideWithNavigationController:)创建,则默认右边偏移量为50
       LSLTapSlideViewController *window_ = [LSLTapSlideViewController tapSlideWithNavigationController:nav];
        
        // 3.2 根据导航控制器的宽度来创建
//        LSLTapSlideViewController *window_ = [LSLTapSlideViewController tapSlideWithNavigationController:nav withNavWidth:300];
        
        // 3.3 根据右边偏移量来创建
//        LSLTapSlideViewController *window_ = [LSLTapSlideViewController tapSlideWithNavigationController:nav offsetX:100];
        
        CHWeakSelf;
        // 4.如果需要给窗口推荐关闭按钮，则可使用block实现
        self.testVC.closeBlock = ^{
            // 关闭窗口
            [weakSelf.window_ close];
        };
        
        _window_ = window_;
    }
    return _window_;
}

/*  功能介绍：给某个控件绑定事件，并弹出多功能窗口（抽屉效果）。
    使用说明: 1.根据懒加载中的方法，创建多功能窗口；
             2.创建一个UINavigationController控制器来管理界面；
             3.创建UINavigationController的根控制器（数据源控制器）。
 */
// 点击弹出新界面的抽屉 demo
- (IBAction)btnTwoClick:(id)sender {
    
//    [self.window_ show];
    UIView *wind = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    wind.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.6];
    
//    wind.windowLevel = UIWindowLevelAlert;
    [self.view  addSubview:wind];
    wind.userInteractionEnabled = NO;
    
    _wind = wind;
    
    wind.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击了下面的view");
}

/******************************************************************************/
/************************************ demo 2 **********************************/
/******************************************************************************/

/**
 *  功能介绍: 当选择tableView的cell时,弹出多功能窗口，拖拽时隐藏窗口）
 */

// 多界面的抽屉 demo，具体的使用方法在自定义LSLMainViewController类中
- (IBAction)btnOneClick:(id)sender {
    LSLMainViewController *mainVC = [[LSLMainViewController alloc] init];
    mainVC.view.frame = self.view.frame;

    [self.navigationController pushViewController:mainVC animated:YES];
}




/******************************************************************************/
/************************************ 练习 demo 3 **********************************/
/******************************************************************************/

/**
 功能介绍: 当往左边拖拽时显示左边的界面，右边同理。
 使用说明: 直接创建即可。
 */
// 左右两边的拖拽抽屉 demo ---  练习
- (IBAction)btnThreeClick:(id)sender {
    SlideViewController *slideVC = [[SlideViewController alloc] init];
    slideVC.view.frame = self.view.frame;
    
    [self.navigationController pushViewController:slideVC animated:YES];
    self.navigationController.navigationBar.hidden = YES;
}
@end
