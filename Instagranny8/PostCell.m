//
//  PostCell.m
//  Instagranny8
//
//  Created by Hannah Hsu on 7/9/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didTapProfile:)];
    [self.profilePic addGestureRecognizer:singleFingerTap];
    [self.profilePic setUserInteractionEnabled:YES];
    // Initialization code
}

-(IBAction)didTapProfile:(id)sender{
    [self.delegate postCell:self didTap:self.post.author];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)tappedLike:(id)sender {
    if([self.likeCountLabel.text integerValue] == 1){
        self.likeCountLabel.text = @"0";
        self.post.likeCount = [NSNumber numberWithInteger:0];
        [self.post saveInBackground];
        UIImage *image = [UIImage imageNamed:@"favor-icon-1"];
        [self.likeButton setImage:image forState:UIControlStateNormal];
    }
    else{
        self.likeCountLabel.text = @"1";
        self.post.likeCount = [NSNumber numberWithInteger:1];
        [self.post saveInBackground];
        UIImage *image = [UIImage imageNamed:@"favor-icon"];
        [self.likeButton setImage:image forState:UIControlStateNormal];
    }
}


@end
