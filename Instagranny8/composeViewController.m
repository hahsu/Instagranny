//
//  composeViewController.m
//  Instagranny8
//
//  Created by Hannah Hsu on 7/9/18.
//  Copyright © 2018 Hannah Hsu. All rights reserved.
//

#import "composeViewController.h"
#import "Post.h"

@interface composeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UITextView *captionView;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet MKMapView *locationView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation composeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationView.delegate = self;
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.locationView addGestureRecognizer:gestureRecognizer];
    // Do any additional setup after loading the view.
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSArray *annotations = [mapView annotations];
    [mapView showAnnotations:annotations animated:YES];
}

/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"Hello");
}
*/

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender{
    if(sender.state == UIGestureRecognizerStateEnded){
        [self.locationView removeGestureRecognizer:sender];
    }
    else{
        CGPoint point = [sender locationInView:self.locationView];
        CLLocationCoordinate2D locCoord = [self.locationView convertPoint:point toCoordinateFromView:self.locationView];
        MKPointAnnotation *annot = [[MKPointAnnotation alloc]init];
        annot.coordinate = locCoord;
        NSLog(@"%f%f", locCoord.latitude, locCoord.longitude);
        [self.locationView addAnnotation:annot];
        self.location = locCoord;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    /*
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
     */
    
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
- (IBAction)didTapSwitch:(id)sender {
    if(self.locationSwitch.isOn == NO){
        [self.locationView setHidden:YES];
    }
    else{
        [self.locationView setHidden:NO];
    }
}
- (IBAction)tappedCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)tappedShare:(id)sender {
    [self.activityIndicator startAnimating];
    [Post postUserImage:self.posterView.image withCaption:self.captionView.text withLong:self.location.longitude withLat:self.location.latitude withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error == nil){
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.activityIndicator stopAnimating];
        }
    }];
}
- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)pressedPickFromCameraRoll:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.posterView.image = editedImage;
    
    
    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
