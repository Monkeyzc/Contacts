//
//  ContactCell.h
//  ZFContacts
//
//  Created by zhaofei on 2017/2/17.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface ContactCell : UITableViewCell

@property (nonatomic, strong, readwrite) ContactModel *contact;

+ (instancetype)contactCellWithTableView: (UITableView *)tableView;

@end
