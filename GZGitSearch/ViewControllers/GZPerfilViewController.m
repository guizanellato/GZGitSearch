//
//  GZPerfilViewController.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/27/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "GZPerfilViewController.h"

#import <JTMaterialSpinner/JTMaterialSpinner.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface GZPerfilViewController () <MFMailComposeViewControllerDelegate>

#pragma mark - Properties -

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowers;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDateCreated;
@property (weak, nonatomic) IBOutlet UILabel *lblDateLastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lblBlog;
@property (weak, nonatomic) IBOutlet UILabel *lblIndicatorLocation;

@property (weak, nonatomic) IBOutlet UIButton *btnVisitBlog;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet JTMaterialSpinner *loading;

@end

@implementation GZPerfilViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.perfil.userBlog == nil || self.perfil.userBlog.length == 0) {
        self.btnVisitBlog.hidden = YES;
    }
    
    if (self.perfil.userLocation == nil || self.perfil.userLocation.length == 0) {
        self.lblIndicatorLocation.hidden = YES;
    }
    
    [self loadUserImage];
    [self loadLayout];
    [self loadContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)sendEmail:(id)sender {
    /*
     * Caso usuario tenha um email valido, tentar enviar
     * Caso nao seja valido, apresentar alert ao usuario
     */
    if ([Utils isValidEmail:self.perfil.userEmail]) {
        [self sendEmailTo:self.perfil.userEmail];
    } else {
        [Utils showAlertWithTitle:@"Oops" andMessage:@"Sorry, this user has a invalid Email"];
    }
}

- (IBAction)visitBlog:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.perfil.userBlog]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.perfil.userBlog]];
    } else {
        [Utils showAlertWithTitle:@"Oops" andMessage:@"Sorry, was not possible to open the blog"];
    }
    
}

#pragma mark - Methods

- (void)loadUserImage {
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.perfil.userAvatarUrl]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                           // progression tracking code
                                                       }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         /*
          * Quando termina a chamada da imagem
          * Caso tenha dado certo, troca a imagem do usuario pela imagem carregada
          * Caso errado, adiciona uma imagem default para o usuario
          */
         [self.loading setHidden:YES];
         
         if (image && finished && error == nil) {
             
             dispatch_sync(dispatch_get_main_queue(), ^{
                 
                 self.imgUser.image = image;
             });
         } else if (error != nil) {
             self.imgUser.image = [UIImage imageNamed:@"imageUserDefault.jpg"];
         }
         
         [Utils setAnimationToImageView:self.imgUser];
         
     }];
}

- (void)loadLayout {
    self.lblFollowers.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0f];
    self.lblFollowing.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0f];
    self.lblLocation.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0f];
    self.lblDateCreated.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0f];
    self.lblDateLastUpdate.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0f];
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width / 2;
    self.imgUser.contentMode = UIViewContentModeScaleAspectFill;
    self.imgUser.clipsToBounds = YES;
    
    self.loading.circleLayer.lineWidth = 2.0;
    self.loading.circleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [self.loading beginRefreshing];
}

- (void)loadContent {
    self.lblUserName.text = self.perfil.userFullName;
    self.lblFollowers.text = [self getLblFollowersCountFrom:self.perfil.userFollowersCount];
    self.lblFollowing.text = [self getLblFollowingFrom:self.perfil.userFollowingCount];
    self.lblLocation.text = [self getLblLocationFrom:self.perfil.userLocation];
    self.lblBlog.text = [self getLblBlogFrom:self.perfil.userBlog];
    self.lblDateCreated.text = [self getLblDateCreatedFrom:[Utils convertDateWithString:self.perfil.userDateCreated]];
    self.lblDateLastUpdate.text = [self getLblLastUpdateFrom:[Utils convertDateWithString:self.perfil.userLastUpdate]];
}

#pragma mark - Methods Formmaters

- (NSString *)getLblFollowingFrom:(NSString *)followingCount {
    return [NSString stringWithFormat:@"Following: %@", followingCount];
}

- (NSString *)getLblLocationFrom:(NSString *)location {
    return [NSString stringWithFormat:@"%@", location];
}

- (NSString *)getLblFollowersCountFrom:(NSString *)followersCount {
    return [NSString stringWithFormat:@"Followers: %@", followersCount];
}

- (NSString *)getLblDateCreatedFrom:(NSString *)dateCreated {
    return [NSString stringWithFormat:@"Since: %@", dateCreated];
}

- (NSString *)getLblLastUpdateFrom:(NSString *)lastUpdate {
    return [NSString stringWithFormat:@"Last Update: %@", lastUpdate];
}

- (NSString *)getLblBlogFrom:(NSString *)blog {
    return [NSString stringWithFormat:@"%@", blog];
}

#pragma mark - Methods Email


-(void)sendEmailTo:(NSString *)email {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        
        controller.mailComposeDelegate = self;
        controller.navigationBar.tintColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        [controller setSubject:@""];
        [controller setToRecipients:@[email]];
        
        [self presentViewController:controller animated:YES completion:NULL];
    } else {
        [Utils showAlertWithTitle:@"Oops" andMessage:@"It's not possible to send Email"];
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {

    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            [Utils showAlertWithTitle:@"Success" andMessage:@"Your email has been sent successfully"];
            break;
        case MFMailComposeResultFailed:
            [Utils showAlertWithTitle:@"Error" andMessage:@"Sorry, was not possible to send"];
            break;
        default:
            [Utils showAlertWithTitle:@"Error" andMessage:@"Sorry, was not possible to send"];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
