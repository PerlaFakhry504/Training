public with sharing class WorkOrderHelper{

    @AuraEnabled(cacheable=true)
    public static Map<String, List<ContentDocument>> getRelatedDocuments(Id workOrderId) {
        Map<String, List<ContentDocument>> result = new Map<String, List<ContentDocument>>();

        if (workOrderId == null) return result;

        WorkOrder wo = [
            SELECT Id, AccountId, ContactId 
            FROM WorkOrder 
            WHERE Id = :workOrderId 
            LIMIT 1
        ];

        Set<Id> entityIds = new Set<Id>{ workOrderId };
        if (wo.AccountId != null) entityIds.add(wo.AccountId);
        if (wo.ContactId != null) entityIds.add(wo.ContactId);

        List<ContentDocumentLink> docLinks = [
            SELECT ContentDocumentId, LinkedEntityId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId IN :entityIds
        ];

        Set<Id> docIds = new Set<Id>();
        Map<Id, String> docToSourceMap = new Map<Id, String>();

        for (ContentDocumentLink link : docLinks) {
            docIds.add(link.ContentDocumentId);
            if (link.LinkedEntityId == wo.AccountId) {
                docToSourceMap.put(link.ContentDocumentId, 'Account');
            } else if (link.LinkedEntityId == wo.ContactId) {
                docToSourceMap.put(link.ContentDocumentId, 'Contact');
            } else if (link.LinkedEntityId == workOrderId) {
                docToSourceMap.put(link.ContentDocumentId, 'Work Order');
            }
        }

        Map<Id, ContentDocument> docMap = new Map<Id, ContentDocument>(
            [SELECT Id, Title FROM ContentDocument WHERE Id IN :docIds]
        );

        for (Id docId : docMap.keySet()) {
            String source = docToSourceMap.get(docId);
            if (String.isBlank(source)) continue;

            if (!result.containsKey(source)) {
                result.put(source, new List<ContentDocument>());
            }
            result.get(source).add(docMap.get(docId));
        }

        return result;
    }

    @AuraEnabled
    public static void submitReview(
        Id workOrderId,
        String missingInfoDescription,
        List<String> selectedFileIds,
        List<String> requestedFileNames,
        List<String> requestedFileTypes,
        String accountMissingInfo,
        String contactMissingInfo,
        String workOrderMissingInfo
    ) {
        if (String.isBlank(workOrderId)) {
            throw new AuraHandledException('Missing Work Order Id.');
        }

        WorkOrder wo = [SELECT Id, Status FROM WorkOrder WHERE Id = :workOrderId LIMIT 1];
        if (wo.Status != 'Submitted') {
            throw new AuraHandledException('Only Submitted Work Orders can be called for review.');
        }

        // Update status + main missing info
        wo.Status = 'Call for Review';
        wo.Description = missingInfoDescription; // If you use `Description` on WorkOrder
        update wo;

        List<Document_to_Review__c> reviewDocs = new List<Document_to_Review__c>();

        // Selected files → content doc IDs
        for (String fileId : selectedFileIds) {
            if (String.isNotBlank(fileId)) {
                reviewDocs.add(new Document_to_Review__c(
                    Name = 'Selected File',
                    Work_Order__c = workOrderId,
                    Content_Document_Id__c = fileId,
                    Source__c = 'Attached File'
                ));
            }
        }

        // Requested manual documents
        for (Integer i = 0; i < requestedFileNames.size(); i++) {
            String fileName = requestedFileNames[i];
            if (String.isBlank(fileName)) continue;

            String fileType = (i < requestedFileTypes.size()) ? requestedFileTypes[i] : '';
            String missingInfo = '';

            if (fileType == 'Account') {
                missingInfo = accountMissingInfo;
            } else if (fileType == 'Contact') {
                missingInfo = contactMissingInfo;
            } else if (fileType == 'WorkOrder') {
                fileType = 'Work Order';
                missingInfo = workOrderMissingInfo;
            }

            reviewDocs.add(new Document_to_Review__c(
                Name = fileName,
                Work_Order__c = workOrderId,
                Source__c = fileType,
                Requested_Description__c = missingInfo
            ));
        }

        if (!reviewDocs.isEmpty()) {
            insert reviewDocs;
        }
    }
}
