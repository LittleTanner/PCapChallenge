//
//  KDTFeaturedArticleCollectionViewCell.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "KDTFeaturedArticleCollectionViewCell.h"

@implementation KDTFeaturedArticleCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.featuredImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.featuredImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.featuredImageView];
    
    self.articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.articleTitleLabel];
    
    self.articleSummaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.articleSummaryLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.articleSummaryLabel];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.activityIndicator];
    
    self.activityIndicator.contentMode = UIViewContentModeScaleAspectFit;
    self.activityIndicator.clipsToBounds = true;
    
    self.featuredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.featuredImageView.clipsToBounds = true;
    
    self.articleTitleLabel.numberOfLines = 1;
    [self.articleTitleLabel setFont: [UIFont boldSystemFontOfSize:16]];
    
    self.articleSummaryLabel.numberOfLines = 2;
    self.articleSummaryLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    
    [self.featuredImageView.topAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.topAnchor constant:0].active = true;
    [self.featuredImageView.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:0].active = true;
    [self.featuredImageView.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:0].active = true;
    [self.featuredImageView.bottomAnchor constraintEqualToAnchor:self.articleTitleLabel.topAnchor constant:-8].active = true;
    
    [self.articleTitleLabel.topAnchor constraintEqualToAnchor:self.featuredImageView.bottomAnchor constant:8].active = true;
    [self.articleTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [self.articleTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [self.articleTitleLabel.bottomAnchor constraintEqualToAnchor:self.articleSummaryLabel.topAnchor constant:-4].active = true;
    
    [self.articleSummaryLabel.topAnchor constraintEqualToAnchor:self.articleTitleLabel.bottomAnchor constant:4].active = true;
    [self.articleSummaryLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [self.articleSummaryLabel.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [self.articleSummaryLabel.bottomAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.bottomAnchor constant:-16].active = true;
    
    [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.featuredImageView.centerYAnchor].active = true;
    [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.featuredImageView.centerXAnchor].active = true;
    [self.activityIndicator.heightAnchor constraintEqualToConstant:40].active = true;
    [self.activityIndicator.widthAnchor constraintEqualToConstant:40].active = true;
}

- (void)configureWithArticle: (KDTArticle *)article {
    [self.activityIndicator startAnimating];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    
    [KDTArticleController fetchImageForArticle:article completion:^(UIImage * _Nonnull image) {
        if (image != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.featuredImageView.layer addAnimation:transition forKey:nil];
                self.featuredImageView.image = image;
                self.articleTitleLabel.text = [article title];
                self.articleSummaryLabel.text = [article summary];
                [self.activityIndicator stopAnimating];
            });
        }
    }];
}

@end
