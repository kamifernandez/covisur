//
//  PresentacionViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "PresentacionViewController.h"
#import "PresentacionCollectionViewCell.h"
#import "InicioSesionViewController.h"
#import "RequestUrl.h"

@interface PresentacionViewController ()

@end

@implementation PresentacionViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"login"] isEqualToString:@"YES"]) {
        [self pasarLogin];
    }else{
        if ([[_defaults objectForKey:@"presentacion"] isEqualToString:@"YES"]) {
            [self pasarLogin];
        }
    }
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    
    //[self performSelector:@selector(requestServerToken) withObject:nil afterDelay:1.5];
    
    [self.btnSaltarPresentacion.layer setCornerRadius:17.0];
    
    /*+++++Harcode+++++++*/
    _data = [[NSMutableArray alloc] init];
    for (int i = 0; i<4; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        if (i == 0) {
            [dataInsert setObject:@"slider1.png" forKey:@"logo"];
            [dataInsert setObject:@"Regístrate en SuanApp y podrás consultar. Resultados de Antecedentes disciplinarios, penales, lista Clinton, poligrafías, visitas domiciliarias, entre otros." forKey:@"descripcion"];
        }else if(i == 1){
            [dataInsert setObject:@"slider2.png" forKey:@"logo"];
            [dataInsert setObject:@"Consulta servicios completamente gratis como: Antecedentes disciplinarios, penales, contractuales y fiscales." forKey:@"descripcion"];
        }else if(i == 2){
            [dataInsert setObject:@"slider3.png" forKey:@"logo"];
            [dataInsert setObject:@"Agenda tus servicios pagos y un consultor atenderá tú solicitud en la fecha y dirección que indiques." forKey:@"descripcion"];
        }else if(i == 3){
            [dataInsert setObject:@"slider4.png" forKey:@"logo"];
            [dataInsert setObject:@"Paga tus consultas en línea de forma fácil y segura, sólo debes registrar tu tarjeta de crédito, tu información estará segura" forKey:@"descripcion"];
        }else if(i == 4){
            [dataInsert setObject:@"slider5.png" forKey:@"logo"];
            [dataInsert setObject:@"Si necesitas asistencia en nuestra App encontrarás varios canales de consulta." forKey:@"descripcion"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    self.pageCollection.numberOfPages = [_data count];
    [self.collection reloadData];
    [self requestServerToken];
}

-(IBAction)nextButton:(id)sender{
    NSArray *visibleItems = [self.collection indexPathsForVisibleItems];
    NSIndexPath *currentItem = [visibleItems objectAtIndex:0];
    if (currentItem.item != ([_data count] - 1)) {
        NSIndexPath *nextItem = [NSIndexPath indexPathForItem:currentItem.item + 1 inSection:currentItem.section];
        [self.collection scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        CGFloat pageWidth = self.collection.frame.size.width;
        self.pageCollection.currentPage = self.collection.contentOffset.x / pageWidth + 1;
    }
}

-(IBAction)backButton:(id)sender{
    NSArray *visibleItems = [self.collection indexPathsForVisibleItems];
    NSIndexPath *currentItem = [visibleItems objectAtIndex:0];
    NSIndexPath *nextItem = [NSIndexPath indexPathForItem:currentItem.item - 1 inSection:currentItem.section];
    if (currentItem.item != 0) {
        [self.collection scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        CGFloat pageWidth = self.collection.frame.size.width;
        self.pageCollection.currentPage = self.collection.contentOffset.x / pageWidth - 1;
    }
}

#pragma mark Own Methods

-(void)pasarInicio{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"TabBar"];
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)pasarLogin{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InicioSesionViewController *inicioSesionViewController = [story instantiateViewControllerWithIdentifier:@"InicioSesionViewController"];
    [self.navigationController pushViewController:inicioSesionViewController animated:NO];
}

#pragma mark - WebService

-(void)requestServerToken{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerToken) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerToken{
    
    _tokenWeb = [RequestUrl obtenerToken];
    [self performSelectorOnMainThread:@selector(ocultarCargandoToken) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoToken{
    if ([_tokenWeb length]>0) {
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:_tokenWeb forKey:@"tokeweb"];
        NSLog(@"Token Con exito %@",[_defaults objectForKey:@"tokeweb"]);
    }else{
        [self requestServerToken];
    }
}


#pragma mark - IBActions

-(IBAction)btnSaltarIntro:(id)sender{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"YES" forKey:@"presentacion"];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InicioSesionViewController *inicioSesionViewController = [story instantiateViewControllerWithIdentifier:@"InicioSesionViewController"];
    [self.navigationController pushViewController:inicioSesionViewController animated:YES];
}

#pragma mark - CollectionView Delegates


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PresentacionCollectionViewCell";
    
    PresentacionCollectionViewCell *cell = (PresentacionCollectionViewCell *)[self.collection dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSLog(@"%f",cell.topLabel.constant);
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        cell.topLabel.constant = 390;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        cell.topLabel.constant = 450;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        cell.topLabel.constant = 520;
    }
    [self.view layoutIfNeeded];
    
    cell.imgPresentacion.image = [UIImage imageNamed:[[_data objectAtIndex:indexPath.row] objectForKey:@"logo"]];
    
    cell.imgPresentacion.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.lblDescription.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"descripcion"];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collection.frame.size.width, self.collection.frame.size.height);
}

#pragma mark - ScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collection.frame.size.width;
    self.pageCollection.currentPage = self.collection.contentOffset.x / pageWidth;
}

#pragma mark - showAlert metodo

-(void)showAlert:(NSMutableDictionary *)msgDict
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[msgDict objectForKey:@"Title"]
                                 message:[msgDict objectForKey:@"Message"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if ([[msgDict objectForKey:@"Cancel"] length]>0) {
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[msgDict objectForKey:@"Cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
    }else{
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
