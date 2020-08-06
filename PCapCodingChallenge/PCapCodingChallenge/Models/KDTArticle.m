//
//  KDTArticle.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/4/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "KDTArticle.h"

static NSString * const titleKey = @"title";
static NSString * const featuredImageKey = @"featured_image";
static NSString * const summaryKey = @"summary";
static NSString * const contentHTMLKey = @"content_html";

@implementation KDTArticle

- (instancetype)initWithTitle:(NSString *)title featuredImagePath:(NSString *)featuredImagePath summary:(NSString *)summary contentHTML:(NSString *)contentHTML
{
    if (self = [super init])
    {
        _title = title;
        _featuredImagePath = featuredImagePath;
        _summary = summary;
        _contentHTML = contentHTML;
    }
    return self;
}

@end

@implementation KDTArticle (JSONConvertable)

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary
{
    NSString *title = dictionary[titleKey];
    NSString *featuredImagePath = dictionary[featuredImageKey];
    NSString *summary = dictionary[summaryKey];
    NSString *contentHTML = dictionary[contentHTMLKey];
    
    return [self initWithTitle:title featuredImagePath:featuredImagePath summary:summary contentHTML:contentHTML];
}
@end
