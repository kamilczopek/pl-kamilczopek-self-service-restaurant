//
//  CheckoutHandler.swift
//  SelfServiceRestaurant
//
//  Created by Kamil Czopek on 27/06/16.
//  Copyright © 2016 Kamil Czopek. All rights reserved.
//

import PerfectLib

class CheckoutHandler: PageHandler {
    
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        
        let dict:MustacheEvaluationContext.MapType = ["name": "Sasha"]
        
        return dict
    }
    
}