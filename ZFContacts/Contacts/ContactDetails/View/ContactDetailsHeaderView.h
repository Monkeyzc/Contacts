//
//  ContactDetailsHeaderView.h
//  ZFContacts
//
//  Created by zhaofei on 2017/2/18.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

#define StatusBarHeight 20
#define NavigationBarHeight 44
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define originalHeight 200
#define reserveHeight 100
#define avtartSize 60
#define fullNameFontSize 18

@interface ContactDetailsHeaderView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) ContactModel *contact;

@end
