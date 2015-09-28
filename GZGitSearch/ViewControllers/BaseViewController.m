//
//  BaseViewController.m
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import "BaseViewController.h"

#import "SVProgressHUD.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "BetterNSLog.h"
#import "UIActionSheet+Blocks.h"

#import "Response.h"

#import "GZSubscribersViewController.h"
#import "GZFollowersViewController.h"
#import "GZFollowingViewController.h"

#define BUTTON_USER_PAGE 0
#define BUTTON_USER_FOLLOWERS 1
#define BUTTON_USER_FOLLOWING 2

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     * Alteracao do footer da tableView, para nao deixar linhas vazias sobrando
     */
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     * prepareForSegue usado para passar parametros para a "proxima" viewController
     */
    
    if ([segue.identifier isEqualToString:@"openSubscribers"]) {
        GZSubscribersViewController *vc = segue.destinationViewController;
        vc.dataSource = (NSMutableArray *)sender;
    }
    
}

#pragma mark - IBActions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Methods OpenView

- (void)openFollowersWithDataSource:(NSMutableArray *)data {
    
    GZFollowersViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"followersViewController"];
    vc.dataSource = data;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openFollowingWithDataSource:(NSMutableArray *)data {
    
    GZFollowingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"followingViewController"];
    vc.dataSource = data;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Methods

- (void)startLoading {
    /*
     * É apresentado um loading na tela enquanto é efetuada a chamada da busca
     */
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:218/255.0 green:223/255.0 blue:225/255.0 alpha:1]];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)stopLoading {
    /*
     * O loading que estava na tela, é retirado
     */
    [SVProgressHUD dismiss];
}

- (void)didFinishWithError {
    [Utils showAlertWithTitle:@"Error" andMessage:@"Sorry, it was not possible to complete your search. Please, try again"];
}

- (void)didFinishWithSuccess:(NSDictionary *)jsonResponse forMethod:(MethodsType)methodType {
    
    /*
     * Metodo chamado quando há sucesso na chamada da API
     * Cada metodo tem seu devido tratamento na classe: Response
     */

    NSMutableArray *data;
    
    if (methodType == methodRepoSearch) {
        data = [[[Response alloc] init] getArRepositorysFromJson:jsonResponse];
    } else if (methodType == methodUserSearch) {
        data = [[[Response alloc] init] getArUsersFromJson:jsonResponse];
    } else if (methodType == methodSubscribers) {
        data = [[[Response alloc] init] getArSubscribersFromJson:jsonResponse];
        
        [self performSegueWithIdentifier:@"openSubscribers" sender:data];
        
        return;
    } else if (methodType == methodFollowers) {
        /*
         * No caso de abrir os Followers, nao é utilizado performSegue
         * Motivo: dentro de followers, pode abrir followers novamente e assim por diante eternamente
         * Um jeito para se resolver seria criar um button "fantasma" e criar o segue para a propria view
         * Porem seria um modo grotesco para realizar e dificil de dar uma manutencao futuramente
         */
        data = [[[Response alloc] init] getArFollowersFromJson:jsonResponse];

        [self openFollowersWithDataSource:data];
        
        return;
    } else if (methodType == methodFollowing) {
        /*
         * Caso de quem o usuario esta seguindo, seria igual o de Followers
         * Pelo motivo de que um pode abrir outro igual (mesma viewController)
         */
        data = [[[Response alloc] init] getArFollowersFromJson:jsonResponse];
        
        [self openFollowingWithDataSource:data];
        
        return;
    }
    
    [self reloadContentWithArray:data fromMethod:methodType];
}

- (void)showOptionsForUser:(UserOwner *)user {
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"What option?"
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"Visit User Page", @"User Followers", @"User Following",nil];
    
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
        
        if (buttonIndex == BUTTON_USER_PAGE) {
            // visitar pagina do usuario
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:user.userPageUrl]];
        } else if (buttonIndex == BUTTON_USER_FOLLOWERS) {
            // abrir lista de seguidores do usuario
            [self searchWithString:user.userFollowers andMethod:methodFollowers];
        } else if (buttonIndex == BUTTON_USER_FOLLOWING) {
            [self searchWithString:user.userFollowing andMethod:methodFollowing];
        }
        
    };
    
    [as showInView:self.view];
}

#pragma mark - Methods Services GitHub

- (void)searchWithString:(NSString *)string andMethod:(MethodsType)methodType {
    
    /*
     * Primeiro é feita validacao da conexao do usuario, caso nao possua conexao, nao devera realizar a busca
     * Codigo recebe a string para busca e o tipo do metodo
     * Request possui um timeOut de 15s.
     * Caso de algum erro, um alert será apresentado ao usuario informando o erro
     * Caso nao haja erros, o app irá tratar o response para apresentar o conteudo da busca
     */
    
    if (![Utils hasConnection]) {
        [self stopLoading];
        [self didFinishWithError];
        return;
    }
    
    [self startLoading];
    
    NSString *url;
    
    if (methodType == methodRepoSearch) {
        /*
         * Quando for do tipo busca por repositorio, base colocar a string na desc.
         */
        url = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@", string];
    } else if (methodType == methodUserSearch) {
        /*
         * Quando for do tipo busca por usuario, base colocar a string na desc.
         */
        url = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@", string];
    } else if (methodType == methodSubscribers || methodType == methodFollowing || methodType == methodFollowers) {
        /*
         * Os seguintes metodos ja vem com a url pronta para o GET
         */
        url = string;
    }

    
    NSString *escapedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *urlString = [NSURL URLWithString:escapedUrl];
    
    DLog(@"URL METHOD GET = %@", urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString];
    request.timeoutInterval = 15;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"Response recebido com sucesso !");
        
        /*
         * Caso tenha recebido o response e esteja tudo ok, encaminhar para tratamento do response
         * Se nao, apresentar usuario alert dizendo que houve erro na busca
         */
        
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSUTF8StringEncoding error:&error];
        
        if (response != nil) {
            [self stopLoading];
            [self didFinishWithSuccess:response forMethod:methodType];
        } else {
            [self stopLoading];
            [self didFinishWithError];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*
         * Caso de falha na chamada, apresentar alert ao usuario informando que houve um erro, para ele tentar novamente
         */
        [self stopLoading];
        [self didFinishWithError];
        
        DLog("%@", error.description);
        
    }];
    
    [operation start];
}

#pragma mark - UITableView Delegate && DataSource

/*
 * Metodo para identacao das Celulas da tableView
 * As celulas ficam "encostadas" na esquerda
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
