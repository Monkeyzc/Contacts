//
//  ContactModel.h
//  ZFContacts
//
//  Created by Zhao Fei on 16/8/25.
//  Copyright © 2016年 ZhaoFei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ContactModel : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@property (nonatomic, strong) UIImage *avatarImage;

@property (nonatomic, copy) NSString *phoneCountryCode;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *firstLetter;
@property (nonatomic, strong, readwrite) NSString *fullName;
@property (nonatomic, strong, readwrite) NSString *abbreviatedName;
@property (nonatomic, strong, readwrite) NSString *searchText;

@end
