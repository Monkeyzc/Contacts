//
//  ContactsViewController.m
//  ZFContacts
//
//  Created by zhaofei on 2017/2/17.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import "ContactsViewController.h"
#import "ZFContactsScan.h"
#import "ContactCell.h"

@interface ContactsViewController ()
@property (nonatomic, strong) NSArray *allContacts;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Contacts";
    self.tableView.rowHeight = 60;
//    self.tableView.estimatedRowHeight = 60;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [[ZFContactsScan shareInstance] fetchAllContacts:^(NSArray *allContacts){
//        NSLog(@"fetch all contacts result: %@", allContacts);
        self.allContacts = allContacts;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [ContactCell contactCellWithTableView:tableView];
    cell.contact = self.allContacts[indexPath.row];
    return cell;
}

@end
