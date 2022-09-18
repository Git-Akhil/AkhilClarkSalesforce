({
    myAction : function(component, event, helper) {
        component.set("v.Columns", [
            {label:"First Name", fieldName:"FirstName", type:"text"},
            {label:"Last Name", fieldName:"LastName", type:"text"},
            {label:"Phone", fieldName:"Phone", type:"phone"}
        ]);
        
        var action = component.get("c.getContacts");
        action.setparams({
            recordId: component.get("v.recordId")	
        });
        action.setcallback(this,function(data){
            component.set("v.contacts",data.getReturnValue()); 
        });
        $A.enqueueAction(action);
    }
})