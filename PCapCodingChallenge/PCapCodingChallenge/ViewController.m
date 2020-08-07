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
- (void)setupActivityIndicator;
//- (void) setupOrientationNotification;
//- (void) orientationChanged:(NSNotification *)note;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupArticleCollectionView];
    [self setupActivityIndicator];
//    [self setupOrientationNotification];
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
    
    [_articleCollectionView registerClass:[KDTFeaturedArticleCollectionViewCell class] forCellWithReuseIdentifier:featuredArticleCell];
    [_articleCollectionView registerClass:[KDTPreviousArticleCollectionViewCell class] forCellWithReuseIdentifier:previousArticleCell];
    
    [self.view addSubview:_articleCollectionView];
    
    _articleCollectionView.backgroundColor = [UIColor whiteColor];
    
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

// MARK: - Helper Methods

- (void)fetchArticles
{
    [KDTArticleController fetchArticlesWithCompletion:^(NSMutableArray<KDTArticle *> * _Nonnull articles) {
        dispatch_async(dispatch_get_main_queue(), ^ {
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

//- (void) setupOrientationNotification
//{
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter]
//       addObserver:self selector:@selector(orientationChanged:)
//       name:UIDeviceOrientationDidChangeNotification
//       object:[UIDevice currentDevice]];
//}
//
//- (void) orientationChanged:(NSNotification *)note
//{
//    UIDevice * device = note.object;
//    switch(device.orientation)
//    {
//        case UIDeviceOrientationPortrait:
////            [self setupArticleCollectionView];
////            [_articleCollectionView reloadData];
//            break;
//
//        case UIDeviceOrientationLandscapeLeft:
////            [self setupArticleCollectionView];
////            [_articleCollectionView reloadData];
//            break;
//
//        case UIDeviceOrientationLandscapeRight:
////            [self setupArticleCollectionView];
////            [_articleCollectionView reloadData];
//            break;
//
//        default:
////            [self setupArticleCollectionView];
//            break;
//    };
//}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator: (id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.articleCollectionView reloadData];
}

// MARK: - Collection View Methods

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_articleEntries count];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
        KDTFeaturedArticleCollectionViewCell *featuredCell = [collectionView dequeueReusableCellWithReuseIdentifier:featuredArticleCell forIndexPath:indexPath];
        
        [featuredCell configureWithArticle:_articleEntries[indexPath.row]];
        
        return featuredCell;
    }
    else
    {
        KDTPreviousArticleCollectionViewCell *previousCell = [collectionView dequeueReusableCellWithReuseIdentifier:previousArticleCell forIndexPath:indexPath];
        
        [previousCell configureWithArticle:_articleEntries[indexPath.row]];
        
        return previousCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell Index: %ld", (long)indexPath.row);
    
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webConfig];
    
    UINavigationController *webViewNavController = [[UINavigationController alloc] init];
    UINavigationBar *webViewNavBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    
    webViewNavController.view.backgroundColor = [UIColor whiteColor];
    
    [webViewNavController.view addSubview:webView];
    [webViewNavController.view addSubview:webViewNavBar];
    
    UINavigationItem *navTitle = [[UINavigationItem alloc] initWithTitle:[_articleEntries[indexPath.row] title]];
    
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(onTapDismiss)];
    navTitle.rightBarButtonItem = dismissButton;
    
    [webViewNavBar setItems: @[navTitle]];
    
    [webView loadHTMLString:[_articleEntries[indexPath.row] contentHTML] baseURL:nil];

    webView.translatesAutoresizingMaskIntoConstraints = false;
    [webView.topAnchor constraintEqualToAnchor:webViewNavController.view.safeAreaLayoutGuide.topAnchor constant:60].active = true;
    [webView.leadingAnchor constraintEqualToAnchor:webViewNavController.view.safeAreaLayoutGuide.leadingAnchor constant:8].active = true;
    [webView.trailingAnchor constraintEqualToAnchor:webViewNavController.view.safeAreaLayoutGuide.trailingAnchor constant:-8].active = true;
    [webView.bottomAnchor constraintEqualToAnchor:webViewNavController.view.bottomAnchor].active = true;
    
    webViewNavBar.translatesAutoresizingMaskIntoConstraints = false;
    [webViewNavBar.topAnchor constraintEqualToAnchor: webViewNavController.view.topAnchor].active = true;
    [webViewNavBar.leadingAnchor constraintEqualToAnchor:webViewNavController.view.safeAreaLayoutGuide.leadingAnchor constant:0].active = true;
    [webViewNavBar.trailingAnchor constraintEqualToAnchor:webViewNavController.view.safeAreaLayoutGuide.trailingAnchor constant:0].active = true;
    [webViewNavBar.heightAnchor constraintEqualToConstant:44].active = true;
    
    [self presentViewController:webViewNavController animated:false completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/2);
    }
    else
    {
        
        if (self.view.frame.size.height < self.view.frame.size.width)
        {
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                // iPad
                return CGSizeMake(self.view.frame.size.width / 3.25, self.view.frame.size.height / 2.5);
            }else{
                // iPhone
                return CGSizeMake(self.view.frame.size.width / 2.25, self.view.frame.size.height / 2.5);
            }
        }
        else
        {
            if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
                // iPad
                return CGSizeMake((self.view.frame.size.width / 3) - 10, self.view.frame.size.height / 5);
            }else{
                // iPhone
                return CGSizeMake((self.view.frame.size.width / 2) - 10, self.view.frame.size.height / 5);
            }
        }
    }
}

@end
