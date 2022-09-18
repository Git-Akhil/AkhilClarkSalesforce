trigger RestrictInvoiceDeletion on Invoice_Statement__c (before delete) {
    for(Invoice_Statement__c invoice : [select id from Invoice_Statement__c where id in (select Invoice_Statement__c from Line_Item__c) and id in :trigger.old]){
        trigger.oldmap.get(invoice.id).addError('can not delete invoice with line item');       
    }

}