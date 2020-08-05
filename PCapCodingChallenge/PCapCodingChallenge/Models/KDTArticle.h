//
//  KDTArticle.h
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/4/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTArticle : NSObject

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *featuredImagePath;
@property (nonatomic, readonly, copy) NSString *summary;
@property (nonatomic, readonly, copy) NSString *contentHTML;

- (instancetype)initWithTitle: (NSString *)title featuredImagePath: (NSString *)featuredImagePath summary: (NSString *)summary contentHTML: (NSString *)contentHTML;

@end

@interface KDTArticle (JSONConvertable)

- (instancetype)initWithDictionary: (NSDictionary<NSString *, id> *)dictionary;

@end

NS_ASSUME_NONNULL_END
