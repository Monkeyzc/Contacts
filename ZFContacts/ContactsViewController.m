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

static NSString *ContactCellIdentifier = @"ContactCellIdentifier";

@interface ContactsViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UIViewControllerPreviewingDelegate>
@property (nonatomic, strong, readwrite) UISearchDisplayController *searchDisplayController;

@property (nonatomic, strong) NSArray *allContacts;
@property (nonatomic, strong, readwrite) NSMutableDictionary *indexDic;
@property (nonatomic, strong, readwrite) NSArray *searchResult;
@end

@implementation ContactsViewController

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Contacts";
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.searchBar.delegate = self;
    [tableViewHeaderView addSubview: self.searchBar];
    self.tableView.tableHeaderView = tableViewHeaderView;
    
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
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableView isEqual:self.tableView] ? [[self.indexDic allKeys] count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        NSString *key = [[self.indexDic allKeys] objectAtIndex: section];
        NSArray *contacts = [self.indexDic objectForKey: key];
        return contacts.count;
    }
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [ContactCell contactCellWithTableView:tableView];
    if ([tableView isEqual:self.tableView]) {
        NSString *key = [[self.indexDic allKeys] objectAtIndex: indexPath.section];
        NSArray *contacts = [self.indexDic objectForKey: key];
        cell.contact = contacts[indexPath.row];
    } else {
        cell.contact = self.searchResult[indexPath.row];
    }
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [tableView isEqual:self.tableView] ? [self.indexDic allKeys] : nil;
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
    lable.text = [self.indexDic allKeys][section];
    return sectionHeaderView;
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
@end
