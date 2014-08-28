//
//  AICollectionViewCell.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "AICollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

NSString *const AICollectionViewCellIndentifier = @"AICollectionViewCellIndentifier";
CGSize const AICollectionViewCellSize = {100.0, 100.0};

@interface AICollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation AICollectionViewCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit {
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.clipsToBounds = YES;
    
    // Image view
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:@{@"imageView" : self.imageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:@{@"imageView" : self.imageView}]];
}

#pragma mark - Reuse

- (void)prepareForReuse {
    self.imageView.image = nil;
}

#pragma mark - Accessors

- (void)setImageResult:(AIImageResult *)imageResult {
    _imageResult = imageResult;
    [self.imageView sd_setImageWithURL:[imageResult imageSourceURLWithSize:@"q"]];
}

@end
