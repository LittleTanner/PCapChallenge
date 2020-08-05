//
//  ViewController.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/4/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, readwrite) NSMutableArray *articleEntries;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame: self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = [UIColor blueColor];
    [KDTArticleController fetchArticlesWithCompletion:^(NSMutableArray<KDTArticle *> * _Nonnull articles) {
        [[articles objectAtIndex:0] valueForKey:@"title"];
        NSLog(@"%@, %@, %@, %@", [[articles objectAtIndex:0] valueForKey:@"title"], [[articles objectAtIndex:0] valueForKey:@"featuredImagePath"], [[articles objectAtIndex:0] valueForKey:@"summary"], [[articles objectAtIndex:0] valueForKey:@"contentHTML"]);

        self.articleEntries = articles;
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.tableView reloadData];
        });
        [KDTArticleController fetchImageForArticle:[articles objectAtIndex:0] completion:^(UIImage * _Nonnull image) {
            NSLog(@"image: %@", image);
        }];
    }];
}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundView = [[UIView alloc] init];
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        cell.textLabel.text = [[self.articleEntries objectAtIndex:indexPath.row] valueForKey:@"title"];
    });
    
    [KDTArticleController fetchImageForArticle:[_articleEntries objectAtIndex:0] completion:^(UIImage * _Nonnull image) {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
            cell.imageView.image = image;
        });
    }];
    
    return cell;
}



@end
