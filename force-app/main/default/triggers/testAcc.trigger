trigger testAcc on Account (before update) {
   
   List<Account> acclist=new List<Account>();
    acclist=[Select Id,Name from Account where Id !='0017F00000RQsNp' limit 2];
    System.debug(acclist);
    acclist[0].Name='testing';
    acclist[1].Name='test';
    System.debug(acclist);
    System.debug('running');
    }