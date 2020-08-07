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
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_activityIndicator];
    
    _activityIndicator.contentMode = UIViewContentModeScaleAspectFit;
    _activityIndicator.clipsToBounds = true;
    
    _articleImageView.contentMode = UIViewContentModeScaleAspectFill;
    _articleImageView.clipsToBounds = true;
    
    _articleTitleLabel.numberOfLines = 2;
    _articleTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    
    [_articleImageView.topAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.topAnchor constant:0].active = true;
    [_articleImageView.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [_articleImageView.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [_articleImageView.bottomAnchor constraintEqualToAnchor:_articleTitleLabel.topAnchor constant:-4].active = true;
    
    [_articleTitleLabel.topAnchor constraintEqualToAnchor:_articleImageView.bottomAnchor constant:4].active = true;
    [_articleTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:12].active = true;
    [_articleTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-12].active = true;
    [_articleTitleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.bottomAnchor constant:-4].active = true;
}

- (void)configureWithArticle: (KDTArticle *)article
{
    [_activityIndicator startAnimating];
    [KDTArticleController fetchImageForArticle:article completion:^(UIImage * _Nonnull image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.articleImageView.image = image;
            self.articleTitleLabel.text = [article title];
            [self.activityIndicator stopAnimating];
        });
    }];
}

@end
