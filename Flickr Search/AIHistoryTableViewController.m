//
//  AIHistoryTableViewController.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "AIHistoryTableViewController.h"

#import "AIHistoryManager.h"

static NSString *const AIHistoryTableViewCellIdentifier = @"AIHistoryTableViewCellIdentifier";

@interface AIHistoryTableViewController ()

@property (nonatomic, strong) UINavigationBar *navigationBar;

@end

@implementation AIHistoryTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Search History";
    
    // Navigation bar
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissController)];
    UIBarButtonItem *clearButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearHistory)];
    self.navigationItem.leftBarButtonItem = doneButtonItem;
    self.navigationItem.rightBarButtonItem = clearButtonItem;
    
    // Table view
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:AIHistoryTableViewCellIdentifier];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *term;
    if (indexPath.row < [[AIHistoryManager sharedInstance] searchedTerms].count) {
        term = [[AIHistoryManager sharedInstance] searchedTerms][indexPath.row];
    }
    
    [self.sourceSearchCollectionViewController searchWithTerm:term];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[AIHistoryManager sharedInstance] searchedTerms].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:AIHistoryTableViewCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < [[AIHistoryManager sharedInstance] searchedTerms].count) {
        tableViewCell.textLabel.font = [UIFont fontWithName:@"Avenir" size:18.0];
        tableViewCell.textLabel.text = [[AIHistoryManager sharedInstance] searchedTerms][indexPath.row];
        tableViewCell.textLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    }
    
    return tableViewCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    [[AIHistoryManager sharedInstance] removeSearchTermAdIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Misc

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearHistory {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Clear History?"
                                                        message:@"Are you sure you wan't to clear the history?"
                                                       delegate:self
                                              cancelButtonTitle:@"Nope"
                                              otherButtonTitles:@"Yup", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        [[AIHistoryManager sharedInstance] clearHistory];
        [self.tableView reloadData];
        [self dismissController];
    }
}

@end
