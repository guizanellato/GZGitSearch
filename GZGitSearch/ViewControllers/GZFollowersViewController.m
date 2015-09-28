//
//  GZFollowersViewController.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/27/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "GZFollowersViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "GZUserTableViewCell.h"
#import "UserOwner.h"
#import "UIActionSheet+Blocks.h"

@interface GZFollowersViewController ()

@end

@implementation GZFollowersViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.dataSource == nil) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GZUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"usersCell"];
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
    GZUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"usersCell"];
    
    cell = nil;
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GZUserTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
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
                     
                 });
             } else if (error != nil) {
                 cell.imgUser.image = [UIImage imageNamed:@"imageUserDefault.jpg"];
             }
             
             [Utils setAnimationToImageView:cell.imgUser];
             
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
                                           otherButtonTitles:@"Visit Owner Page", @"Followers", nil];
    
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
        if (buttonIndex == 0) {
            // visitar pagina do usuario
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:user.userPageUrl]];
        } else if (buttonIndex == 1) {
            // abrir lista de seguidores do usuario
            [self searchWithString:user.userFollowers andMethod:methodFollowers];
        }
    };
    
    [as showInView:self.view];
}


@end
