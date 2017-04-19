//
//  ContactModel.m
//  ZFContacts
//
//  Created by Zhao Fei on 16/8/25.
//  Copyright © 2016年 ZhaoFei. All rights reserved.
//

#import "ContactModel.h"
#import "HanyuPinyinOutputFormat.h"
#import "PinyinHelper.h"

@implementation ContactModel

- (NSString *)fullName {
    if (!_fullName) {
        if (self.firstName && self.lastName) {
            _fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
        } else if (self.firstName) {
            _fullName = self.firstName;
        } else if (self.lastName) {
            _fullName = self.lastName;
        } else {
            _fullName = @"Contact-fullname";
        }
    }
    return _fullName;
}

- (NSString *)abbreviatedName {
    if (!_abbreviatedName) {
        if (self.firstName.length && self.lastName.length) {
            _abbreviatedName = [NSString stringWithFormat:@"%@ %@", [self.firstName substringToIndex:1], [self.lastName substringToIndex:1]];
        } else if (self.firstName.length) {
            _abbreviatedName = [self.firstName substringToIndex:1];
        } else if (self.lastName.length) {
            _abbreviatedName = [self.lastName substringToIndex:1];
        } else {
            _abbreviatedName = @"#";
        }
    }
    return _abbreviatedName;
}

- (NSString *)firstLetter {
    if (!_firstLetter) {
        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
        
        NSString *outputPinyin= [PinyinHelper toHanyuPinyinStringWithNSString:self.abbreviatedName withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
        _firstLetter = [[outputPinyin substringToIndex:1] uppercaseString];
    }
    return _firstLetter;
}

- (NSString *)searchText {
    if (!_searchText) {
        _searchText = [NSString stringWithFormat:@"%@%@%@", self.firstName ? self.firstName : @"", self.lastName ? self.lastName : @"", self.phoneNumber ? self.phoneNumber : @""];
    }
    return _searchText;
}

//- (NSString *)description{
//    return [NSString stringWithFormat:@"fristLetter:%@ \n firstName:%@ \n lastName:%@ \n phoneNumber:%@ \n phoneCountryCode:%@ \n email:%@ \n avatarImage:%@ \n", _firstLetter, _firstName, _lastName, _phoneNumber, _phoneCountryCode, _email, _avatarImage];
//}
@end
