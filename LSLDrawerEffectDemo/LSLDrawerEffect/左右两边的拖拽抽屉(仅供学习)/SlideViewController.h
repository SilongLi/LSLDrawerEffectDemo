//
//  SlideViewController.h
//  左右两边的拖拽抽屉
//
//  Created by lisilong
//  github地址：https://github.com/SilongLi
//

#import <UIKit/UIKit.h>

@interface SlideViewController : UIViewController
/** 左边的窗口 */
@property(nonatomic,strong,readonly)UIView *leftView;
/** 中间的窗口 */
@property(nonatomic,strong,readonly)UIView *mainView;
/** 右边的窗口 */
@property(nonatomic,strong,readonly)UIView *rightView;
@end

