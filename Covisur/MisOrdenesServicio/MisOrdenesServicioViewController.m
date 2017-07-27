//
//  MisOrdenesServicioViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 10/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MisOrdenesServicioViewController.h"
#import "MisTarjetasViewController.h"
#import "NSMutableAttributedString+Color.h"
#import "utilidades.h"
#import "RequestUrl.h"

@interface MisOrdenesServicioViewController (){
    int dataTable;
    BOOL paso;
    int pagina;
    NSString * tipoServicios;
}

@end

@implementation MisOrdenesServicioViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarVistaMenu)
                                                 name:@"mostrarVistaMenu"
                                               object:nil];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    paso = NO;
    dataTable = 1;
    pagina = 0;
    tipoServicios = @"13";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"No encontramos ordenes activas asociadas a tu cuenta"];
    [string setColorForText:@"No encontramos" withColor:[UIColor colorWithRed:102.0/255.0 green:168.0/255.0 blue:223.0/255.0 alpha:1]];
    [string setColorForText:@"ordenes activas asociadas a tu cuenta" withColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]];
    [self.lblSinDatos setAttributedText:string];
    
    /*+++++Harcode+++++++*/
    
    //// Falta Validadr si no trae tarjetas y mostrar alerta /*++++++++++No existen tarjetas de crédito asociadas a tu cuenta.+++++++*/
    
    /*_data = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSMutableDictionary * dataInsert = [[NSMutableDictionary alloc] init];
        [dataInsert setObject:[NSString stringWithFormat:@"%i",i] forKey:@"id"];
        if (i % 2 == 0) {
            [dataInsert setObject:@"3333333333333333" forKey:@"orden"];
            [dataInsert setObject:@"101010101010" forKey:@"documento"];
            [dataInsert setObject:@"22/05/2017" forKey:@"fecha"];
            NSMutableArray * tempServicios = [[NSMutableArray alloc] init];
            for (int j = 0; j < 10; j++) {
                NSMutableDictionary * temp = [[NSMutableDictionary alloc] init];
                [temp setObject:@"Lorem ipsum dolor sit amet 2" forKey:@"servicio"];
                [tempServicios addObject:temp];
            }
            [dataInsert setObject:tempServicios forKey:@"servicios"];
        }else{
            [dataInsert setObject:@"3333333333333333" forKey:@"orden"];
            [dataInsert setObject:@"101010101010" forKey:@"documento"];
            [dataInsert setObject:@"22/05/2017" forKey:@"fecha"];
            NSMutableArray * tempServicios = [[NSMutableArray alloc] init];
            for (int j = 0; j < 30; j++) {
                NSMutableDictionary * temp = [[NSMutableDictionary alloc] init];
                [temp setObject:@"Lorem ipsum dolor sit amet 2" forKey:@"servicio"];
                [tempServicios addObject:temp];
            }
            [dataInsert setObject:tempServicios forKey:@"servicios"];
        }
        [_data addObject:dataInsert];
        dataInsert = nil;
    }
    [self.tblMisServicios reloadData];*/
    
    [self requestServerServiciosActivos];
}

#pragma mark - Own Methods

-(void)mostrarVistaMenu{
    if (self.vistaMenu == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"VistaMenuPersonal" owner:self options:nil];
        [self.vistaMenu setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height)];
        [self.view addSubview:self.vistaMenu];
        [UIView animateWithDuration:0.5 animations:^{
            
        }completion:^(BOOL finished){
            UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
            [letterTapRecognizer setNumberOfTapsRequired:1];
            [self.vistaContentMenu addGestureRecognizer:letterTapRecognizer];
        }];
    }
}

- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    [self btnMisServicios:nil];
}

#pragma mark - IBActions

-(IBAction)btnVolver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnMisPagos:(id)sender{
    [self btnMisServicios:nil];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MisTarjetasViewController *misTarjetasViewController = [story instantiateViewControllerWithIdentifier:@"MisTarjetasViewController"];
    [self.navigationController pushViewController:misTarjetasViewController animated:YES];
}

-(IBAction)btnMisServicios:(id)sender{
    [self.vistaMenu removeFromSuperview];
    self.vistaMenu = nil;
}

-(IBAction)btnMisTarjetas:(id)sender{
    [self btnMisServicios:nil];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MisTarjetasViewController *misTarjetasViewController = [story instantiateViewControllerWithIdentifier:@"MisTarjetasViewController"];
    [self.navigationController pushViewController:misTarjetasViewController animated:YES];
}

-(IBAction)btnMiCuenta:(id)sender{
    [self btnMisServicios:nil];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MisTarjetasViewController *misTarjetasViewController = [story instantiateViewControllerWithIdentifier:@"MisTarjetasViewController"];
    [self.navigationController pushViewController:misTarjetasViewController animated:YES];
}

-(IBAction)btnServicios:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    pagina = 0;
    if (selectedSegment == 0) {
        dataTable = 1;
        tipoServicios = @"13";
        pagina = 0;
    }else{
        dataTable = 2;
        tipoServicios = @"14";
        pagina = 0;
    }
    [self requestServerServiciosActivos];
}

-(IBAction)btnAgregarOrden:(id)sender{
    [self btnMisServicios:nil];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MisTarjetasViewController *misTarjetasViewController = [story instantiateViewControllerWithIdentifier:@"MisTarjetasViewController"];
    [self.navigationController pushViewController:misTarjetasViewController animated:YES];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"";
    
    if (dataTable == 1) {
        
        CellIdentifier = @"MisServiciosActivosTableViewCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"MisServiciosActivosTableViewCell" owner:self options:nil];
            cell = _celdaTabla;
            self.celdaTabla = nil;
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"MisServiciosfinalizadosTableViewCell" owner:self options:nil];
            cell = _celdaTabla;
            self.celdaTabla = nil;
        }
    }
    
    [self.lblNumeroOrden setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"title"]];
    
    NSString * fecha = [[_data objectAtIndex:indexPath.row] objectForKey:@"created"];
    
    fecha = [fecha stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    [self.lblFecha setText:fecha];
    
    [self.lblNumeroDocumento setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"field_id_number_to_investigate"]];
    
    NSMutableArray * tempServices = [[_data objectAtIndex:indexPath.row] objectForKey:@"field_payment_services"];
    
    int yVista = 160;
    for (int i = 0; i<[tempServices count]; i++) {
        UIView * vista = [[UIView alloc] init];
        [vista setFrame:CGRectMake(100, yVista, 200, 30)];
        
        UILabel * lblServicio = [[UILabel alloc] init];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"* %@",[[tempServices objectAtIndex:i] objectForKey:@"name"]]];
        [string setColorForText:@"*" withColor:[UIColor colorWithRed:102.0/255.0 green:168.0/255.0 blue:223.0/255.0 alpha:1]];
        [string setColorForText:[[tempServices objectAtIndex:i] objectForKey:@"name"] withColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]];
        
        [lblServicio setAttributedText:string];
        [lblServicio setFrame:CGRectMake(0, 0, 200, 20)];
        [lblServicio setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        
        [vista addSubview:lblServicio];
        [cell addSubview:vista];
        
        yVista += 30;
    }
    
    [self.lblValorTotal setText:[NSString stringWithFormat:@"Valor Total $%@",[utilidades decimalNumberFormat:[[[_data objectAtIndex:indexPath.row] objectForKey:@"field_order_total"] intValue]]]];
    
    if (dataTable == 2) {
        [self.vistaRiesgo setFrame:CGRectMake(self.vistaRiesgo.frame.origin.x, yVista +10, self.vistaRiesgo.frame.size.width, self.vistaRiesgo.frame.size.height)];
        [_lblNivelRiesgo setText:[NSString stringWithFormat:@"Nivel de riesgo : %@",[[_data objectAtIndex:indexPath.row] objectForKey:@"field_risk_level"]]];
    }
    
    paso = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * tempServices = [[_data objectAtIndex:indexPath.row] objectForKey:@"field_payment_services"];
    
    int countData = (int)[tempServices count];
    
    int heigthRow = 160;
    
    heigthRow += countData * 30;
    
    heigthRow += 50;
    
    if (dataTable == 2) {
        heigthRow += 86;
    }
    
    return heigthRow;
}

- (void)tableView:(UITableView *)tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_data count]>3) {
        if (indexPath.row == [_data count] - 1 ) {
            //call your method of fetching data with paging which will be increased with 1
            //increase the pagingCount
            [self requestServerServiciosActivos];
            
            //call your data fetcher
        }
    }
}

#pragma mark - Metodos Vista Cargando

-(void)mostrarCargando{
    @autoreleasepool {
        if (_vistaWait.hidden == TRUE) {
            _vistaWait.hidden = FALSE;
            CALayer * l = [_vistaWait layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
            // You can even add a border
            [l setBorderWidth:1.5];
            [l setBorderColor:[[UIColor whiteColor] CGColor]];
            
            [_indicador startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
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

#pragma mark - WebService
#pragma mark - Consulta de Servicios

-(void)requestServerServiciosActivos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerServiciosActivos) object:nil];
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

-(void)envioServerServiciosActivos{
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    //[datosEnvio setObject:[_defaults objectForKey:@"uid"] forKey:@"uid"]; //Poner para produccion
    [datosEnvio setObject:@"60" forKey:@"uid"]; // Poner para Desarrollo
    [datosEnvio setObject:tipoServicios forKey:@"field_order_status"];
    [datosEnvio setObject:[NSString stringWithFormat:@"%i",pagina] forKey:@"pagina"];
    
    NSMutableDictionary * dataTemporal = [RequestUrl obtenerListadoServiciosActivos:datosEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoServiciosActivos:) withObject:dataTemporal waitUntilDone:YES];
}

-(void)ocultarCargandoServiciosActivos:(NSMutableDictionary *)dataTemporal{
    if ([dataTemporal count]>0) {
        _data = nil;
        _data = [[dataTemporal objectForKey:@"list"] copy];
        [self.tblMisServicios reloadData];
        pagina += 1;
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene ordenes activas para mostrar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

@end
