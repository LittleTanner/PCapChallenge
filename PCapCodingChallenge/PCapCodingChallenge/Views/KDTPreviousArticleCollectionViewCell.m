//
//  KDTPreviousArticleCollectionViewCell.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "KDTPreviousArticleCollectionViewCell.h"

@implementation KDTPreviousArticleCollectionViewCell

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
    self.articleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.articleImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.articleImageView];
    
    self.articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.articleTitleLabel];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.activityIndicator];
    
    self.cellSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    self.cellSeparator.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.cellSeparator];
    
    self.activityIndicator.contentMode = UIViewContentModeScaleAspectFit;
    self.activityIndicator.clipsToBounds = true;
    
    self.articleImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.articleImageView.clipsToBounds = true;
    
    self.articleTitleLabel.numberOfLines = 2;
    self.articleTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    
    self.cellSeparator.backgroundColor = [UIColor colorNamed:@"PersonalCapitalBlue"];
    
    [self.articleImageView.topAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.topAnchor constant:8].active = true;
    [self.articleImageView.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [self.articleImageView.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [self.articleImageView.bottomAnchor constraintEqualToAnchor:self.articleTitleLabel.topAnchor constant:-4].active = true;
    
    [self.articleTitleLabel.topAnchor constraintEqualToAnchor:self.articleImageView.bottomAnchor constant:4].active = true;
    [self.articleTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [self.articleTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [self.articleTitleLabel.heightAnchor constraintEqualToConstant:34].active = true;
    [self.articleTitleLabel.bottomAnchor constraintEqualToAnchor:self.cellSeparator.topAnchor constant:-4].active = true;
    
    [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.articleImageView.centerXAnchor].active = true;
    [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.articleImageView.centerYAnchor].active = true;
    [self.activityIndicator.heightAnchor constraintEqualToConstant:44].active = true;
    [self.activityIndicator.widthAnchor constraintEqualToConstant:44].active = true;
    
    [self.cellSeparator.topAnchor constraintEqualToAnchor:self.articleTitleLabel.bottomAnchor constant:8].active = true;
    [self.cellSeparator.widthAnchor constraintEqualToAnchor:self.articleImageView.widthAnchor multiplier:0.25].active = true;
    [self.cellSeparator.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [self.cellSeparator.heightAnchor constraintEqualToConstant:1].active = true;
    [self.cellSeparator.bottomAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.bottomAnchor constant:-8].active = true;
}

- (void)configureWithArticle: (KDTArticle *)article {
    [self.activityIndicator startAnimating];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    self.articleImageView.image = nil;
    self.articleTitleLabel.text = nil;
    
    [KDTArticleController fetchImageForArticle:article completion:^(UIImage * _Nonnull image) {
        if (image != nil)
        {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.articleImageView.layer addAnimation:transition forKey:nil];
            self.articleImageView.image = image;
            self.articleTitleLabel.text = [article title];
            [self.activityIndicator stopAnimating];
        });
        }
    }];
}

@end
