//
//  ViewController.m
//  HideNaviDemo
//
//  Created by TaiHuiTao on 16/8/11.
//  Copyright © 2016年 TaiHuiTao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) BOOL isHide;
@end

@implementation ViewController
@synthesize myTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的首页";
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor lightGrayColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    [self HideNavi];
}

#pragma mark TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%ld",(long)section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}
#pragma mark - 上拉隐藏navigation bar
- (void)HideNavi{
    [myTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isEqual:myTableView] && [keyPath isEqualToString:@"contentOffset"]) {
        //获取新值旧值
        CGFloat newY = [change[@"new"] CGPointValue].y;
        CGFloat oldY = [change[@"old"] CGPointValue].y;
        float i = newY - oldY;//下拉是新值小于旧值的，所以i<0 是下拉 i>0 是上滑
         NSLog(@"%f",myTableView.contentOffset.y);
        if (myTableView.contentOffset.y > -64 && myTableView.contentOffset.y <= 24) {//边界条件，此处不精确
            if (i <= 0 && _isHide == NO && self.navigationController.navigationBar.frame.origin.y == 20){
                //下拉＋bar 已经显示的状态，不再移动
                return;
            }
            _isHide = NO;
            //设置navigationbar 的frame 使他根据tableView来滑动
            self.navigationController.navigationBar.frame = CGRectMake(0, -44 - myTableView.contentOffset.y, self.view.bounds.size.width, 44);
            //控制透明度
            self.navigationController.navigationBar.alpha = -myTableView.contentOffset.y/64;
        }else if (myTableView.contentOffset.y > 24) {
            if (i > 10) {//更改数值大小可以控制触发 navigation bar 的滑动速度
                _isHide = YES;
            }else if(i < -10) {
                _isHide = NO;
            }
        }
        [self.navigationController setNavigationBarHidden:_isHide animated:YES];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [myTableView removeObserver:self forKeyPath:@"contentOffset"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
