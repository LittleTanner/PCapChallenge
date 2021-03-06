//
//  KDTFeaturedArticleCollectionViewCell.h
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDTArticle.h"
#import "KDTArticleController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDTFeaturedArticleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *featuredImageView;
@property (nonatomic, strong) UILabel *articleTitleLabel;
@property (nonatomic, strong) UILabel *articleSummaryLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (void)setupUI;
- (void)configureWithArticle: (KDTArticle *)article;

@end

NS_ASSUME_NONNULL_END
