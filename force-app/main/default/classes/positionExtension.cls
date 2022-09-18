public class positionExtension{
    private Final Position__c position;
    Public string positionTypeId{get; set;}
    Public positionExtension(Apexpages.Standardcontroller positioncontroller){
        this.position = (Position__c)positioncontroller.getRecord();
    }
    public list<selectoption> positionTypeOption{
    get{
        List<selectOption> positionType = new List<selectOption>();
        for(Position__c ptr:[select name from Position__c pt where pt.Department__c = :position.Department__c order By name]){
            positionType.add(new selectoption(ptr.id,ptr.name));
        }
        return positionType;
    }
    private set;}
}