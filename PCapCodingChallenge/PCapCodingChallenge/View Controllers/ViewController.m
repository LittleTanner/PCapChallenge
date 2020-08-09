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
#import <WebKit/WebKit.h>

static NSString * const featuredArticleCell = @"featuredArticleCell";
static NSString * const previousArticleCell = @"previousArticleCell";

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) KDTArticleCollectionView *articleCollectionView;
@property (nonatomic, readwrite) NSMutableArray *articleEntries;
@property (nonatomic, readwrite) NSMutableArray *articleImages;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

- (void)fetchArticles;
- (void)setupArticleCollectionView;
- (void)onTapDismiss;
- (void)onTapRefresh;
- (void)setupActivityIndicator;
- (void)setupNavigationBar;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNavigationBar];
    [self setupArticleCollectionView];
    [self setupActivityIndicator];
    [_activityIndicator startAnimating];
    [self fetchArticles];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_articleCollectionView reloadData];
}

// MARK: - UI Helper Methods

- (void) setupArticleCollectionView
{
    UICollectionViewFlowLayout *articleCollectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _articleCollectionView = [[KDTArticleCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:articleCollectionFlowLayout];
    _articleCollectionView.delegate = self;
    _articleCollectionView.dataSource = self;
    _articleCollectionView.clipsToBounds = false;
    
    articleCollectionFlowLayout.minimumLineSpacing = 0;
    articleCollectionFlowLayout.minimumInteritemSpacing = 0;
    
    [_articleCollectionView registerClass:[KDTFeaturedArticleCollectionViewCell class] forCellWithReuseIdentifier:featuredArticleCell];
    [_articleCollectionView registerClass:[KDTPreviousArticleCollectionViewCell class] forCellWithReuseIdentifier:previousArticleCell];
    
    [self.view addSubview:_articleCollectionView];
    
    _articleCollectionView.backgroundColor = [UIColor systemBackgroundColor];
    
    _articleCollectionView.translatesAutoresizingMaskIntoConstraints = false;
    [_articleCollectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = true;
    [_articleCollectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:0].active = true;
    [_articleCollectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:0].active = true;
    [_articleCollectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = true;
}

- (void)setupActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _activityIndicator.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:_activityIndicator];
    
    _activityIndicator.contentMode = UIViewContentModeScaleAspectFit;
    _activityIndicator.clipsToBounds = true;
    
    [_activityIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [_activityIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [_activityIndicator.heightAnchor constraintEqualToConstant:40].active = true;
    [_activityIndicator.widthAnchor constraintEqualToConstant:40].active = true;
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
    [KDTArticleController fetchArticlesWithCompletion:^(NSString *feedTitle, NSMutableArray<KDTArticle *> * _Nonnull articles)
    {
        dispatch_async(dispatch_get_main_queue(), ^ {
            self.navigationItem.title = feedTitle;
            self.articleEntries = articles;
            [self.articleCollectionView reloadData];
            NSLog(@"Fetched Articles");
            [self.activityIndicator stopAnimating];
        });
    }];
}

- (void)onTapDismiss
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onTapRefresh
{
    [_activityIndicator startAnimating];
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
    return [_articleEntries count];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        KDTFeaturedArticleCollectionViewCell *featuredCell = [collectionView dequeueReusableCellWithReuseIdentifier:featuredArticleCell forIndexPath:indexPath];
        
        [featuredCell configureWithArticle:_articleEntries[indexPath.item]];
        
        return featuredCell;
    }
    else
    {
        KDTPreviousArticleCollectionViewCell *previousCell = [collectionView dequeueReusableCellWithReuseIdentifier:previousArticleCell forIndexPath:indexPath];
        
        [previousCell configureWithArticle:_articleEntries[indexPath.item]];
        
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
    
    webViewController.title = [_articleEntries[indexPath.item] title];
    
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(onTapDismiss)];
    dismissButton.tintColor = [UIColor colorNamed:@"PersonalCapitalBlue"];
    webViewController.navigationItem.rightBarButtonItem = dismissButton;
    
    [webView loadHTMLString:[_articleEntries[indexPath.item] contentHTML] baseURL:nil];

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
                return CGSizeMake((self.view.frame.size.width / 2.25) - 10, self.view.frame.size.height / 2.5);
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
