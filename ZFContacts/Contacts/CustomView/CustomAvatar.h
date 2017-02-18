//
//  CustomAvatar.h
//  ZFContacts
//
//  Created by zhaofei on 2017/2/17.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAvatar : UIView
@property (nonatomic, strong, readwrite) UIImage *sourceAvatarImage;
@property (nonatomic, strong, readwrite) NSString *abbreviatedName;
@end
