//
//  LSLMainTableViewController.m
//  多界面的抽屉 demo
//
//  Created by lisilong
//  github地址：https://github.com/SilongLi
//

#import "LSLMainViewController.h"
#import "LSLSlideShowViewController.h"
#import "TestTableViewController.h"

@interface LSLMainViewController ()
/** 弹出的抽屉窗口 */
@property(nonatomic,strong)LSLSlideShowViewController *showVC;

#warning 用户自定义数据源
/** 用户自定义弹出界面的数据源控制器 */
@property(nonatomic,strong)TestTableViewController *tableVC;
@end

@implementation LSLMainViewController
#pragma mark - 懒加载,实现只弹出一个多功能抽屉界面
- (LSLSlideShowViewController *)showVC
{
    if (!_showVC) {
        _showVC = [[LSLSlideShowViewController alloc] init];
    }
    return _showVC;
}

#pragma mark - 选中某一行cell的时候，查询数据并把结果显示到弹出的多功能界面中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 弹出多功能抽屉界面
    [self setupChildVc];
}

#pragma mark - 弹出多功能抽屉界面方法
- (void)setupChildVc
{
    // 2. 如果已经有窗体了就不再创建了
    if (self.showVC.childViewControllers.count) {
        return;
    }
    
    // 3. 创建抽屉界面
    // 3.1 用户自定义显示的数据源窗口（可以是UIViewController对象及其所有子类对象）
    self.tableVC = [[TestTableViewController alloc] init];
    
    // 3.2 创建抽屉界面(三种方式)
    // (1)直接根据类方法(slideShowViewControllerWithViewController:)创建,则默认右边偏移量为50
    LSLSlideShowViewController *showVC = [LSLSlideShowViewController slideShowViewControllerWithViewController:self.tableVC];
    
    // (2)创建自定义固定viewController宽度的多功能窗口
//    LSLSlideShowViewController *showVC = [LSLSlideShowViewController slideShowViewControllerWithViewController:self.tableVC viewControllerWidth:300];
    
    // (3)根据导航控制器的宽度来创建
//    LSLSlideShowViewController *showVC = [LSLSlideShowViewController slideShowViewControllerWithViewController:self.tableVC offsetX:100];
    
    _showVC  = showVC;
    
    // 4. 把抽屉界面添加当前界面中
    [self.parentViewController.view addSubview:_showVC.view];
    [self.parentViewController addChildViewController:_showVC];
}

#pragma mark - 滚动界面时，隐藏弹出的抽屉界面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 隐藏弹出的抽屉界面
    [self close];
}

#pragma mark - 关闭弹出窗体
- (void)close
{
    [self.showVC close];
}


/********************* 需要用户自定义的数据源 ***************************************/
#pragma mark - 设置模拟数据源
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
    
    cell.textLabel.text  = [NSString stringWithFormat:@"弹出多功能抽屉界面---%zd",indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.8];
    return cell;
}

#pragma mark - 设置分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
