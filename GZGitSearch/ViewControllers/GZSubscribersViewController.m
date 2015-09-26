//
//  GZSubscribersViewController.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/26/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "GZSubscribersViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "SubscribersTableViewCell.h"
#import "UserOwner.h"
#import "UIActionSheet+Blocks.h"

@interface GZSubscribersViewController ()

@end

@implementation GZSubscribersViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.dataSource == nil) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SubscribersTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellTableView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     * Carrega celula de Subscribers que tem imagem e nome do usuario
     */
    SubscribersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubscribersCell"];
    
    cell = nil;
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubscribersTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserOwner *user = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.lblUserName.text = user.userName;
    
    if (user.userImage != nil) {
        /*
         * Significa que a foto desse usuario ja foi carregada uma vez
         * Entao o App nao tenta carrega la de novo
         */
        cell.imgUser.image = user.userImage;
        cell.loading.hidden = YES;
        [Utils setAnimationToImageView:cell.imgUser];
        
    } else {
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:user.userAvatarUrl]
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
             [cell.loading setHidden:YES];
             
             if (image && finished && error == nil) {
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     cell.imgUser.image = image;
                     user.userImage = image;
                     [Utils setAnimationToImageView:cell.imgUser];
                 });
             } else if (error != nil) {
                 UIImage *img = [UIImage imageNamed:@"imageUserDefault.jpg"];
                 cell.imgUser.image = img;
                 [Utils setAnimationToImageView:cell.imgUser];
             }
         }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    /*
     * Quando usuario clica na linha da tableview, aparece opcao de entrar na pagina do usuario que ele clicou
     */
    UserOwner *user = [self.dataSource objectAtIndex:indexPath.row];
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"What option?"
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"Visit Owner Page", nil];
    
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
        if (buttonIndex == 0) {
            // visitar pagina do usuario
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:user.userPageUrl]];
        }
    };
    
    [as showInView:self.view];
}

@end
