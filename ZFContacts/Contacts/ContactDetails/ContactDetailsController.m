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
    
//    self.view.backgroundColor = [UIColor yellowColor];
    
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
//    self.tableView.backgroundColor = [UIColor redColor];
    
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
@end
