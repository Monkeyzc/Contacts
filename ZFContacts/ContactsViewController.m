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
@property (nonatomic, strong, readwrite) NSMutableDictionary *indexDic;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Contacts";
    self.tableView.rowHeight = 60;
    
    [[ZFContactsScan shareInstance] fetchAllContacts:^(NSArray *allContacts){
        
        // sort array by fullName
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES selector:@selector(localizedStandardCompare:)];
        self.allContacts = [allContacts sortedArrayUsingDescriptors:@[descriptor]];
        
        // create index dictionary
        NSMutableDictionary *indexDic = [[NSMutableDictionary alloc] init];
        [self.allContacts enumerateObjectsUsingBlock:^(ContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *indexValue = [indexDic objectForKey: obj.firstLetter];
            if (indexValue) {
                [indexValue addObject: obj];
            } else {
                indexValue = [[NSMutableArray alloc] init];
                [indexValue addObject: obj];
                [indexDic setObject: indexValue forKey: obj.firstLetter];
            }
        }];
        self.indexDic = indexDic;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.indexDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [[self.indexDic allKeys] objectAtIndex: section];
    NSArray *contacts = [self.indexDic objectForKey: key];
    return contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [ContactCell contactCellWithTableView:tableView];
    NSString *key = [[self.indexDic allKeys] objectAtIndex: indexPath.section];
    NSArray *contacts = [self.indexDic objectForKey: key];
    cell.contact = contacts[indexPath.row];
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.indexDic allKeys];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 24)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, [UIScreen mainScreen].bounds.size.width, 24)];
    [sectionHeaderView addSubview:lable];
    lable.text = [self.indexDic allKeys][section];
    return sectionHeaderView;
}


@end
