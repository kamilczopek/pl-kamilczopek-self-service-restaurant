//
//  CatNameHandler.swift
//  SelfServiceRestaurant
//
//  Created by Kamil Czopek on 22/06/16.
//  Copyright © 2016 Kamil Czopek. All rights reserved.
//

import PerfectLib


class CatNameHandler: PageHandler {
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        
        let dict:MustacheEvaluationContext.MapType = ["name": "Sasha"]
        
        return dict
    }
}