//
//  ViewController.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/4/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    [KDTArticleController fetchArticlesWithCompletion:^(NSMutableArray<KDTArticle *> * _Nonnull articles) {
        [[articles objectAtIndex:0] valueForKey:@"title"];
        NSLog(@"%@, %@, %@, %@", [[articles objectAtIndex:0] valueForKey:@"title"], [[articles objectAtIndex:0] valueForKey:@"featuredImagePath"], [[articles objectAtIndex:0] valueForKey:@"summary"], [[articles objectAtIndex:0] valueForKey:@"contentHTML"]);

        [KDTArticleController fetchImageForArticle:[articles objectAtIndex:0] completion:^(UIImage * _Nonnull image) {
            NSLog(@"image: %@", image);
        }];
    }];
}


@end
