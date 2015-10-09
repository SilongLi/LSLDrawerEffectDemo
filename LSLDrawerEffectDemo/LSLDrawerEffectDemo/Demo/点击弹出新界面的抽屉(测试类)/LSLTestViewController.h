//
//  LSLTextViewController.h
//  多功能抽屉窗口 测试类
//
//  Created by lisilong on 15/10/2.
//  Copyright (c) 2015年 李思龙. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 当点击关闭按钮就是回调block，关闭当前window*/
typedef void(^CloseBlock)();

@interface LSLTestViewController : UITableViewController
/** 当点击关闭按钮就是回调block，关闭当前window */
@property(nonatomic,copy)CloseBlock closeBlock;
@end
