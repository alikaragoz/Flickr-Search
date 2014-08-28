//
//  AISearchCollectionViewController.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "AISearchCollectionViewController.h"

#import <KZAsserts.h>

#import "AIHistoryTableViewController.h"
#import "AICollectionViewCell.h"
#import "AILoadingViewCell.h"
#import "AIHistoryManager.h"
#import "AISearchClient.h"
#import "AIImageResult.h"

@interface AISearchCollectionViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalPages;

@property (nonatomic, copy) NSString *searchTerm;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *imageResults;
@property (nonatomic, strong) UIView *searchDarkOverlay;

@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation AISearchCollectionViewController

#pragma mark - UIViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Flickr Search";
    id topGuide = self.topLayoutGuide;
    
    // Search Bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.delegate = self;
    self.searchBar.showsBookmarkButton = YES;
    self.searchBar.placeholder = @"Search";
    [self.searchBar becomeFirstResponder];
    [self.view addSubview:self.searchBar];
    
    // Collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = AICollectionViewCellSize;
    flowLayout.minimumLineSpacing = 5.0;
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:AICollectionViewCell.class forCellWithReuseIdentifier:AICollectionViewCellIndentifier];
    [self.collectionView registerClass:AILoadingViewCell.class forCellWithReuseIdentifier:AILoadingViewCellIndentifier];
    
    // Search overlay
    self.searchDarkOverlay = [[UIView alloc] init];
    self.searchDarkOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchDarkOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    self.searchDarkOverlay.userInteractionEnabled = YES;
    self.searchDarkOverlay.alpha = 0.0;
    [self.view addSubview:self.searchDarkOverlay];
    
    UITapGestureRecognizer *tapGestureReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endSearch)];
    tapGestureReco.cancelsTouchesInView = NO;
    [self.searchDarkOverlay addGestureRecognizer:tapGestureReco];
    
    // Search overlay
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.hintLabel.backgroundColor = [UIColor clearColor];
    self.hintLabel.font = [UIFont fontWithName:@"Avenir" size:24.0];
    self.hintLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.numberOfLines = 2.0;
    [self.view addSubview:self.hintLabel];
    
    // Constraints
    NSDictionary *views = @{
        @"searchBar" : self.searchBar,
        @"collectionView" : self.collectionView,
        @"searchDarkOverlay" : self.searchDarkOverlay,
        @"hintLabel" : self.hintLabel,
        @"topGuide" : topGuide
    };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide][searchBar(44)][collectionView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchDarkOverlay]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchBar][searchDarkOverlay]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[hintLabel]-10-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchBar]-10-[hintLabel]-10-|" options:0 metrics:nil views:views]];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self beginSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self endSearch];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    [self endSearch];
    
    AIHistoryTableViewController *historyTableViewController = [[AIHistoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    historyTableViewController.sourceSearchCollectionViewController = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:historyTableViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self endSearch];
    self.searchTerm = searchBar.text;
    
    // Resetting
    self.imageResults = nil;
    self.currentPage = 1;
    self.totalPages = 0;
    [self.collectionView reloadData];
    
    [self fetchImagesWithText:self.searchTerm];
    [[AIHistoryManager sharedInstance] addSearchedTerm:self.searchTerm];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.imageResults.count) {
        return AICollectionViewCellSize;
    } else {
        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds) - 40.0, 50.0);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    // If nothing was searched.
    if (!self.searchTerm.length) {
        return 0;
    }
    
    // Loading cell.
    if (self.currentPage == 1) {
        return 1;
    }
    
    // Photo cells + Loading cell.
    if (self.currentPage < self.totalPages) {
        return self.imageResults.count + 1;
    }
    
    // Photo cells
    return self.imageResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Search
    if (indexPath.row < self.imageResults.count) {
        return [self imageResultCollectionViewCellForIndexPath:indexPath];
    }
    
    else {
        self.currentPage++;
        [self fetchImagesWithText:self.searchTerm];
        return [self loadingCollectionViewCellForIndexPath:indexPath];
    }
}

#pragma mark - Cell Factory

- (UICollectionViewCell *)imageResultCollectionViewCellForIndexPath:(NSIndexPath *)indexPath {
    AICollectionViewCell *collectionViewCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:AICollectionViewCellIndentifier forIndexPath:indexPath];
    
    AIImageResult *imageResult = self.imageResults[indexPath.row];
    if ([imageResult isKindOfClass:AIImageResult.class]) {
        collectionViewCell.imageResult = imageResult;
    }
    
    return collectionViewCell;
}

- (UICollectionViewCell *)loadingCollectionViewCellForIndexPath:(NSIndexPath *)indexPath {
    AICollectionViewCell *collectionViewCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:AILoadingViewCellIndentifier forIndexPath:indexPath];
    return collectionViewCell;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endSearch];
}

#pragma mark - Fetching

- (void)fetchImagesWithText:(NSString *)text {
    
    // Search API
    [AISearchClient searchImageWithText:text count:60 page:self.currentPage completion:^(NSDictionary *jsonPayload, NSError *error) {
        
        id component;
        
        // By lack of time we don't do sofisticated error management here, we just avoid crashes.
        if (error) {
            return;
        }
        
        if (![jsonPayload isKindOfClass:NSDictionary.class]) {
            return;
        }
        
        // Photo payload.
        NSDictionary *photoPayload = jsonPayload[@"photos"];
        if (![photoPayload isKindOfClass:NSDictionary.class]) {
            return;
        }
        
        // Total Pages.
        component = photoPayload[@"total"];
        if (![component respondsToSelector:@selector(integerValue)]) {
            return;
        }
        self.totalPages = [component integerValue];
        
        // Photo images.
        NSArray *photoItems = photoPayload[@"photo"];
        if (![photoItems isKindOfClass:NSArray.class]) {
            return;
        }
        
        // Adding the results to the array.
        NSArray *imageResults = [AIImageResult imageResultsWithArray:photoItems];
        [self.imageResults addObjectsFromArray:imageResults];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // If no images was found.
            if (!self.imageResults.count) {
                self.hintLabel.alpha = 1.0;
                self.hintLabel.text = [NSString stringWithFormat:@"No image found for \"%@\"", text];
            }
            
            [self.collectionView reloadData];
        });
    }];
    
}

#pragma mark - Accessors

- (NSMutableArray *)imageResults {
    if (!_imageResults) {
        _imageResults = [[NSMutableArray alloc] init];
    }
    
    return _imageResults;
}

#pragma mark - Misc

- (void)beginSearch {
    if (!self.searchBar.isFirstResponder) {
        return;
    }
    
    self.hintLabel.alpha = 0.0;
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.searchDarkOverlay.alpha = 1.0;
    } completion:nil];
}

- (void)endSearch {
    if (!self.searchBar.isFirstResponder) {
        return;
    }
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.searchDarkOverlay.alpha = 0.0;
    } completion:nil];
}

#pragma mark - Public

- (void)searchWithTerm:(NSString *)term {
    AssertTrueOrReturn([term isKindOfClass:NSString.class] && term.length > 0);
    
    [self endSearch];
    self.searchTerm = term;
    self.searchBar.text = self.searchTerm;
    
    // Resetting
    self.imageResults = nil;
    self.currentPage = 1;
    self.totalPages = 0;
    [self.collectionView reloadData];
    
    [self fetchImagesWithText:self.searchTerm];
    [[AIHistoryManager sharedInstance] addSearchedTerm:self.searchTerm];
    
}

@end
