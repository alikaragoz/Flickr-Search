//
//  AISearchClient.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "AISearchClient.h"

#import <KZAsserts.h>
#import "NSString+URLEncode.h"

#error Add your Flickr API Key below.
static NSString *const AISearchClientFlickrAPIKey = @"<YOUR_FLICKR_API_KEY>";
static NSString *const AISearchClientFlickrAPIURL = @"https://api.flickr.com/";
static NSString *const AISearchClientFlickrAPIPath = @"services/rest/";

@interface AISearchClient ()

@property (nonatomic, strong) NSURLSession *session;

+ (instancetype)sharedInstance;

@end

@implementation AISearchClient

#pragma mark - Init

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return self;
}

#pragma mark - Fetching

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion {
    AssertTrueOrReturn(completion != nil);
    
    [AISearchClient setNetworkActivityIndicatorVisible:YES];
    
    // Building the query URL.
    NSMutableString *parametersString = [[NSMutableString alloc] init];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [parametersString appendFormat:@"%@=%@&", key, obj];
    }];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", AISearchClientFlickrAPIURL, path];
    
    if ([parametersString length] > 0) {
        urlString = [urlString stringByAppendingFormat:@"?%@", parametersString];
    }
    
    // Making the request.
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [AISearchClient setNetworkActivityIndicatorVisible:NO];
        
        if (error) {
            if (completion) {
                completion(nil, error);
            }
        }
        
        else {
            NSError *err = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            // If the error object is set, we fire one.
            if ([json isKindOfClass:NSDictionary.class] && json[@"error"]) {
                err = [NSError errorWithDomain:@"com.alikaragoz.Image-Seatch"
                                          code:-1
                                      userInfo:@{ NSLocalizedDescriptionKey : @"An error occured while making the request."}];
                
                if (completion) {
                    completion(nil, err);
                    return;
                }
            }
            
            if (completion) {
                completion(json, err);
            }
        }
    }];
    
    [task resume];
}

+ (void)searchImageWithText:(NSString *)text count:(NSUInteger)count page:(NSUInteger)page completion:(void (^)(id, NSError *))completion {
    AssertTrueOrReturn(completion != nil);
    AssertTrueOrReturn(text != nil || [text isKindOfClass:NSString.class]);
    
    NSString *encodedText = [text urlEncode];
    
    NSDictionary *parameters = @{
        @"method" : @"flickr.photos.search",
        @"api_key" : AISearchClientFlickrAPIKey,
        @"sort" : @"interestingness-desc",
        @"text" : encodedText,
        @"format" : @"json",
        @"nojsoncallback" : @"1",
        @"per_page" : @(count),
        @"page" : @(page)
    };
    
    [[AISearchClient sharedInstance] getPath:AISearchClientFlickrAPIPath parameters:parameters completion:completion];
}

#pragma mark - Activity indicator

+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSUInteger kNetworkIndicatorCount = 0;
    
    if (setVisible) {
        kNetworkIndicatorCount++;
    } else {
        kNetworkIndicatorCount--;
    }
    
    NSAssert(kNetworkIndicatorCount >= 0, @"Network Activity Indicator was asked to hide more often than shown");
    
    // Display the indicator as long as our static counter is > 0.
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(kNetworkIndicatorCount > 0)];
    });
}

@end
