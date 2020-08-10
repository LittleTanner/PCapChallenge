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
    
    _cellSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    _cellSeparator.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:_cellSeparator];
    
    _activityIndicator.contentMode = UIViewContentModeScaleAspectFit;
    _activityIndicator.clipsToBounds = true;
    
    _articleImageView.contentMode = UIViewContentModeScaleAspectFill;
    _articleImageView.clipsToBounds = true;
    
    _articleTitleLabel.numberOfLines = 2;
    _articleTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    
    _cellSeparator.backgroundColor = [UIColor colorNamed:@"PersonalCapitalBlue"];
    
    [_articleImageView.topAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.topAnchor constant:8].active = true;
    [_articleImageView.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [_articleImageView.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [_articleImageView.bottomAnchor constraintEqualToAnchor:_articleTitleLabel.topAnchor constant:-4].active = true;
    
    [_articleTitleLabel.topAnchor constraintEqualToAnchor:_articleImageView.bottomAnchor constant:4].active = true;
    [_articleTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [_articleTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [_articleTitleLabel.heightAnchor constraintEqualToConstant:34].active = true;
    [_articleTitleLabel.bottomAnchor constraintEqualToAnchor:self.cellSeparator.topAnchor constant:-4].active = true;
    
    [_activityIndicator.centerXAnchor constraintEqualToAnchor:_articleImageView.centerXAnchor].active = true;
    [_activityIndicator.centerYAnchor constraintEqualToAnchor:_articleImageView.centerYAnchor].active = true;
    [_activityIndicator.heightAnchor constraintEqualToConstant:44].active = true;
    [_activityIndicator.widthAnchor constraintEqualToConstant:44].active = true;
    
    [_cellSeparator.topAnchor constraintEqualToAnchor:_articleTitleLabel.bottomAnchor constant:8].active = true;
    [_cellSeparator.widthAnchor constraintEqualToAnchor:_articleImageView.widthAnchor multiplier:0.25].active = true;
    [_cellSeparator.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [_cellSeparator.heightAnchor constraintEqualToConstant:1].active = true;
    [_cellSeparator.bottomAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.bottomAnchor constant:-8].active = true;
}

- (void)configureWithArticle: (KDTArticle *)article
{
    [_activityIndicator startAnimating];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    self.articleImageView.image = nil;
    self.articleTitleLabel.text = nil;
    
    [KDTArticleController fetchImageForArticle:article completion:^(UIImage * _Nonnull image)
    {
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
