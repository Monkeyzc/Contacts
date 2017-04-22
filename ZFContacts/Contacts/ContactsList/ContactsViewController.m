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
#import "ContactDetailsController.h"

static NSString *ContactCellIdentifier = @"ContactCellIdentifier";

@interface ContactsViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UIViewControllerPreviewingDelegate, UIPreviewActionItem>
@property (nonatomic, strong, readwrite) UISearchDisplayController *searchDisplayController;

@property (nonatomic, strong) NSArray *allContacts;
@property (nonatomic, strong, readwrite) NSMutableDictionary *indexDic;
@property (nonatomic, strong, readwrite) NSMutableArray *indexTitles;
@property (nonatomic, strong, readwrite) NSArray *searchResult;
@end

@implementation ContactsViewController

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
        NSLog(@"======");
    }
    return isForceTouchAvailable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Contacts";
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"设置权限" style:UIBarButtonItemStylePlain target: self action: @selector(clickSetRoot)];
    
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.searchBar.delegate = self;
    [tableViewHeaderView addSubview: self.searchBar];
    self.tableView.tableHeaderView = tableViewHeaderView;
    
    [[ZFContactsScan shareInstance] fetchAllContacts:^(NSArray *allContacts){
        
        // sort array by fullName
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES selector:@selector(localizedStandardCompare:)];
        self.allContacts = [allContacts sortedArrayUsingDescriptors:@[descriptor]];
        
        // create index dictionary
        NSMutableDictionary *indexDic = [[NSMutableDictionary alloc] init];
        NSMutableArray *indexTitles = [NSMutableArray array];
        
        [self.allContacts enumerateObjectsUsingBlock:^(ContactModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *indexValue = [indexDic objectForKey: obj.firstLetter];
            
            if (!indexValue) {
                indexValue = [[NSMutableArray alloc] init];
                [indexDic setObject: indexValue forKey: obj.firstLetter];
                [indexTitles addObject: obj.firstLetter];
            }
            
            [indexValue addObject: obj];
        }];
        self.indexDic = indexDic;
        self.indexTitles = indexTitles;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)clickSetRoot {
    NSURL *url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL: url];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableView isEqual:self.tableView] ? [[self.indexDic allKeys] count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        NSString *key = self.indexTitles[section];
        NSArray *contacts = [self.indexDic objectForKey: key];
        return contacts.count;
    }
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [ContactCell contactCellWithTableView:tableView set3DTouchBlock:^(ContactCell *cell) {
        // cell 注册 3D touch
        if ([self isForceTouchAvailable]) {
            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView: cell];
        }
    }];
    if ([tableView isEqual:self.tableView]) {
        NSString *key = self.indexTitles[indexPath.section];
        NSArray *contacts = [self.indexDic objectForKey: key];
        cell.contact = contacts[indexPath.row];
    } else {
        cell.contact = self.searchResult[indexPath.row];
    }
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [tableView isEqual:self.tableView] ? self.indexTitles : nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView isEqual:self.tableView] ? 24 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return nil;
    }
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 24)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, [UIScreen mainScreen].bounds.size.width, 24)];
    [sectionHeaderView addSubview:lable];
    lable.text = self.indexTitles[section];
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactModel *contact;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        contact = self.searchResult[indexPath.row];
    } else {
        NSString *key = self.indexTitles[indexPath.section];
        contact = [[self.indexDic objectForKey:key] objectAtIndex:indexPath.row];
    }
    if (contact) {
        ContactDetailsController *contactDetailsVC = [[ContactDetailsController alloc] init];
        contactDetailsVC.contact = contact;
        [self.navigationController pushViewController: contactDetailsVC animated:YES];
    }
}

#pragma mark - UISearchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    if (!self.searchDisplayController) {
        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        _searchDisplayController.delegate = self;
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
        _searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    }
    if (!self.searchDisplayController.active) {
        [self.searchDisplayController setActive:YES animated:YES];
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"searchText CONTAINS[cd] %@", searchText];
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate]];
    self.searchResult = [self.allContacts filteredArrayUsingPredicate:compoundPredicate];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - UIViewControllerPreviewingDelegate

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    ContactCell *cell = (ContactCell *)[previewingContext sourceView];
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
    
    NSString *key = [self.indexTitles objectAtIndex: indexPath.section];
    ContactModel *contact = [[self.indexDic objectForKey: key] objectAtIndex: indexPath.row];
    
    // 设定预览界面
    ContactDetailsController *contactDetailsVC = [[ContactDetailsController alloc] init];
    contactDetailsVC.contact = contact;
    
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    previewingContext.sourceRect = rect;
    
    return contactDetailsVC;
}

// 展示预览图
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController: viewControllerToCommit sender: self];
}
@end
