//
//  NSString+URLEncode.h
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)

- (NSString *)urlEncode;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end
