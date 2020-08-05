//
//  KDTArticleController.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/5/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "KDTArticleController.h"

static NSString * const baseURLString = @"https://www.personalcapital.com/blog/feed/json";

@implementation KDTArticleController

+ (void)fetchArticlesWithCompletion:(void (^)(NSMutableArray<KDTArticle *> * _Nullable articles))completion
{
    // Base URL: https://www.personalcapital.com/blog/feed/json
    NSURL *finalURL = [NSURL URLWithString:baseURLString];
    // Print URL for testing
    NSLog(@"finalURL: %@", finalURL);
    
    // Data Task
    [[[NSURLSession sharedSession] dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // Handle the error
        if (error)
        {
            NSLog(@"There was an error in %s: %@, %@", __PRETTY_FUNCTION__, error, [error localizedDescription]);
            completion(nil);
            return;
        }
        
        // Handle the response
        if (response)
        {
            NSLog(@"Response: %@", response);
        }
        
        // Handle the data
        if (data)
        {
            NSDictionary *topLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (!topLevelDictionary)
            {
                NSLog(@"Error parsing the JSON: %@", error);
                completion(nil);
                return;
            }

            // Decode
            NSArray *articleEntries = topLevelDictionary[@"items"];
            NSMutableArray<KDTArticle *> *articles = [[NSMutableArray alloc] init];
            
            for (NSDictionary * articleDict in articleEntries)
            {
                KDTArticle *entry = [[KDTArticle alloc] initWithDictionary:articleDict];
                [articles addObject:entry];
            }
            
            completion(articles);
        }
    }]resume];
}

+ (void)fetchImageForArticle:(KDTArticle *)article completion:(void (^)(UIImage * _Nullable image))completion
{
    // URL
    NSURL *imageURL = [NSURL URLWithString:[article featuredImagePath]];
    NSLog(@"%@", imageURL);
    
    [[[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Check for error
        if (error)
        {
            NSLog(@"There was an error in %s: %@, %@", __PRETTY_FUNCTION__, error, [error localizedDescription]);
            completion(nil);
            return;
        }
        
        // Handle the response
        if (response)
        {
            NSLog(@"Response: %@", response);
        }
        
        // Handle the data
        if (!data)
        {
            NSLog(@"%@", error);
            completion(nil);
            return;
        }
        
        // Now we have data
        UIImage *image = [UIImage imageWithData:data];
        completion(image);
        
    }]resume];
}

@end
