@isTest(seealldata=false)
public class testclasstest {
    @isTest(seealldata=true)
    public static void test1(){
        System.debug('testval'+[Select id from account limit 1]);
    }
}