public with sharing class CaseManagerController {
    
    @AuraEnabled
    public static List<Case> getOpenCases() {
        return [
            SELECT Id, CaseNumber, Subject, Status, Priority
            FROM Case
            WHERE Status != 'Closed'
            ORDER BY CreatedDate DESC
            LIMIT 4
        ];
    }

    @AuraEnabled
    public static void closeCase(Id caseId) {
        if (caseId == null) {
            throw new AuraHandledException('Case Id is required.');
        }

        Case c = [SELECT Id, Status FROM Case WHERE Id = :caseId LIMIT 1];
        c.Status = 'Closed';
        update c;
    }
}
