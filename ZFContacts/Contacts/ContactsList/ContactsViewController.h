//
//  ContactsViewController.h
//  ZFContacts
//
//  Created by zhaofei on 2017/2/17.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UITableViewController
@property (nonatomic, strong, readwrite) UISearchBar *searchBar;
@property (nonatomic, strong) id previewingContext;
@end
