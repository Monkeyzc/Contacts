//
//  ZFContactsScan.m
//  ZFContacts
//
//  Created by Zhao Fei on 16/8/25.
//  Copyright © 2016年 ZhaoFei. All rights reserved.
//

#import "ZFContactsScan.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "ContactModel.h"
#import "PinyinHelper.h"
#import "HanyuPinyinOutputFormat.h"
#import "NBPhoneNumberUtil.h"
#import "NBPhoneNumber.h"

@interface ZFContactsScan()
@property (nonatomic, strong) NSMutableArray *allContacts;
@property (nonatomic, strong) HanyuPinyinOutputFormat *pinYinOutputFormat;
@end

@implementation ZFContactsScan

- (NSMutableArray *)allContacts{
    if (!_allContacts) {
        _allContacts = [NSMutableArray array];
    }
    return _allContacts;
}

+ (instancetype)shareInstance {
    static  id shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init{
    if (self == [super init]) {
        HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
        
        self.pinYinOutputFormat = outputFormat;
    }
    return self;
}

- (void)fetchAllContacts:(void (^) (NSArray *))callBack {
    
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"9.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        // OS version >= 9.0
        [self fetchAllContacts_OS_9_0: callBack];
    } else {
        // OS version < 9.0
        [self fetchAllContacts_old_OS: callBack];
    }
}

- (void)fetchAllContacts_OS_9_0 :(void (^) (NSArray *))callBack {
    
    CNContactStore *store = [[CNContactStore alloc] init];
    // request access
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            NSArray *keysToFetch = @[
                                         CNContactFamilyNameKey,
                                         CNContactGivenNameKey,
                                         CNContactPhoneNumbersKey,
                                         CNContactImageDataKey
                                     ];
            CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        
            // fetch all contacts
            [store enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                
                ContactModel *contactModel = [[ContactModel alloc] init];
                
                // get firstName and lastName
                if (contact.givenName) {
                    contactModel.firstName = contact.givenName;
                }
                if (contact.familyName) {
                    contactModel.lastName = contact.familyName;
                }
            
                contactModel.firstLetter = [self fetchFirstLetter: contactModel];
                

                //get image
                UIImage *image = [UIImage imageWithData:contact.imageData];
                if (image) {
                    contactModel.avatarImage = image;
                }
                
                
                NSMutableArray *phoneNumbers = [NSMutableArray array];
                // get phone number
                for (CNLabeledValue *label in contact.phoneNumbers) {
                    if ([label.value stringValue].length) {
                        [phoneNumbers addObject:[label.value stringValue]];
                    }
                }
                
            
                if (phoneNumbers.count) {
                    NSArray *phoneFragments = [self fetchPhoneCountryCodeAndPhoneNumber: phoneNumbers[0]];
                    if (phoneFragments.count) {
                        contactModel.phoneCountryCode = phoneFragments[0];
                        contactModel.phoneNumber = phoneFragments[1];
                    }
                }
                
                if ((contactModel.firstName || contactModel.lastName) && contactModel.phoneCountryCode && contactModel.phoneNumber) {
                    [self.allContacts addObject: contactModel];
                }

            }];
            
            if (callBack) {
                callBack(self.allContacts);
            }
        }
    }];
}

- (void)fetchAllContacts_old_OS :(void (^) (NSArray *))callBack {
    
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        
        CFErrorRef errora = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &errora);
        
        if (addressBook) {
            NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
            
            NSUInteger i = 0;
            for (i = 0; i<[allContacts count]; i++) {
                
                ContactModel *contactModel = [[ContactModel alloc] init];
                
                ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                
                // Get first and last names
                NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                
                // Set Contact properties
                if (firstName) {
                    contactModel.firstName = firstName;
                }
                
                if (lastName) {
                    contactModel.lastName = lastName;
                }
                
                // Get image if it exists
                NSData *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
                contactModel.avatarImage = [UIImage imageWithData:imgData];
                
                contactModel.firstLetter = [self fetchFirstLetter:contactModel];
                
                // Get mobile number
                NSMutableArray *phoneNumbers = [NSMutableArray array];
                
                ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                for (NSInteger i = 0; i < ABMultiValueGetCount(phonesRef); i++) {
                    CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
                    CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
                    
                    NSString *phoneNumber = (__bridge NSString *)currentPhoneValue;
                    
                    if (phoneNumber.length) {
                        [phoneNumbers addObject:phoneNumber];
                    }
                    
                    if(currentPhoneLabel) {
                        CFRelease(currentPhoneLabel);
                    }
                    if(currentPhoneValue) {
                        CFRelease(currentPhoneValue);
                    }
                }
                
                if (phoneNumbers.count) {
                    NSArray *phoneFragments = [self fetchPhoneCountryCodeAndPhoneNumber: phoneNumbers[0]];
                    if (phoneFragments.count) {
                        contactModel.phoneCountryCode = phoneFragments[0];
                        contactModel.phoneNumber = phoneFragments[1];
                    }
                }
                
                if ((contactModel.firstName || contactModel.lastName) && contactModel.phoneCountryCode && contactModel.phoneNumber) {
                    [self.allContacts addObject: contactModel];
                }
                
                if(phonesRef) {
                    CFRelease(phonesRef);
                }
            }
            
            if(addressBook) {
                CFRelease(addressBook);
            }
            
            if (callBack) {
                callBack(self.allContacts);
            }
            
        } else {
            NSLog(@"Error: %@", error);
        }

    });
}

- (NSString *)fetchFirstLetter: (ContactModel *)contactModel{
    NSString *firstLetter;
    NSString *pinyinFirstName = [PinyinHelper toHanyuPinyinStringWithNSString:contactModel.firstName withHanyuPinyinOutputFormat:self.pinYinOutputFormat withNSString:@" "];
    
    NSString *pinyinLastName =  [PinyinHelper toHanyuPinyinStringWithNSString:contactModel.lastName withHanyuPinyinOutputFormat:self.pinYinOutputFormat withNSString:@" "];
    
    if (pinyinFirstName != nil && ![pinyinFirstName isEqualToString:@""]) {
        firstLetter = [pinyinFirstName substringWithRange:NSMakeRange(0, 1)];
    }
    else if(pinyinLastName != nil && ![pinyinLastName isEqualToString:@""]){
        firstLetter = [pinyinLastName substringWithRange:NSMakeRange(0, 1)];
    }
    else{
        firstLetter = @"#";
    }
    return firstLetter.uppercaseString;
}

- (NSArray *)fetchPhoneCountryCodeAndPhoneNumber: (NSString *)phone {
    
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *currentCountryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *localPhoneCountryCode = [NSString stringWithFormat:@"%d", [[phoneUtil getCountryCodeForRegion:currentCountryCode] intValue]];
    NSString *phoneNumber;
    NSString *phoneCountryCode;
    
    if ([phone hasPrefix:@"+"]) {
        NSError *error = nil;
        NBPhoneNumber *nbPhoneNumber = [phoneUtil parse:phone defaultRegion:nil error:&error];
        
        if (!error) {
            phoneNumber = [NSString stringWithFormat:@"%@",nbPhoneNumber.nationalNumber.stringValue];
            phoneCountryCode = [NSString stringWithFormat:@"%@",nbPhoneNumber.countryCode.stringValue];
        }
    }
    else{
        phoneCountryCode = localPhoneCountryCode;
        phoneNumber = [phoneUtil normalizePhoneNumber:phone];
    }
    return (phoneNumber.length && phoneCountryCode.length) ? @[phoneCountryCode, phoneNumber] : nil;
}

@end
