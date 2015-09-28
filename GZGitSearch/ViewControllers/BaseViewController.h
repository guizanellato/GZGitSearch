//
//  BaseViewController.h
//  GZGitSearch
//
//  Created by Guilherme Zanellato on 9/25/15.
//  Copyright © 2015 Guilherme Zanellato. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utils.h"
#import "UserOwner.h"

/*
 * Definicao dos tipos de metodos no servico que sera utilizado
 */
typedef enum methodsService
{
    methodUserSearch,
    methodRepoSearch,
    methodSubscribers,
    methodFollowers,
    methodFollowing,
    methodPerfil
} MethodsType;

@interface BaseViewController : UIViewController

/*
 * TableView usada nas clases que usam o BaseViewController como Base
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*
 * Array usado para dataSource das Table Views
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/*!
 * Metodo realiza a busca atraves de uma string e um metodo especifico
 */
- (void)searchWithString:(NSString *)string andMethod:(MethodsType)methodType;

/*!
 * Metodo chamado quando a busca foi realizada com sucesso
 * Passa para a view, um array com os conteudos que ela deve exibir
 */
- (void)reloadContentWithArray:(NSMutableArray *)arDataSource fromMethod:(MethodsType)methodType;

/*!
 * Metodo recebe um objeto do tipo UserOwner e apresenta opcoes ao usuario
 */
- (void)showOptionsForUser:(UserOwner *)user;

@end
