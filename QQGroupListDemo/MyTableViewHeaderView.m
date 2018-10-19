//
//  MyTableViewHeaderView.m
//  TableViewDemo
//
//  Created by qzwh on 2018/10/18.
//  Copyright © 2018年 qianjinjia. All rights reserved.
//

#import "MyTableViewHeaderView.h"

@interface MyTableViewHeaderView ()

@property (nonatomic, strong) void(^clickTapBlock)(void);

@end

@implementation MyTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    self.contentView.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    [self.contentView addSubview:self.titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    [self.contentView addGestureRecognizer:tap];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (self.clickTapBlock) {
        self.clickTapBlock();
    }
}

- (void)clickTap:(void(^)(void))block {
    self.clickTapBlock = [block copy];
}

@end
