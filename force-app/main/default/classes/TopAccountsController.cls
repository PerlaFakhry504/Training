public with sharing class TopAccountsController {
  @AuraEnabled(cacheable=true)
  public static List<Account> getTopAccounts() {
    return[
      SELECT Id, Name, Total_Opportunity_Amount_c__c
      FROM Account
      ORDER BY Total_Opportunity_Amount_c__c DESC
      LIMIT 5
    ];
  }
}
