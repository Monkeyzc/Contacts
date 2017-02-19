//
//  ContactDetailsController.m
//  ZFContacts
//
//  Created by zhaofei on 2017/2/18.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import "ContactDetailsController.h"
#import "ContactDetailsHeaderView.h"
#import "Masonry.h"

@interface ContactDetailsController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) ContactDetailsHeaderView *headerView;
@property (nonatomic, strong, readwrite) UITableView *tableView;
@end

@implementation ContactDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 设置导航栏阴影图片
    [self.navigationController.navigationBar setShadowImage: [UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.headerView = [[ContactDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, originalHeight)];
    self.headerView.contact = self.contact;
    
    self.tableView = [[UITableView alloc] initWithFrame: self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.headerView.scrollView = self.tableView;
    [self.view addSubview: self.tableView];
    [self.view addSubview: self.headerView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contact_details_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contact_details_cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

// 预览按钮 方法 要写在 被展示的控制器
// 预览向上滑动 展示 preview action items
- (NSArray <id <UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *actions_1 = [UIPreviewAction actionWithTitle: @"Action_1 default" style: UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action_1 default");
    }];
    
    UIPreviewAction *actions_2 = [UIPreviewAction actionWithTitle: @"Action_2 default" style: UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action_2 default");
    }];
    
    UIPreviewAction *actions_3 = [UIPreviewAction actionWithTitle: @"Action_3 default" style: UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action_3 default");
    }];
    
    return @[actions_1, actions_2, actions_3];
}

@end
