//
//  ContactModel.m
//  ZFContacts
//
//  Created by Zhao Fei on 16/8/25.
//  Copyright © 2016年 ZhaoFei. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

- (NSString *)fullName {
    if (self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else if (self.firstName) {
        return self.firstName;
    } else if (self.lastName) {
        return self.lastName;
    } else {
        return @"Contact-fullname";
    }
}

- (NSString *)abbreviatedName {
    if (self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@ %@", [self.firstName substringToIndex:1], [self.lastName substringToIndex:1]];
    } else if (self.firstName) {
        return [self.firstName substringToIndex:1];
    } else if (self.lastName) {
        return [self.lastName substringToIndex:1];
    } else {
        return @"H W";
    }
}

- (NSString *)description{
    return [NSString stringWithFormat:@"fristLetter:%@ \n firstName:%@ \n lastName:%@ \n phoneNumber:%@ \n phoneCountryCode:%@ \n email:%@ \n avatarImage:%@ \n", _firstLetter, _firstName, _lastName, _phoneNumber, _phoneCountryCode, _email, _avatarImage];
}
@end
