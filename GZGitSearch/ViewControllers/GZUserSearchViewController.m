//
//  GZUserSearchViewController.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "GZUserSearchViewController.h"

#import "UserTableViewCell.h"
#import "UserOwner.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIActionSheet+Blocks.h"

@interface GZUserSearchViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation GZUserSearchViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.dataSource == nil) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"UsersCell"];

    
    self.searchBar.showsCancelButton = YES;
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark - UISearchBar Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    /*
     * Quando usuario clicar em Cancelar, apagar o texto da SearchBar
     */
    self.searchBar.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    /*
     * Usuario clica para buscar
     * Caso nao tenha digitado nada, apresentar alert de erro ao usuario
     * Caso tenha digitado, realizar chamada de busca
     */
    if (searchBar.text == nil || [searchBar.text isEqualToString:@""]) {
        [Utils showAlertWithTitle:@"Error!" andMessage:@"Please, write something to search"];
        return;
    } else {
        [self.searchBar resignFirstResponder];
        
        [self searchWithString:self.searchBar.text andMethod:methodUserSearch];
    }
}


#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsersCell"];
    
    cell = nil;
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell" owner:self options:nil];
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
     * Quando usuario clicar na tableview em qualquer linha, tirar o teclado da search
     * Para assim, nao atrapalhar o usuario
     */
    [self.searchBar resignFirstResponder];
    
    
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

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    /*
     * Quando usuario der scroll na tableview, tirar o teclado da search
     * Para assim, nao atrapalhar o usuario
     */
    [self.searchBar resignFirstResponder];
}

#pragma mark - Methods

- (void)reloadContentWithArray:(NSMutableArray *)arDataSource fromMethod:(MethodsType)methodType {
    /*
     * Metodo recebe array para carregar a tableView
     * Poderia ser usado o metodo [self.tableView reloadData]
     * Porem o reloadSections permite uma certa animacao para a tableView
     */
    if (methodType == methodUserSearch) {
        self.dataSource = arDataSource;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    }
}

@end
