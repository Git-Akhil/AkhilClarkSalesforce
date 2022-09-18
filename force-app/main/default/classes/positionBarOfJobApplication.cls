public class positionBarOfJobApplication {
    public id PositionID{get;set;}
    public list<Position__c> positionRecord{get;set;}
    public positionBarOfJobApplication(ApexPages.StandardsetController controller){
        positionRecord = [select id,name,Total_Open_Pos__c,Total_Close_Pos__c from Position__c];
    }
    public positionBarOfJobApplication(ApexPages.StandardController controller){
        PositionID = ApexPages.currentPage().getparameters().get('id');
    }
    public list<Wrapper> getListWrapper(){
        list<Job_Application__c> OpenjobAppList = [select name,Job_status__c from Job_Application__c where Position__c =:PositionID and Job_status__c ='Open'];
        list<Job_Application__c> ClosejobAppList = [select name,Job_status__c from Job_Application__c where Position__c =:PositionID and Job_status__c ='Close'];
        list<Wrapper> WrapList = new list<Wrapper>();
        WrapList.add(new Wrapper('Open',OpenjobAppList.size()));
        WrapList.add(new Wrapper('Close',ClosejobAppList.size()));
        return WrapList;
    }
    public List<wrapper> getOpenCloseCount(){
        list<wrapper> ListWrapper = new list<wrapper>();
        for(Position__c posObj:positionRecord){
            ListWrapper.add(new wrapper(posObj.Name,posObj.Total_Open_Pos__c,posObj.Total_Close_Pos__c));
        }
        return ListWrapper;
    }
    //wrap class 
    public class Wrapper{
        public string Openclose{get;set;}
        public integer count{get;set;}
        public string PosName{get;set;}
        public Decimal OpenCount{get;set;}
        public Decimal CloseCount{get;set;}
        public Wrapper(string mystr,integer mycount){
            this.Openclose = mystr;
            this.count = mycount;
        }
        public Wrapper(string myName,Decimal myOpenCount,Decimal myCloseCount){
            this.PosName = myName;
            this.OpenCount = myOpenCount;
            this.CloseCount = myCloseCount;
        }
    }
}

/*system.debug('----- Open JOb Application list -----' +OpenjobAppList);
system.debug('----- Close JOb Application list -----' +ClosejobAppList);
system.debug('----- Open JOb Application list -----' +OpenjobAppList.size());
system.debug('----- Close JOb Application list -----' +ClosejobAppList.size());
system.debug('----- WrapList -----'+WrapList);

/*id POID = PosidObj.id;
system.debug('----- POID -----'+POID);
integer JOBCount = PosVsTotalJob.get(PosidObj);
system.debug('----- JOBCount -----'+JOBCount);*/

//this.PositionId = MyID;
////public id PositionId{get;set;}
//public integer Open{get;set;}
//public integer Close{get;set;}
/*map<Position__c,integer> PosVsTotalJob = new map<Position__c,integer>();
for(Position__c pos: jobAppList){

system.debug('----- pos name -----'+pos.Name);
system.debug('----- pos job size -----'+jobAppList.size());
Position__c positionObj = new Position__c();
positionObj = pos;
PosVsTotalJob.put(pos,jobAppList.size());
}
system.debug('----- map PosVsTotalJob -----'+PosVsTotalJob);
list<Wrapper> WrapList = new list<Wrapper>();
for(Position__c PosidObj : PosVsTotalJob.keyset()){
WrapList.add(new Wrapper(PosidObj.Id,PosidObj.Name,PosVsTotalJob.get(PosidObj)));
}
system.debug('----- WrapList -----'+WrapList);
return WrapList;*/