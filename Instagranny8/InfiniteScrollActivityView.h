//
//  InfiniteScrollActivityView.h
//  Instagranny8
//
//  Created by Hannah Hsu on 7/13/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteScrollActivityView : UIView
@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;
@end
