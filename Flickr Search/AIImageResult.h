//
//  AISearchImage.h
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import <Foundation/Foundation.h>

@interface AIImageResult : NSObject

@property (readonly, nonatomic, copy) NSString *title;
@property (readonly, nonatomic, copy) NSString *identifier;
@property (readonly, nonatomic, copy) NSString *owner;
@property (readonly, nonatomic, copy) NSString *secret;
@property (readonly, nonatomic, copy) NSString *server;
@property (readonly, nonatomic, assign) NSUInteger farm;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (AIImageResult *)imageResultWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)imageResultsWithArray:(NSArray *)array;

- (NSURL *)imageSourceURLWithSize:(NSString *)size;

@end
