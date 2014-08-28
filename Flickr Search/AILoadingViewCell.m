//
//  AILoadingViewCell.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "AILoadingViewCell.h"

NSString *const AILoadingViewCellIndentifier = @"AILoadingViewCellIndentifier";

@interface AILoadingViewCell ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation AILoadingViewCell

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
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = YES;
    
    // Activity indicator view.
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    _activityIndicatorView.hidesWhenStopped = NO;
    [_activityIndicatorView startAnimating];
    [self.contentView addSubview:_activityIndicatorView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}


@end
