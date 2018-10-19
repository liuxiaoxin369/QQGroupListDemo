//
//  ViewController.m
//  TableViewDemo
//
//  Created by qzwh on 2018/10/18.
//  Copyright © 2018年 qianjinjia. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewHeaderView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource; //数据源
@end

@implementation ViewController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        //初始化数据源 初始化100分组数据
        for (int i = 0; i < 100; i++) {
            NSMutableArray *subArr = [NSMutableArray array];
            [_dataSource addObject:subArr];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subArr = self.dataSource[section];
    return subArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"这个cell的位置section:%ld, row:%ld", indexPath.section, indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MyTableViewHeaderView *myView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MyTableViewHeaderView class])];
    myView.titleLabel.text = [NSString stringWithFormat:@"当前处的位置section：%ld", section];
    //点击整个section，创建cell数据，然后刷新section，把添加的cell数据展示出来
    [myView clickTap:^{
        NSMutableArray *subArr = self.dataSource[section];
        if (subArr.count > 0) {
            [subArr removeAllObjects];
        } else {
            //创建1-10随机数
            NSInteger random = 1 +  (arc4random() % 3);
            //往子数组中添加1-3个cell
            for (int i = 0; i < random; i++) {
                [subArr addObject:@""];
            }
        }
        
        //刷新tableView
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//        [self updateTableViewContentOffsetWithSection:section];
    }];
    return myView;
}

- (void)updateTableViewContentOffsetWithSection:(NSInteger)section {
    //第一种解决方案：
    //在刷新当前section数据之后计算当前section的偏移量，重置tableView的contentOffset
//    CGFloat offset = 0;
//    for (int i = 0; i < section; i++) {
//        NSArray *tempArr = self.dataSource[i];
//        if (tempArr.count > 0 && i != section) { //如果有cell  加上cell的高度
//            offset += (tempArr.count * 44);
//        }
//
//        //加上section的高度
//        offset += 60;
//    }
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//    self.tableView.contentOffset = CGPointMake(0, offset);
    
    //第二种解决方案：
    //首先在刷新之前获取到当前点击section位置与当前tableView偏移量的差值，这个差值再刷新之后应该是不变的，
    //再刷新之后我先获取到当前section的位置信息，然后减去之前的差值，求取出当前tableView的偏移量
    CGRect beforeSectionRect = [self.tableView rectForSection:section];
    //当前section的偏移量
    CGFloat offset = beforeSectionRect.origin.y - self.tableView.contentOffset.y;
    NSLog(@"之前：%@=========%@", NSStringFromCGRect([self.tableView rectForSection:section]), self.tableView);
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView layoutIfNeeded];
    [self.tableView layoutSubviews];
    
    CGRect afterSectionRect = [self.tableView rectForSection:section];
    CGPoint point = CGPointMake(0, afterSectionRect.origin.y-offset);
    self.tableView.contentOffset = point;
    NSLog(@"之后：%@=========%@", NSStringFromCGRect([self.tableView rectForSection:section]), self.tableView);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [_tableView registerClass:[MyTableViewHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MyTableViewHeaderView class])];
    }
    return _tableView;
}


@end
