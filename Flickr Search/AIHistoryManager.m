//
//  AIHistoryManager.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "AIHistoryManager.h"

#import <KZAsserts.h>

static NSString *const AIHistorySearchedTerms = @"AIHistorySearchedTerms";

@interface AIHistoryManager ()

@end

@implementation AIHistoryManager

#pragma mark - Init

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Accessors

- (void)addSearchedTerm:(NSString *)term {
    AssertTrueOrReturn([term isKindOfClass:NSString.class] && term.length > 0);
    
    // First we need to check if it's already inside.
    for (NSString *t in self.searchedTerms) {
        if ([term isEqualToString:t]) {
            return;
        }
    }
    
    NSMutableArray *searchedTerms = [self.searchedTerms mutableCopy];
    [searchedTerms insertObject:term atIndex:0];
    self.searchedTerms = searchedTerms;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:searchedTerms forKey:AIHistorySearchedTerms];
    [defaults synchronize];
}

- (void)removeSearchTermAdIndex:(NSUInteger)index {
    AssertTrueOrReturn(index <= self.searchedTerms.count);
    
    NSMutableArray *searchedTerms = [self.searchedTerms mutableCopy];
    [searchedTerms removeObjectAtIndex:index];
    self.searchedTerms = searchedTerms;
}

- (void)clearHistory {
    self.searchedTerms = [NSArray array];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.searchedTerms forKey:AIHistorySearchedTerms];
    [defaults synchronize];
}

- (NSArray *)searchedTerms {
    if (!_searchedTerms) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *searchedTerms = [defaults objectForKey:AIHistorySearchedTerms];
        if (![searchedTerms isKindOfClass:NSArray.class]) {
            searchedTerms = [NSArray array];
            [defaults setObject:searchedTerms forKey:AIHistorySearchedTerms];
            [defaults synchronize];
        }
        
        _searchedTerms = searchedTerms;
    }
    
    return _searchedTerms;
}

@end
