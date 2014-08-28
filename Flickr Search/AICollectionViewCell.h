//
//  AICollectionViewCell.h
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import <UIKit/UIKit.h>

#import "AIImageResult.h"

extern NSString *const AICollectionViewCellIndentifier;
extern CGSize const AICollectionViewCellSize;

@interface AICollectionViewCell : UICollectionViewCell

@property (readwrite, nonatomic, strong) AIImageResult *imageResult;

@end
