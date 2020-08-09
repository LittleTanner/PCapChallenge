//
//  KDTFeaturedArticleCollectionViewCell.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "KDTFeaturedArticleCollectionViewCell.h"

@implementation KDTFeaturedArticleCollectionViewCell

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
    _featuredImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _featuredImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_featuredImageView];
    
    _articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_articleTitleLabel];
    
    _articleSummaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _articleSummaryLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_articleSummaryLabel];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_activityIndicator];
    
    _activityIndicator.contentMode = UIViewContentModeScaleAspectFit;
    _activityIndicator.clipsToBounds = true;
    
    _featuredImageView.contentMode = UIViewContentModeScaleAspectFill;
    _featuredImageView.clipsToBounds = true;
    
    _articleTitleLabel.numberOfLines = 1;
    [_articleTitleLabel setFont: [UIFont boldSystemFontOfSize:16]];
    
    _articleSummaryLabel.numberOfLines = 2;
    _articleSummaryLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    
    [_featuredImageView.topAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.topAnchor constant:0].active = true;
    [_featuredImageView.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:0].active = true;
    [_featuredImageView.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:0].active = true;
    [_featuredImageView.bottomAnchor constraintEqualToAnchor:_articleTitleLabel.topAnchor constant:-8].active = true;
    
    [_articleTitleLabel.topAnchor constraintEqualToAnchor:_featuredImageView.bottomAnchor constant:8].active = true;
    [_articleTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [_articleTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [_articleTitleLabel.bottomAnchor constraintEqualToAnchor:_articleSummaryLabel.topAnchor constant:-4].active = true;
    
    [_articleSummaryLabel.topAnchor constraintEqualToAnchor:_articleTitleLabel.bottomAnchor constant:4].active = true;
    [_articleSummaryLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [_articleSummaryLabel.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [_articleSummaryLabel.bottomAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.bottomAnchor constant:-16].active = true;
    
    [_activityIndicator.centerYAnchor constraintEqualToAnchor:_featuredImageView.centerYAnchor].active = true;
    [_activityIndicator.centerXAnchor constraintEqualToAnchor:_featuredImageView.centerXAnchor].active = true;
    [_activityIndicator.heightAnchor constraintEqualToConstant:40].active = true;
    [_activityIndicator.widthAnchor constraintEqualToConstant:40].active = true;
}

- (void)configureWithArticle: (KDTArticle *)article
{
    [_activityIndicator startAnimating];
    [KDTArticleController fetchImageForArticle:article completion:^(UIImage * _Nonnull image)
    {
        if (image != nil)
        {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.featuredImageView.image = image;
            self.articleTitleLabel.text = [article title];
            self.articleSummaryLabel.text = [article summary];
            [self.activityIndicator stopAnimating];
        });
        }
    }];
}

@end
