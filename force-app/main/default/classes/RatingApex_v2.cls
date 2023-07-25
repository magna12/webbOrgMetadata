public class RatingApex_v2 {
    @AuraEnabled
    public static Integer getRating(Id recordId1){
        Integer starValue=0;
        List<Rating__c> ratingList=new List<Rating__c>();
            ratingList=[SELECT Name,Rating_Value__C From Rating__C where name=:recordId1];
       if (ratingList.isEmpty())
{
    starValue=0;
} else
{
    starValue=ratingList[0].Rating_value__c.intValue();
}
        return starValue;
    }
    @AuraEnabled
    public static void updateStar(Id recordId,Decimal starAmount){
           Rating__C update1=new Rating__c();
            update1=[SELECT Name,Rating_Value__C From Rating__C where name=:recordId];
        update1.Rating_value__c=starAmount;
        update update1;
	    }

}