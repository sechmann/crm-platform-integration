public inherited sharing class KRP_Persons {
    //public static KRP_Konto getBankkonto(String ident) {
    //    // TPS would take an "update flag" for this method.
    //    // This is now handled by nksDataSyncher
    //    KRP_Konto bankkonto;

    //    try {
    //        HttpResponse resp = KRP_CalloutService.getBankAccount(ident);

    //        if (resp.getStatusCode() == 200) {
    //            bankkonto = String.isNotBlank(resp.getBody())
    //                ? (KRP_Konto) JSON.deserialize(resp.getBody(), KRP_Konto.class)
    //                : null;
    //        } else {
    //            handleError('Kunne ikke hente bankkontonummer', resp);
    //        }
    //    } catch (KRP_PersonsException e) {
    //        throw e;
    //    } catch (Exception e) {
    //        String uuid = logException(e);
    //        throw new KRP_PersonsException(e.getMessage() + ' LoggId: ' + uuid);
    //    }

    //    return bankkonto;
    //}
    public static KRP_Konto getBankkonto(String ident) {
        if (true) {
            logException(new KRP_PersonsException('Oh man!'));
            throw new KRP_PersonsException('Oh geez!');
        } else {
            return new KRP_Konto();
        }
    }

    private static String logException(Exception e) {
        String uuid;
        LoggerUtility logger = new LoggerUtility('KRP');
        logger.exception(e);
        uuid = logger.peek().UUID__c;
        logger.publish();
        return uuid;
    }

    public class KRP_PersonsException extends Exception {
    }

    private static void handleError(String message, HttpResponse resp) {}
}