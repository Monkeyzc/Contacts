//
//  ContactDetailsController.h
//  ZFContacts
//
//  Created by zhaofei on 2017/2/18.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface ContactDetailsController : UIViewController
@property (nonatomic, strong, readwrite) ContactModel *contact;
@end
