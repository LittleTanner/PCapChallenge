//
//  MainViewController.m
//  PCapCodingChallenge
//
//  Created by Kevin Tanner on 8/4/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

#import "MainViewController.h"
#import "KDTFeaturedArticleCollectionViewCell.h"
#import "KDTPreviousArticleCollectionViewCell.h"
#import <WebKit/WebKit.h>

static NSString * const featuredArticleCell = @"featuredArticleCell";
static NSString * const previousArticleCell = @"previousArticleCell";

@interface MainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *articleCollectionView;
@property (nonatomic, readwrite) NSMutableArray *articleEntries;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

- (void)fetchArticles;
- (void)setupArticleCollectionView;
- (void)onTapDismiss;
- (void)onTapRefresh;
- (void)setupActivityIndicator;
- (void)setupNavigationBar;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNavigationBar];
    [self setupArticleCollectionView];
    [self setupActivityIndicator];
    [self.activityIndicator startAnimating];
    [self fetchArticles];
}

// MARK: - UI Helper Methods

- (void) setupArticleCollectionView
{
    UICollectionViewFlowLayout *articleCollectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.articleCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:articleCollectionFlowLayout];
    self.articleCollectionView.delegate = self;
    self.articleCollectionView.dataSource = self;
    self.articleCollectionView.clipsToBounds = false;
    
    articleCollectionFlowLayout.minimumLineSpacing = 0;
    articleCollectionFlowLayout.minimumInteritemSpacing = 0;
    
    [self.articleCollectionView registerClass:[KDTFeaturedArticleCollectionViewCell class] forCellWithReuseIdentifier:featuredArticleCell];
    [self.articleCollectionView registerClass:[KDTPreviousArticleCollectionViewCell class] forCellWithReuseIdentifier:previousArticleCell];
    
    [self.view addSubview:_articleCollectionView];
    
    self.articleCollectionView.backgroundColor = [UIColor systemBackgroundColor];
    
    self.articleCollectionView.translatesAutoresizingMaskIntoConstraints = false;
    [self.articleCollectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = true;
    [self.articleCollectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0].active = true;
    [self.articleCollectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0].active = true;
    [self.articleCollectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = true;
}

- (void)setupActivityIndicator
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.activityIndicator];
    
    self.activityIndicator.contentMode = UIViewContentModeScaleAspectFit;
    self.activityIndicator.clipsToBounds = true;
    
    [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [self.activityIndicator.heightAnchor constraintEqualToConstant:40].active = true;
    [self.activityIndicator.widthAnchor constraintEqualToConstant:40].active = true;
}

- (void)setupNavigationBar
{
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.clockwise"] style:UIBarButtonItemStylePlain target:self action:@selector(onTapRefresh)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorNamed:@"PersonalCapitalBlue"];
}

// MARK: - Helper Methods

- (void)fetchArticles
{
    self.articleEntries = nil;
    [self.navigationItem.rightBarButtonItem setEnabled:false];
    
    [KDTArticleController fetchArticlesWithCompletion:^(NSString *feedTitle, NSMutableArray<KDTArticle *> * _Nonnull articles)
     {
        if (self.articleEntries == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^ {
                self.navigationItem.title = feedTitle;
                self.articleEntries = articles;
                [self.articleCollectionView reloadData];
                [self.activityIndicator stopAnimating];
                [self.navigationItem.rightBarButtonItem setEnabled:true];
            });
        }
    }];
}

- (void)onTapDismiss
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onTapRefresh
{
    [self.activityIndicator startAnimating];
    [self fetchArticles];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator: (id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.articleCollectionView reloadData];
}

// MARK: - Collection View Methods

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.articleEntries count])
    {
        return [self.articleEntries count];
    }
    else
    {
        return 10;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        KDTFeaturedArticleCollectionViewCell *featuredCell = [collectionView dequeueReusableCellWithReuseIdentifier:featuredArticleCell forIndexPath:indexPath];
        
        [featuredCell configureWithArticle:self.articleEntries[indexPath.item]];
        
        return featuredCell;
    }
    else
    {
        KDTPreviousArticleCollectionViewCell *previousCell = [collectionView dequeueReusableCellWithReuseIdentifier:previousArticleCell forIndexPath:indexPath];
        
        [previousCell configureWithArticle:self.articleEntries[indexPath.item]];
        
        return previousCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webConfig];
    
    UIViewController *webViewController = [[UIViewController alloc] init];
    UINavigationController *webViewNavController = [[UINavigationController alloc] initWithRootViewController:webViewController];

    webViewNavController.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [webViewController.view addSubview:webView];
    
    webViewController.title = [self.articleEntries[indexPath.item] title];
    
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(onTapDismiss)];
    dismissButton.tintColor = [UIColor colorNamed:@"PersonalCapitalBlue"];
    webViewController.navigationItem.rightBarButtonItem = dismissButton;
    
    [webView loadHTMLString:[self.articleEntries[indexPath.item] contentHTML] baseURL:nil];

    webView.translatesAutoresizingMaskIntoConstraints = false;
    [webView.topAnchor constraintEqualToAnchor:webViewController.view.safeAreaLayoutGuide.topAnchor constant:0].active = true;
    [webView.leadingAnchor constraintEqualToAnchor:webViewController.view.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [webView.trailingAnchor constraintEqualToAnchor:webViewController.view.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [webView.bottomAnchor constraintEqualToAnchor:webViewController.view.bottomAnchor].active = true;
    
    [self presentViewController:webViewNavController animated:false completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Featured Article
    if (indexPath.item == 0)
    {
        // Landscape Mode
        if (self.view.frame.size.height < self.view.frame.size.width)
        {
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
            {
                // iPad
                return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height / 1.5);
            }
            else
            {
                // iPhone
                return CGSizeMake(self.view.safeAreaLayoutGuide.layoutFrame.size.width, self.view.frame.size.height / 1.1);
            }
        }
        // Portrait Mode
        else
        {
            return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height / 2);
        }
        
    }
    // Previous Articles
    else
    {
        // Landscape Mode
        if (self.view.frame.size.height < self.view.frame.size.width)
        {
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
            {
                // iPad
                return CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.height / 2.5);
            }
            else
            {
                // iPhone
                return CGSizeMake((self.view.frame.size.width / 2.25) - 10, self.view.frame.size.height / 1.5);
            }
        }
        // Portrait Mode
        else
        {
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
            {
                // iPad
                return CGSizeMake((self.view.frame.size.width / 3), self.view.frame.size.height / 5);
            }
            else
            {
                // iPhone
                return CGSizeMake((self.view.frame.size.width / 2), self.view.frame.size.height / 5);
            }
        }
    }
}

@end
