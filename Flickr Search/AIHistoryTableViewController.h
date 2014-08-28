//
//  AIHistoryTableViewController.h
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import <UIKit/UIKit.h>

#import "AISearchCollectionViewController.h"

@interface AIHistoryTableViewController : UITableViewController

@property (readwrite, nonatomic, weak) AISearchCollectionViewController *sourceSearchCollectionViewController;

@end
