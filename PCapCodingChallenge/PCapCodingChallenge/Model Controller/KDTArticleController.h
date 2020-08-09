//
//  KDTArticleController.h
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/5/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDTArticle.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTArticleController : NSObject

+ (void)fetchArticlesWithCompletion:(void (^)(NSString *feedTitle, NSMutableArray<KDTArticle *> *articles))completion;

+ (void)fetchImageForArticle: (KDTArticle *)article completion: (void (^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
