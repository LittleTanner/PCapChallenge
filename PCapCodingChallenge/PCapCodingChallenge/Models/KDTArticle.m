//
//  KDTArticle.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/4/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "KDTArticle.h"

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

+ (NSArray<KDTArticle *> *)initWithDictionary:(NSDictionary<NSString *,id> *)topLevelDictionary
{
    NSArray *articleEntries = topLevelDictionary[@"items"];
    
    NSMutableArray<KDTArticle *> *articles = [[NSMutableArray alloc] init];
    
    // Needed if items are nil
    if ([articleEntries isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    for (NSDictionary *articleDict in articleEntries)
    {
        NSString *title = articleDict[@"title"];
        NSString *featuredImagePath = articleDict[@"featured_image"];
        NSString *summary = articleDict[@"summary"];
        NSString *contentHTML = articleDict[@"content_hteml"];
        KDTArticle *entry = [[KDTArticle alloc] initWithTitle:title featuredImagePath:featuredImagePath summary:summary contentHTML:contentHTML];
        [articles addObject: entry];
    }
    
    return [articles copy];
}
@end
