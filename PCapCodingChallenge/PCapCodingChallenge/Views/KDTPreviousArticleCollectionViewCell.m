//
//  KDTPreviousArticleCollectionViewCell.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "KDTPreviousArticleCollectionViewCell.h"

@implementation KDTPreviousArticleCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI
{
    _articleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _articleImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_articleImageView];
    
    _articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_articleTitleLabel];
    
    _articleImageView.contentMode = UIViewContentModeScaleAspectFill;
    _articleImageView.clipsToBounds = true;
    
    _articleTitleLabel.numberOfLines = 2;
    _articleTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    
    [_articleImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:0].active = true;
    [_articleImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:4].active = true;
    [_articleImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-4].active = true;
    [_articleImageView.bottomAnchor constraintEqualToAnchor:_articleTitleLabel.topAnchor constant:-4].active = true;
    
    [_articleTitleLabel.topAnchor constraintEqualToAnchor:_articleImageView.bottomAnchor constant:4].active = true;
    [_articleTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = true;
    [_articleTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = true;
    [_articleTitleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4].active = true;
}

@end
