ALTER TABLE FactTable ADD 
    CONSTRAINT FK_FactTable_dimPatient -- Table 1
        FOREIGN KEY (dimPatientPK) REFERENCES dimPatient(dimPatientPK) ON DELETE CASCADE,
    CONSTRAINT FK_FactTable_dimPhysician -- Table 2
        FOREIGN KEY (dimPhysicianPK) REFERENCES dimPhysician(dimPhysicianPK) ON DELETE CASCADE,
    CONSTRAINT FK_FactTable_dimDate -- Table 3
        FOREIGN KEY (dimDatePostPK) REFERENCES dimDate(dimDatePostPK) ON DELETE CASCADE,
    CONSTRAINT FK_FactTable_dimCptCode -- Table 4
        FOREIGN KEY (dimCPTCodePK) REFERENCES dimCptCode(dimCPTCodePK) ON DELETE CASCADE,
    CONSTRAINT FK_FactTable_dimPayer -- Table 5
        FOREIGN KEY (dimPayerPK) REFERENCES dimPayer(dimPayerPK) ON DELETE CASCADE,
    CONSTRAINT FK_FactTable_dimTransaction -- Table 6
        FOREIGN KEY (dimTransactionPK) REFERENCES dimTransaction(dimTransactionPK) ON DELETE CASCADE,
    CONSTRAINT FK_FactTable_dimLocation -- Table 7
        FOREIGN KEY (dimLocationPK) REFERENCES dimLocation(dimLocationPK) ON DELETE CASCADE,
    CONSTRAINT FK_FactTable_dimDiagnosisCode -- Table 8
        FOREIGN KEY (dimDiagnosisCodePK) REFERENCES dimDiagnosisCode(dimDiagnosisCodePK) ON DELETE CASCADE;