public class RatingApex {
    @AuraEnabled
    public static list<String> getRating(Id recordId1,String field1){
        Schema.DescribeSObjectResult sObjName = recordId1.getSObjectType().getDescribe();
        String sObjName1 = recordId1.getSObjectType().getDescribe().getName();
        String queryStr='select '+ field1 + ',RecordTypeId  from ' + sObjName1+' where Id =\''+recordId1+'\'';
        String recordTypename='test';
        List<Sobject> results=Database.query(queryStr);
        if(results[0].get('RecordTypeId')!=null){
        String val1=results[0].get('RecordTypeId').toString();
         recordTypename= Schema.getGlobalDescribe().get(sObjName1).getDescribe().getRecordTypeInfosById().get(val1).getName();
        }
            String picklist='hello';
            
        List<Account__c> mcs = Account__c.getall().values();
        for(Account__c a:mcs){
            if(a.Record_Type__c==recordTypename){
              picklist=a.Picklist_Values__c;  
            }
        }
		System.debug(picklist);
        
        
  List<String> lstPickvals=new List<String>();
    Map<String, Schema.SObjectField> field_map = sObjName.fields.getMap(); //get a map of fields for the passed sobject
    List<Schema.PicklistEntry> pick_list_values = field_map.get(field1).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
    for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
      lstPickvals.add(a.getValue());//add the value  to our final list
   }
        String val=results[0].get(field1).toString();
        System.debug(val);
        Integer count=0;
        while(count<lstPickvals.size()){
                            System.debug(picklist);

            Integer n=picklist.indexOf(',');
            System.debug(n);
            if(n!=-1){
            String s2 = picklist.substring(0,n);
            lstPickvals[count]=s2;
                picklist=picklist.substring(n+1,picklist.length());
            }
            else{
               lstPickvals[count]=picklist; 
            }
            count++;
        }
        lstPickvals.add(val);
        System.debug(lstPickvals);
       return lstPickvals;
    }
    @AuraEnabled
        public static void updateStar(Id recordId,String starAmount,String field1){
                    String sObjName1 = recordId.getSObjectType().getDescribe().getName();
            System.debug(starAmount);
Map<String, Schema.SObjectType> m_objects = Schema.getGlobalDescribe();
sObject n = m_objects.get(sObjName1).newSObject();
n.put('Id',recordId);
n.put(field1,starAmount);
            Update n;

	    }

   
}