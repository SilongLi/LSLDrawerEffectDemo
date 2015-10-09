//
//  LSLTestViewController.h
//  多功能抽屉窗口 测试类
//
//  Created by lisilong on 15/10/2.
//  Copyright (c) 2015年 李思龙. All rights reserved.
//

#import "LSLTestViewController.h"

@interface LSLTestViewController ()

@end

// 普通argb颜色
#define CHARGBColor(a,r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define CHBGColor(r,g,b) CHARGBColor(255,(r),(g),(b))
#define CHGrayColor(v) CHBGColor(v,v,v)
#define CHCommenBGColor CHGrayColor(255)  // 灰色背景颜色

@implementation LSLTestViewController
#pragma mark - 按钮的监听事件
// 用户自选是否需要实现这个关闭按钮的功能
- (void)closeCurrentWindow
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark - 初始化数据
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置nav的属性
    [self setupNav];
}

#pragma mark - 设置nav的属性
- (void)setupNav
{
    // 设置nav的标题
    UILabel *label = [[UILabel alloc] init];
    label.textColor = CHGrayColor(80);
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"青苹果园";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    // 创建关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
    [backButton setTitleColor:CHBGColor(55, 106, 198) forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(closeCurrentWindow) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

#pragma mark - 设置分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



#pragma mark - 测试数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text  = [NSString stringWithFormat:@"多功能抽屉窗口 demo"];
    
    return cell;
}
@end
