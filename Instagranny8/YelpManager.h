//
//  YelpManager.h
//  Instagranny8
//
//  Created by Hannah Hsu on 7/12/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpManager : NSObject
- (void)getEvent:(NSString *)latitude withLongitude:(NSString *)longitude withCompletion:(void(^)(NSDictionary *categories, NSError *error))completion;
@end
