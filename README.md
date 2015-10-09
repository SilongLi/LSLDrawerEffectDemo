# LSLDrawerEffectDemo
多功能多样式抽屉界面的封装，使用非常简单，只需要直接把相应的一两个类拖进项目中即可使用。

#### 多功能界面模式一： 给某个控件绑定事件，点击时弹出多功能窗口（抽屉效果）
- 使用说明:
    + 1.根据懒加载中的方法，创建多功能窗口
    + 2.创建一个UINavigationController控制器来管理界面
    + 3.创建UINavigationController的根控制器（数据源控制器）


```objc
#import "LSLTapSlideViewController.h"
```

```objc
/** 多功能窗口 */
@property(nonatomic,strong)LSLTapSlideViewController *window_;

/** 数据源窗口 */
@property(nonatomic,strong)LSLTestViewController *testVC;
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
//        CHTapSlideViewController *window_ = [CHTapSlideViewController tapSlideWithNavigationController:nav withNavWidth:300];

// 3.3 根据右边偏移量来创建
//        CHTapSlideViewController *window_ = [CHTapSlideViewController tapSlideWithNavigationController:nav offsetX:100];

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

```

```objc
// 点击弹出新界面的抽屉 demo
- (IBAction)btnTwoClick:(id)sender {

[self.window_ show];
}
```

![](https://github.com/SilongLi/LSLDrawerEffectDemo/raw/master/LSLDrawerEffectDemo/Logo/多功能抽屉界面demo1.gif)

#### 多功能界面模式二： 选中cell时，弹出显示数据详情多功能窗口，拖拽时隐藏

- 使用时直接实现以下下面的代码（或直接粘）就行了，其中数据源根据自己的具体需求而定。

```objc
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

```

![](https://github.com/SilongLi/LSLDrawerEffectDemo/raw/master/LSLDrawerEffectDemo/Logo/多功能抽屉界面demo2.gif)


#### 多功能界面模式三：多功能抽屉效果的练习demo

```objc
#import "SlideViewController.h"
//...

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
```
![](https://github.com/SilongLi/LSLDrawerEffectDemo/raw/master/LSLDrawerEffectDemo/Logo/多功能抽屉界面demo3.gif)
