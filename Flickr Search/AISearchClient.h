//
//  AISearchClient.h
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import <Foundation/Foundation.h>

@interface AISearchClient : NSObject

+ (instancetype)sharedInstance;

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion;
+ (void)searchImageWithText:(NSString *)text count:(NSUInteger)count page:(NSUInteger)page completion:(void (^)(id, NSError *))completion;
+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;

@end
