//
//  PostCell.h
//  Instagranny8
//
//  Created by Hannah Hsu on 7/9/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"


@protocol PostCellDelegate;

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) id <PostCellDelegate> delegate;
@end

@protocol PostCellDelegate
-(void)postCell:(PostCell *)postCell didTap:(PFUser *)user;
@end
