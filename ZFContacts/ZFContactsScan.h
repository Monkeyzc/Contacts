//
//  ZFContactsScan.h
//  ZFContacts
//
//  Created by Zhao Fei on 16/8/25.
//  Copyright © 2016年 ZhaoFei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFContactsScan : NSObject

+ (instancetype)shareInstance;
- (void)fetchAllContacts:(void (^) (NSArray *))callBack;
@end
