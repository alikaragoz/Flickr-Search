//
//  AISearchImage.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "AIImageResult.h"

#import <KZAsserts.h>

@implementation AIImageResult

#pragma mark - Init

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    AssertTrueOrReturnNil([attributes isKindOfClass:NSDictionary.class]);
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    id componement;
    
    // Title
    componement = attributes[@"title"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _title = componement;
    } else {
        return nil;
    }
    
    // identifier
    componement = attributes[@"id"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _identifier = componement;
    } else {
        return nil;
    }
    
    // owner
    componement = attributes[@"owner"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _owner = componement;
    } else {
        return nil;
    }
    
    // secret
    componement = attributes[@"secret"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _secret = componement;
    } else {
        return nil;
    }
    
    // server
    componement = attributes[@"server"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _server = componement;
    } else {
        return nil;
    }
    
    // farm
    componement = attributes[@"farm"];
    if ([componement respondsToSelector:@selector(integerValue)]) {
        _farm = [componement integerValue];
    } else {
        return nil;
    }
    
    return self;
}

- (NSURL *)imageSourceURLWithSize:(NSString *)size {
    AssertTrueOrReturnNil([size isKindOfClass:NSString.class]);
    
    // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
    NSString *urlString = [NSString stringWithFormat:@"https://farm%ld.staticflickr.com/%@/%@_%@_%@.jpg", (unsigned long)self.farm, self.server, self.identifier, self.secret, size];
    return [NSURL URLWithString:urlString];
}

#pragma mark - Factory

+ (AIImageResult *)imageResultWithAttributes:(NSDictionary *)attributes {
    return [[AIImageResult alloc] initWithAttributes:attributes];
}

+ (NSArray *)imageResultsWithArray:(NSArray *)array {
    AssertTrueOrReturnNil([array isKindOfClass:NSArray.class]);
    
    NSMutableArray *imageResults = [NSMutableArray array];

    for (id searchImageDic in array) {
        if (![searchImageDic isKindOfClass:NSDictionary.class]) {
            continue;
        }
        
        AIImageResult *imageResult = [AIImageResult imageResultWithAttributes:searchImageDic];
        if (!imageResult) {
            continue;
        }
        
        [imageResults addObject:imageResult];
    }
    
    return imageResults;
}

@end
