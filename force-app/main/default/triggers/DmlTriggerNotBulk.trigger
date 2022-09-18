trigger DmlTriggerNotBulk on Account (before update) {
    list<Opportunity> relatopp = [select id, name , Probability from Opportunity where AccountId in : Trigger.new];
    for (Opportunity opp :relatopp ){
        if ((opp.Probability >= 50) && (opp.Probability <100)){
            opp.description ='new description for opportunity';
            update opp;
        }
    }
    

}