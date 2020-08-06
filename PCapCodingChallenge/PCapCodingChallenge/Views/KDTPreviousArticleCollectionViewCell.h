//
//  KDTPreviousArticleCollectionViewCell.h
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/6/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTPreviousArticleCollectionViewCell : UICollectionViewCell

@property (nonatomic) UIImageView *articleImageView;
@property (nonatomic, copy) UILabel *articleTitleLabel;

- (void)setupUI;

@end

NS_ASSUME_NONNULL_END
