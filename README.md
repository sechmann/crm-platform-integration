# crm-platform-integration

This package contains the `KafkaMessage__c` sObject and related Apex logic in order to receive JSON payloads representing 
changes from the Kafka CDC pipeline. A trigger on the `KafkaMessage__c` sObject will create enqueue asynchronous processing
request through the asynchronous processing framework that is part of the crm-platform-base package. 

## Custom Metadata Bindings

The framework depends on two custom metadata objects in order to dynamically instruct the application how to handle the message payload. 

### AsyncRequestHandlerBinding_mdt
Binding between the asynchronous processing request (`AsyncRequest__c`) type created by this package and the `KafkaMessageAsyncJob` class
in order to instruct the asynchronous processing framework to call the `KafkaMessageAsyncJob` class in order to handle
requests originating from this package. 

### KafkaMessageHandlerBinding_mdt
Binding between the KafkaMessage__c.Topic__c field and an Apex handler class for a given Topic in order to instruct the
application on how to handle a message payload related to a specific Kafka topic. 


## Execution Flow
1. An external application inserts a record or batch or records into the KafkaMessage__c sObject
2. A trigger on the KafkaMessage__c object insert one record into the AsyncRequest__c object for each batch of up to 200 
KafkaMessage__c records created in a single transaction, representing a a request for asynchronous processing of the new
messages.
3. When the asynchronous processing framework processes the request, the custom metadata binding `AsyncRequestHandlerBinding_mdt` 
instructs the application to handle the request using the `KafkaMessageAsyncJob` Apex class. 
    - If no `AsyncRequestHandlerBinding_mdt` record is found corresponding to the "Kafka Message" AsyncRequestType__c value,
the `AsyncRequest__c` record is updated with an error. 
4. The `KafkaMessageAsyncJob` queries for the relevant KafkaMessage__c records by the Ids stored in the async processing 
request and queries the `KafkaMessageHandlerBinding_mdt` custom metadata object for registered bindings between `KafkaMessage__c.Topic__c`
values and corresponding Apex classes to handle payloads corresponding to Topic__c values. 
    - If no `KafkaMessageHandlerBinding_mdt` record is found corresponding to the `Topic__c` value, the relevant
`KafkaMessage__c` record is updated with an error. The message kan then be retried after the error has been addressed.
5. The Apex class registered by the `KafkaMessageHandlerBinding_mdt` binding executes the business logic corresponding to the
`Topic__c` value. 
    - If an execption occurs, the relevant`KafkaMessage__c` record is updated with an error. The message kan then be retried
 after the error has been addressed.
