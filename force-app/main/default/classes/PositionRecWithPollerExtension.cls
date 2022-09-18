public class PositionRecWithPollerExtension{
    public list<Position__c> positionRecord{get;set;}
    public PositionRecWithPollerExtension(Apexpages.StandardSetController controller){
        positionRecord = [select id,name,Total_Open_Pos__c,Total_Close_Pos__c from Position__c];
    }
    public List<wrapper2> getOpenCloseCount(){
        list<wrapper2> ListWrapper = new list<wrapper2>();
        for(Position__c posObj:positionRecord){
            ListWrapper.add(new wrapper2(posObj.Name,posObj.Total_Open_Pos__c,posObj.Total_Close_Pos__c));
        }
        return ListWrapper;
    }
    public class wrapper2{
        public string PosName{get;set;}
        public Decimal OpenCount{get;set;}
        public Decimal CloseCount{get;set;}
        public Wrapper2(string myName,Decimal myOpenCount,Decimal myCloseCount){
            this.PosName = myName;
            this.OpenCount = myOpenCount;
            this.CloseCount = myCloseCount;
        }
    }
}

/*system.debug('----- positionRecord -----'+positionRecord);
system.debug('----- positionRecord -----'+positionRecord.size());
system.debug('----- ListWrapper -----'+ListWrapper);
system.debug('----- ListWrapper -----'+ListWrapper.size());*/