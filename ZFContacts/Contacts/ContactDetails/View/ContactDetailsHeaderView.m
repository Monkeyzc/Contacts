//
//  ContactDetailsHeaderView.m
//  ZFContacts
//
//  Created by zhaofei on 2017/2/18.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import "ContactDetailsHeaderView.h"
#import "Masonry.h"
#import "CustomAvatar.h"

@interface ContactDetailsHeaderView()
@property (nonatomic, strong, readwrite) CustomAvatar *avatarView;
@property (nonatomic, strong, readwrite) UILabel *fullNameLabel;
@property (nonatomic, strong, readwrite) UIImageView *backgroundView;
@end

@implementation ContactDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
//        self.backgroundColor = [UIColor purpleColor];
        [self addSubview: self.backgroundView];
        [self addSubview: self.avatarView];
        [self addSubview: self.fullNameLabel];
        
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.leading.equalTo(self).offset(0);
            make.trailing.equalTo(self).offset(0);
            make.bottom.equalTo(self);
        }];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(StatusBarHeight + NavigationBarHeight);
            make.width.equalTo(@(avtartSize));
            make.height.equalTo(@(avtartSize));
        }];
        
        [self.fullNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.avatarView.mas_bottom).offset(8);
        }];
    }
    return self;
}

- (CustomAvatar *)avatarView {
    if (_avatarView == nil) {
        _avatarView = [[CustomAvatar alloc] init];
    }
    return _avatarView;
}

- (UILabel *)fullNameLabel {
    if (_fullNameLabel == nil) {
        _fullNameLabel = [[UILabel alloc] init];
        _fullNameLabel.textColor = [UIColor whiteColor];
        _fullNameLabel.font = [UIFont boldSystemFontOfSize: fullNameFontSize];
    }
    return _fullNameLabel;
}

- (UIImageView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.image = [UIImage imageNamed:@"bg"];
        
    }
    return _backgroundView;
}

- (void)setContact:(ContactModel *)contact {
    _contact = contact;
    if (contact.avatarImage) {
        self.avatarView.sourceAvatarImage = contact.avatarImage;
    } else {
        self.avatarView.abbreviatedName = contact.abbreviatedName;
    }
    self.fullNameLabel.text = contact.fullName;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.scrollView.contentInset = UIEdgeInsetsMake(originalHeight, 0, 0, 0);
    [self.scrollView addObserver: self forKeyPath: @"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeFromSuperview {
    [self.scrollView removeObserver: self forKeyPath: @"contentOffset"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGPoint newContentOffset = [[change objectForKey: NSKeyValueChangeNewKey] CGPointValue];
    if (newContentOffset.y != 0) {
        [self updateViewsLayout: newContentOffset];
    }
}

- (void)updateViewsLayout:(CGPoint)newContentOffset {
    CGFloat offset_Y = newContentOffset.y + self.scrollView.contentInset.top - (StatusBarHeight + NavigationBarHeight);
    NSLog(@"偏移量: %f", offset_Y);

    // 计算偏移量
    if (offset_Y < 0) {
//        NSLog(@"下拉");
        
        self.frame = CGRectMake(0, 0, ScreenWidth, originalHeight - offset_Y);
        
        CGFloat bgScale = offset_Y + StatusBarHeight + NavigationBarHeight;
        self.backgroundView.contentMode = UIViewContentModeScaleToFill;
        
        [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(bgScale < 0 ? bgScale * 0.5 : -bgScale * 0.5);
            make.leading.equalTo(self).offset(bgScale < 0 ? bgScale * 0.5 : -bgScale * 0.5);
            make.trailing.equalTo(self).offset(bgScale < 0 ? -bgScale * 0.5 : bgScale * 0.5);
        }];
        
    } else if (offset_Y > 0 && offset_Y <= originalHeight - reserveHeight) {
        self.frame = CGRectMake(0, 0, ScreenWidth, originalHeight - offset_Y);
    
        CGFloat scale = 1 - offset_Y / originalHeight;
        CGFloat avtartSizeChanged = avtartSize * scale > NavigationBarHeight ? avtartSize * scale : NavigationBarHeight;
        [self.avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(StatusBarHeight + NavigationBarHeight - offset_Y > StatusBarHeight ?  StatusBarHeight + NavigationBarHeight - offset_Y : StatusBarHeight);
            make.width.equalTo(@(avtartSizeChanged));
            make.height.equalTo(@(avtartSizeChanged));
        }];
        
        self.fullNameLabel.font = [UIFont boldSystemFontOfSize: fullNameFontSize * scale > 14 ? fullNameFontSize * scale : 14];
        
    }
}
@end
