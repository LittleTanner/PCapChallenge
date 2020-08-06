//
//  ViewController.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/4/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "ViewController.h"
#import "KDTArticleCollectionView.h"
#import "KDTFeaturedArticleCollectionViewCell.h"
#import "KDTPreviousArticleCollectionViewCell.h"

static NSString * const featuredArticleCell = @"featuredArticleCell";
static NSString * const previousArticleCell = @"previousArticleCell";

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) KDTArticleCollectionView *articleCollectionView;
@property (nonatomic, readwrite) NSMutableArray *articleEntries;
@property (nonatomic, readwrite) NSMutableArray *articleImages;

- (void) fetchArticles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *articleCollectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _articleCollectionView = [[KDTArticleCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:articleCollectionFlowLayout];
    _articleCollectionView.delegate = self;
    _articleCollectionView.dataSource = self;
    
    [_articleCollectionView registerClass:[KDTFeaturedArticleCollectionViewCell class] forCellWithReuseIdentifier:featuredArticleCell];
    [_articleCollectionView registerClass:[KDTPreviousArticleCollectionViewCell class] forCellWithReuseIdentifier:previousArticleCell];
    
    [self.view addSubview:_articleCollectionView];
    
    _articleCollectionView.backgroundColor = [UIColor whiteColor];
    
    _articleCollectionView.translatesAutoresizingMaskIntoConstraints = false;
    [_articleCollectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = true;
    [_articleCollectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = true;
    [_articleCollectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = true;
    [_articleCollectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = true;
    
    [self fetchArticles];
}


// MARK: - Helper Methods

- (void)fetchArticles
{
    [KDTArticleController fetchArticlesWithCompletion:^(NSMutableArray<KDTArticle *> * _Nonnull articles) {

            self.articleEntries = articles;
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self.articleCollectionView reloadData];
            });
        }];
}

// MARK: - Collection View Methods

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_articleEntries count];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
        KDTFeaturedArticleCollectionViewCell *featuredCell = [collectionView dequeueReusableCellWithReuseIdentifier:featuredArticleCell forIndexPath:indexPath];
        
        [KDTArticleController fetchImageForArticle:[_articleEntries objectAtIndex:indexPath.row] completion:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [featuredCell featuredImageView].image = image;
            });
        }];
        
        [featuredCell articleTitleLabel].text = [_articleEntries[indexPath.row] title];
        [featuredCell articleSummaryLabel].text = [_articleEntries[indexPath.row] summary];

        return featuredCell;
    }
    else
    {
        KDTPreviousArticleCollectionViewCell *previousCell = [collectionView dequeueReusableCellWithReuseIdentifier:previousArticleCell forIndexPath:indexPath];
        
        [KDTArticleController fetchImageForArticle:[_articleEntries objectAtIndex:indexPath.row] completion:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [previousCell articleImageView].image = image;
            });
        }];
        
        [previousCell articleTitleLabel].text = [_articleEntries[indexPath.row] title];
        
        return previousCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/2.25);
    }
    else
    {
        return CGSizeMake(self.view.frame.size.width / 2.1, self.view.frame.size.height / 5);
    }
}

@end
