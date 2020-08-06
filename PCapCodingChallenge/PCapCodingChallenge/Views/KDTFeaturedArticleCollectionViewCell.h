//
//  KDTFeaturedArticleCollectionViewCell.h
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTFeaturedArticleCollectionViewCell : UICollectionViewCell

@property (nonatomic) UIImageView *featuredImageView;
@property (nonatomic, copy) UILabel *articleTitleLabel;
@property (nonatomic, copy) UILabel *articleSummaryLabel;

- (void)setupUI;

@end

NS_ASSUME_NONNULL_END
