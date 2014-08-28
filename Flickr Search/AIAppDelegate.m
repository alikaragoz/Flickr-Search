//
//  AIAppDelegate.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "AIAppDelegate.h"

#import "AISearchCollectionViewController.h"

@implementation AIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Collection view controller.
    AISearchCollectionViewController *searchTableViewController = [[AISearchCollectionViewController alloc] init];
    
    // Base navigation controller.
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchTableViewController];
    self.window.rootViewController = navigationController;
    
    // Customization
    NSDictionary *titleAttributes = @{
        NSForegroundColorAttributeName: [UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1],
        NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:18],
    };
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
