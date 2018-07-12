//
//  LoginViewController.m
//  Instagranny8
//
//  Created by Hannah Hsu on 7/9/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoImage.image = [self inverseColor:self.logoImage.image];
    // Do any additional setup after loading the view.
}
- (UIImage *)inverseColor:(UIImage *)image {
    CIImage *coreImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:coreImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    return [UIImage imageWithCIImage:result];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createError:(NSString *)errorMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:errorMessage
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (IBAction)didTapSignup:(id)sender {
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    UIImage *profilePic = [UIImage imageNamed:@"image_placeholder"];
    PFFile *profilePicFile = [self getPFFileFromImage:profilePic];
    // get image data and check if that is not nil
    
    [newUser setValue:profilePicFile forKey:@"profilePic"];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
                [self createError:@"Missing username or password"];
            }
            else{
                [self createError:@"User already exists for that username"];
            }
        } else {
            [self performSegueWithIdentifier:@"photosView" sender:nil];
            
            // manually segue to logged in view
        }
    }];
}

-(PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            [self createError:@"Incorrect username or password"];
        } else {
            [self performSegueWithIdentifier:@"photosView" sender:nil];
            
            // display view controller that needs to shown after successful login
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
