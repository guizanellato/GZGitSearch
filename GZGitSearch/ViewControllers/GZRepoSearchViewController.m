//
//  GZRepoSearchViewController.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "GZRepoSearchViewController.h"

#import "RepositoryTableViewCell.h"
#import "Repository.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIActionSheet+Blocks.h"

@interface GZRepoSearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation GZRepoSearchViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.dataSource == nil) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RepositoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellTableView"];
    
    self.searchBar.showsCancelButton = YES;
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self searchWithString:self.searchBar.text andMethod:methodRepoSearch];
        
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 218;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepositoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepositoryCell"];
    
    cell = nil;
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RepositoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*
     * O array dataSource possui objetos do tipo "Repository"
     * Cada linha da tableView será um objeto do tipo Repository
     * O codigo verificará se esse usuario ja teve sua foto carregada, se nao, tentara carregar
     */
    
    Repository *repo = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.lblLanguage.text = [NSString stringWithFormat:@"Language: %@", repo.repositoryLanguage];
    cell.lblRepositoryName.text = repo.repositoryName;
    cell.lblRepositoryDescription.text = repo.repositoryDescription;
    cell.lblViewsCount.text = [NSString stringWithFormat:@"Views: %@",[repo.repositoryViewsCount stringValue]];
    
    if (repo.userOwner.userImage != nil) {
        /*
         * Significa que a foto desse usuario ja foi carregada uma vez
         * Entao o App nao tenta carrega la de novo
         */
        cell.imgUserOwner.image = repo.userOwner.userImage;
        cell.loading.hidden = YES;
        
        [Utils setAnimationToImageView:cell.imgUserOwner];
        
    } else {
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:repo.userOwner.userAvatarUrl]
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
                     
                     cell.imgUserOwner.image = image;
                     repo.userOwner.userImage = image;
                     
                 });
             } else if (error != nil) {
                 cell.imgUserOwner.image = [UIImage imageNamed:@"imageUserDefault.jpg"];
             }
             
             [Utils setAnimationToImageView:cell.imgUserOwner];
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
     * Quando usuario clica em alguma celula, apresentar um actionSheet
     * Opcao de visitar pagina do dono do repositorio
     * opcao de ver os assinantes do repositorio
     * a opcao de ver os assinantes faz um get para receber a listagem
     */
    Repository *repo = [self.dataSource objectAtIndex:indexPath.row];
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"What option?"
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"Visit Owner Page", @"Subscribers", nil];
    
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
        if (buttonIndex == 0) {
            // visitar pagina do usuario
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:repo.userOwner.userPageUrl]];
        } else {
            // ver os assinantes
            [self searchWithString:repo.repositorySubscribers andMethod:methodSubscribers];
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
    if (methodType == methodRepoSearch) {
        self.dataSource = arDataSource;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    }
}

@end
