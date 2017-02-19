//
//  CustomAvatar.m
//  ZFContacts
//
//  Created by zhaofei on 2017/2/17.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import "CustomAvatar.h"
#import "Masonry.h"

@interface CustomAvatar()

@property (nonatomic, strong, readwrite) UIImageView *avatarView;
@property (nonatomic, strong, readwrite) UILabel *alphabetLabel;
@property (nonatomic, strong, readwrite) UIView *backgroundView;

@end

@implementation CustomAvatar

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.alphabetLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureSubviews];
}

- (UIImageView *)avatarView {
    if (_avatarView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        _avatarView = imageView;
        [self addSubview:_avatarView];
    }
    return _avatarView;
}

- (UILabel *)alphabetLabel {
    if (_alphabetLabel == nil) {
        _alphabetLabel = [[UILabel alloc] init];
        _alphabetLabel.backgroundColor = [UIColor clearColor];
        _alphabetLabel.textAlignment = NSTextAlignmentCenter;
        _alphabetLabel.textColor = [UIColor whiteColor];
        _alphabetLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_alphabetLabel];
    }
    return _alphabetLabel;
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithRed:137/255.0 green:142/255.0 blue:153/255.0 alpha:1];
        _backgroundView.layer.masksToBounds = YES;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (void)configureSubviews {
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.alphabetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    self.avatarView.layer.cornerRadius = self.frame.size.width / 2;
    self.backgroundView.layer.cornerRadius = self.frame.size.width / 2;
}

- (void)setAbbreviatedName:(NSString *)abbreviatedName {
    _abbreviatedName = abbreviatedName;
    self.alphabetLabel.text = abbreviatedName;
    self.avatarView.hidden = YES;
    self.backgroundView.hidden = NO;
    self.alphabetLabel.hidden = NO;
}

- (void)setSourceAvatarImage:(UIImage *)sourceAvatarImage {
    _sourceAvatarImage = sourceAvatarImage;
    self.avatarView.image = sourceAvatarImage;
    self.avatarView.hidden = NO;
    self.backgroundView.hidden = YES;
    self.alphabetLabel.hidden = YES;
}

@end
