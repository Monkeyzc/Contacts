//
//  ContactModel.m
//  ZFContacts
//
//  Created by Zhao Fei on 16/8/25.
//  Copyright © 2016年 ZhaoFei. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel
- (NSString *)description{
    return [NSString stringWithFormat:@"fristLetter:%@ \n firstName:%@ \n lastName:%@ \n phoneNumber:%@ \n phoneCountryCode:%@ \n email:%@ \n avatarImage:%@ \n", _firstLetter, _firstName, _lastName, _phoneNumber, _phoneCountryCode, _email, _avatarImage];
}
@end
