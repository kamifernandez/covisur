//
//  TerminosCondicionesViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 21/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TerminosCondicionesViewController : UIViewController

@property(nonatomic,weak)IBOutlet UITextView * tvtTerminos;

@property(nonatomic,strong)NSMutableArray * dataServices;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
