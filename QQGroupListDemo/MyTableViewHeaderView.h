//
//  MyTableViewHeaderView.h
//  TableViewDemo
//
//  Created by qzwh on 2018/10/18.
//  Copyright © 2018年 qianjinjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *titleLabel;
- (void)clickTap:(void(^)(void))block;

@end
