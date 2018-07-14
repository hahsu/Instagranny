//
//  ProfileViewController.h
//  Instagranny8
//
//  Created by Hannah Hsu on 7/11/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate>
@property (nonatomic, strong) PFUser *currUser;

@end
