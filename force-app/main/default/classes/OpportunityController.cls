public with sharing class OpportunityController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(Id accountId) {
        return [
            SELECT Id, Name, Amount, StageName
            FROM Opportunity
            WHERE AccountId = :accountId
            ORDER BY Amount DESC
        ];
    }
}
