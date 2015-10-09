//
//  LSLTapSlideViewController.h
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

#import <UIKit/UIKit.h>

@interface LSLTapSlideViewController : UIWindow

/** 创建固定偏移量为50的多功能窗口 */
+ (instancetype)tapSlideWithNavigationController:(UINavigationController *)navigationController;

/** 创建自定义固定navWidth宽度的多功能窗口 */
+ (instancetype)tapSlideWithNavigationController:(UINavigationController *)navigationController withNavWidth:(CGFloat)navWidth;

/** 创建自定义右边偏移量的多功能窗口 */
+ (instancetype)tapSlideWithNavigationController:(UINavigationController *)navigationController offsetX:(CGFloat)offsetX;

/** 显示当前多功能窗口 */
- (void)show;

/** 关闭当前多功能窗口 */
- (void)close;
@end
