//
//  LSLSlideShowViewController.h
//  多界面的抽屉
//
//  Created by lisilong
//  github地址：https://github.com/SilongLi
//

/**
 *  功能介绍: 当选择tableView的cell时,弹出多功能窗口，拖拽时隐藏窗口）
 */

#import <UIKit/UIKit.h>

@interface LSLSlideShowViewController : UIViewController
/** 创建固定偏移量为50的多功能窗口 */
+ (instancetype)slideShowViewControllerWithViewController:(UIViewController *)viewController;

/** 创建自定义固定viewController宽度的多功能窗口 */
+ (instancetype)slideShowViewControllerWithViewController:(UIViewController *)viewController viewControllerWidth:(CGFloat)viewControllerWidth;

/** 创建自定义右边偏移量的多功能窗口 */
+ (instancetype)slideShowViewControllerWithViewController:(UIViewController *)viewController offsetX:(CGFloat)offsetX;

/** 关闭当前窗口 */
- (void)close;
@end
