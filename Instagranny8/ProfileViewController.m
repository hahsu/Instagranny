//
//  ProfileViewController.m
//  Instagranny8
//
//  Created by Hannah Hsu on 7/11/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "ProfileCell.h"
#import "Post.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong)NSArray *posts;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self getPosts];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    // Do any additional setup after loading the view.
    self.authorLabel.text = [PFUser currentUser].username;
    PFFile *image = [[PFUser currentUser] valueForKey:@"profilePic"];
    [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        UIImage *postImage = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
        
        self.profilePic.image = postImageView.image;
        self.profilePic.layer.masksToBounds = YES;
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    }];
    [self.editProfileButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.editProfileButton.layer setBorderWidth:2.0];
    self.editProfileButton.layer.cornerRadius = 10;
    
}
- (IBAction)didTapEditProfile:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profilePic.image = editedImage;
    PFFile *profilePicFile = [self getPFFileFromImage:self.profilePic.image];
    [[PFUser currentUser] setValue:profilePicFile forKey:@"profilePic"];
    
    [[PFUser currentUser] saveInBackground];
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    PFUser *currUser = [PFUser currentUser];
    [query whereKey:@"username" equalTo:currUser[@"username"]];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    PFFile *image = post.image;
    [image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        UIImage *postImage = [UIImage imageWithData:imageData];
        UIImageView *postImageView = [[UIImageView alloc] initWithImage:postImage];
        
        cell.pictureView.image = postImageView.image;
    }];
     return cell;
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
