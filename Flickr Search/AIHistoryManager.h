//
//  AIHistoryManager.h
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import <Foundation/Foundation.h>

@interface AIHistoryManager : NSObject

@property (nonatomic, strong) NSArray *searchedTerms;

+ (instancetype)sharedInstance;

- (void)addSearchedTerm:(NSString *)term;
- (void)removeSearchTermAdIndex:(NSUInteger)index;
- (void)clearHistory;

@end
