//
//  ContactCell.m
//  ZFContacts
//
//  Created by zhaofei on 2017/2/17.
//  Copyright © 2017年 ZhaoFei. All rights reserved.
//

#import "ContactCell.h"
#import "Masonry.h"
#import "CustomAvatar.h"

CGFloat avatarSize = 40;

static NSString *reuseIdentifier = @"contact_cell";

@interface ContactCell()

@property (nonatomic, strong, readwrite) UILabel *fullNameLabel;
@property (nonatomic, strong, readwrite) UILabel *phoneLabel;
@property (nonatomic, strong, readwrite) UILabel *emailLabel;
@property (nonatomic, strong, readwrite) CustomAvatar *defaultAvatarView;

@end

@implementation ContactCell

+ (instancetype)contactCellWithTableView: (UITableView *)tableView {
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureSubViews];
}

- (UILabel *)fullNameLabel {
    if (_fullNameLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _fullNameLabel = label;
        [self.contentView addSubview:_fullNameLabel];
    }
    return _fullNameLabel;
}

- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        UILabel *label= [[UILabel alloc] init];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14];
        _phoneLabel = label;
        [self.contentView addSubview:_phoneLabel];
    }
    return _phoneLabel;
}

- (UILabel *)emailLabel {
    if (_emailLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _emailLabel = label;
        [self.contentView addSubview:_emailLabel];
    }
    return _emailLabel;
}

- (CustomAvatar *)defaultAvatarView {
    if (_defaultAvatarView == nil) {
        _defaultAvatarView = [[CustomAvatar alloc] init];
        [self.contentView addSubview:_defaultAvatarView];
    }
    return _defaultAvatarView;
}

- (void)configureSubViews {

    [self.defaultAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(8);
        make.width.equalTo(@(avatarSize));
        make.height.equalTo(@(avatarSize));
    }];
    
    [self.fullNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.leading.equalTo(self.contentView).offset(avatarSize + 16);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fullNameLabel.mas_bottom).offset(8);
        make.leading.equalTo(self.fullNameLabel);
    }];
    
}

- (void)setContact:(ContactModel *)contact {
    _contact = contact;
    if (contact.avatarImage) {
        self.defaultAvatarView.sourceAvatarImage = contact.avatarImage;
    } else {
        self.defaultAvatarView.abbreviatedName = contact.abbreviatedName;
    }
    self.fullNameLabel.text = contact.fullName;
    self.phoneLabel.text = contact.phoneNumber;
}

@end
