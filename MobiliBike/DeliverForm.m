//
//  DeliverForm.m
//  MobiliBike
//
//  Created by Paulo Cesar on 15/01/17.
//  Copyright © 2017 Paulo Cesar. All rights reserved.
//

#import "DeliverForm.h"

@implementation DeliverForm

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.runDescription = @"oi";
//        self.AddressStreet1 = @"Rua Salema";
//        self.AddressNumber1 = @(486);
//        self.AddressCity1 = @"Bombinhas";
//        
//        self.AddressStreet2 = @"Rua Leopoldo Zarling";
//        self.AddressNumber2 = @(486);
//        self.AddressCity2 = @"Bombinhas";
//    }
//    return self;
//}

-(NSArray *)fields {
    return @[
                @{ FXFormFieldKey: @"runDescription",
                   FXFormFieldTitle: @"Descrição" },
                
                @{ FXFormFieldHeader: @"Ponto de partida",
                   FXFormFieldKey: @"AddressStreet1",
                   FXFormFieldTitle: @"Endereço" },
                
                @{ FXFormFieldKey: @"AddressNumber1",
                   FXFormFieldTitle: @"Número" },
                
                @{ FXFormFieldKey: @"AddressCity1",
                   FXFormFieldTitle: @"Cidade" },
                
                @{ FXFormFieldHeader: @"Ponto de entrega",
                   FXFormFieldKey: @"AddressStreet2",
                   FXFormFieldTitle: @"Endereço" },
                
                @{ FXFormFieldKey: @"AddressNumber2",
                   FXFormFieldTitle: @"Número" },
                
                @{ FXFormFieldKey: @"AddressCity2",
                   FXFormFieldTitle: @"Cidade" },
                
                @{ FXFormFieldKey: @"Calcular rota",
                   FXFormFieldHeader: @"",
                   FXFormFieldAction: @"submit:" }
            ];
}

@end
