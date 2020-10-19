//
//  HSViewController.m
//  HSDialog
//
//  Created by hesong_ios@163.com on 10/19/2020.
//  Copyright (c) 2020 hesong_ios@163.com. All rights reserved.
//

#import "HSViewController.h"

#import "YKDialog.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HSViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hudTitleArr,*alertTitleArr;

@end

@implementation HSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    //设置默认样式以及通用配置-不设置会用默认的显示只需设置一次
    YKDialog.styleColor = UIColorFromRGB(0xFF5F2E);
    YKDialog.alertFont = [UIFont boldSystemFontOfSize:18];
    YKDialog.infoFont = [UIFont systemFontOfSize:16];
    YKDialog.codeFont = [UIFont systemFontOfSize:13];
    YKDialog.buttonFont = [UIFont systemFontOfSize:18];
    
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?self.hudTitleArr.count:self.alertTitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25)];
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 15)];
    la.font = [UIFont systemFontOfSize:15];
    la.text = section == 0 ? @"hud弹框": @"alert弹框";
    [view addSubview:la];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentfile = @"tableViewIndentfile";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentfile];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentfile];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSString *text = indexPath.section == 0 ? _hudTitleArr[indexPath.row] : _alertTitleArr[indexPath.row];
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YKDialog.alert(@"提示").info(@"这是一个显示标题信息以及错误版本号的hud").errorCode(@"-100").version(@"108001").hud();
        } else if (indexPath.row == 1) {
            YKDialog.alert(@"提示").info(@"这是一个显示标题信息的hud").hud();
        } else if (indexPath.row == 2) {
            YKDialog.alert(@"提示").titleFont([UIFont boldSystemFontOfSize:20]).titleColor([UIColor redColor]).info(@"这是一个显示标题信息的hud").infoFont([UIFont systemFontOfSize:16]).infoColor([UIColor blueColor]).hud();
        } else if (indexPath.row == 3) {

            YKDialog.alert(@"").info(@"这是一个不显示标题，显示信息的hud").errorCode(@"-100").version(@"108001").hud();
        }
    } else {
        if (indexPath.row == 0) {
            
            YKDialog.alert(@"提示").info(@"这是一个显示标题信息以及错误版本号的确认按钮取消按钮的alert").errorCode(@"-100").version(@"108001").confirm(@"确认",^{
                
            }).cancel(@"取消",^{
                
            }).show();
            
        } else if (indexPath.row == 1) {
            
            YKDialog.alert(@"提示").info(@"这是一个显示标题信息确定按钮的alert").confirm(@"确认",^{
            }).hiddenClose(YES).show();
            
        } else if (indexPath.row == 2) {
            
            YKDialog.alert(@"提示").info(@"这是一个显示标题信息的alert").show();
            
        } else if (indexPath.row == 3) {
            
            YKDialog.alert(@"提示").titleFont([UIFont boldSystemFontOfSize:20]).titleColor([UIColor redColor]).info(@"这是一个显示标题信息的hud").infoFont([UIFont systemFontOfSize:16]).infoColor([UIColor blueColor]).show();
        } else if (indexPath.row == 4) {
            
            YKDialog.alert(@"").info(@"这是一个不显示标题，显示信息的hud").show();
        }
    }
}

#pragma mark - Getter and Setter

- (NSMutableArray *)hudTitleArr
{
    if (!_hudTitleArr) {
        self.hudTitleArr = [[NSMutableArray alloc] initWithObjects:@"标题-信息-版本号", @"标题-信息",@"自定义显示字体颜色",@"不显示标题，显示信息", nil];
    }
    return _hudTitleArr;
}

- (NSMutableArray *)alertTitleArr
{
    if (!_alertTitleArr) {
        self.alertTitleArr = [[NSMutableArray alloc] initWithObjects:@"标题-信息-版本号-关闭-确定-取消", @"标题-信息-确定",@"标题-信息",@"自定义字体颜色",@"不显示标题，显示信息",nil];
    }
    return _alertTitleArr;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self addChildViewController:tvc];
        self.tableView                 = tvc.tableView;
        self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.delegate        = self;
        self.tableView.dataSource      = self;
//        self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



@end
