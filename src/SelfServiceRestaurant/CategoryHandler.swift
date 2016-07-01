//
//  CategoryHandler.swift
//  SelfServiceRestaurant
//
//  Created by Kamil Czopek on 27/06/16.
//  Copyright © 2016 Kamil Czopek. All rights reserved.
//

import PerfectLib

class CategoryHandler: PageHandler {
    
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        
        
        let dict:MustacheEvaluationContext.MapType = ["name": "Sasha"]
        
        
        let params = context.webRequest?.params()
        
        var categoryType = "dairy" // default category type
        if (params?.count > 0) {
            for (name, value) in params! {
                if (name == "selectedCategory") {
                    categoryType = value
                }
            }
        }
        
        return dict
    }
    
}