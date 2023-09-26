create or replace view CP_STG_VW(
	ID,
	TRANSACTION_PRO_DATE,
	TRANSACTION_TYPE_CODE,
	TRANSACTION_CODE,
	WRITTEN_PREMIUM_AMT,
	CHARGE_TYPECODE,
	TOTALPREMIUMRPT,
	TOTALREPORTEDPREMIUM,
	PCTL_TYPECODE,
	TAX_AMOUNT,
	FEE_AMOUNT,
	SURCHARGE_AMOUNT,
	PREM_BASIS_AMT,
	AMOUNT,
	ACTUALAMOUNT,
	TRANSACTION_AMOUNT,
	ACCTG_PRD_ID,
	TRANS_EFF_DATE,
	TRANS_EXP_DATE,
	RISK_TYPE_CODE,
	PREM_FULLY_EARNED_FL,
	CURRENCY_CODE,
	INFORCE_PREM_AMOUNT
) as
WITH CTE_TRANSACTION_TYPE_CODE (TRANSACTION_TYPE_CODE,PC_CPCOST_ID) AS
--CALCULATION OF TRANSACTION_TYPE_CODE
(SELECT dl_pc_ext.ET_pctl_cpcost.TYPECODE as TRANSACTION_TYPE_CODE,dl_pc_ext.ET_PC_CPCOST.ID AS PC_CPCOST_ID
from dl_pc_ext.ET_pctl_cpcost left outer join dl_pc_ext.ET_PC_CPCOST
on dl_pc_ext.ET_pctl_cpcost.id = dl_pc_ext.ET_PC_CPCOST.SUBTYPE),
CTE_TRANSACTION_CODE (TRANSACTION_CODE,PC_JOB_ID) AS
--CALCULATION OF TRANSACTION_CODE
(select dl_pc_ext.et_pctl_job.TYPECODE as TRANSACTION_CODE, dl_pc_ext.et_pc_JOB.ID AS PC_JOB_ID
from dl_pc_ext.et_pctl_job left outer join dl_pc_ext.et_pc_JOB 
on dl_pc_ext.et_pctl_job.id = dl_pc_ext.et_pc_JOB.SUBTYPE),
CTE_CHARGE_TYPECODE(CHARGE_TYPECODE,PC_BOPCOST_ID) AS
--CALCULATION OF CHARGE_TYPECODE
(select  dl_pc_ext.et_pctl_chargepattern.TYPECODE as CHARGE_TYPECODE,dl_pc_ext.et_pc_BOPCOST.ID AS PC_BOPCOST_ID
from dl_pc_ext.et_pctl_chargepattern left outer join dl_pc_ext.et_pc_BOPCOST
on dl_pc_ext.et_pctl_chargepattern.id = dl_pc_ext.et_pc_BOPCOST.CHARGEPATTERN),
CTE_CURRENCY_CODE (CURRENCY_CODE,PC_CPTRANSACTION_ID) AS
--CALCULATION OF CURRENCY_CODE
(SELECT dl_pc_ext.et_pctl_currency.TYPECODE AS CURRENCY_CODE,dl_pc_ext.et_PC_CPTRANSACTION.ID AS PC_CPTRANSACTION_ID
FROM dl_pc_ext.et_pctl_currency LEFT OUTER JOIN dl_pc_ext.et_PC_CPTRANSACTION
ON dl_pc_ext.et_pctl_currency.ID = dl_pc_ext.et_PC_CPTRANSACTION.AMOUNT_CUR),
CTE_PCTL_TYPECODE (PCTL_TYPECODE,PC_POLICYPERIOD_ID) AS
--CALCULATION OF PCTL_TYPECODE
(SELECT dl_pc_ext.et_pctl_policyperiodstatus.TYPECODE as PCTL_TYPECODE,dl_pc_ext.et_pc_POLICYPERIOD.ID AS PC_POLICYPERIOD_ID
FROM dl_pc_ext.et_pctl_policyperiodstatus LEFT OUTER JOIN dl_pc_ext.et_pc_POLICYPERIOD
ON dl_pc_ext.et_pctl_policyperiodstatus.ID = dl_pc_ext.et_pc_POLICYPERIOD.STATUS)

SELECT
dl_pc_ext.et_pc_CPTRANSACTION.ID AS ID,
cast(dl_pc_ext.et_pc_JOB.CLOSEDATE AS DATETIME) as TRANSACTION_PRO_DATE,
TRANSACTION_TYPE_CODE, 
TRANSACTION_CODE,
CASE WHEN (CTE_CHARGE_TYPECODE.CHARGE_TYPECODE='Premium' AND dl_pc_ext.et_PC_CPTRANSACTION.CHARGED=1) THEN dl_pc_ext.et_PC_CPTRANSACTION.AMOUNT ELSE 0 END AS WRITTEN_PREMIUM_AMT,
CHARGE_TYPECODE,
dl_pc_ext.et_pc_POLICYPERIOD.TOTALPREMIUMRPT AS TOTALPREMIUMRPT,
dl_pc_ext.et_pc_POLICYTERM.TOTALREPORTEDPREMIUM AS TOTALREPORTEDPREMIUM,
PCTL_TYPECODE,
CASE WHEN (CTE_CHARGE_TYPECODE.CHARGE_TYPECODE = 'Taxes') THEN dl_pc_ext.et_PC_CPTRANSACTION.AMOUNT ELSE 0 END AS TAX_AMOUNT,
CASE WHEN(CTE_CHARGE_TYPECODE.CHARGE_TYPECODE='InstallmentFee' OR CTE_CHARGE_TYPECODE.CHARGE_TYPECODE='ReinstatementFee') THEN
dl_pc_ext.et_PC_CPTRANSACTION.AMOUNT ELSE 0 END AS FEE_AMOUNT,
CASE WHEN (CTE_CHARGE_TYPECODE.CHARGE_TYPECODE='Surcharges') THEN dl_pc_ext.et_PC_CPTRANSACTION.AMOUNT ELSE 0 END AS SURCHARGE_AMOUNT,
CAST(dl_pc_ext.et_pc_CPCOST.BASIS AS DECIMAL) AS PREM_BASIS_AMT,
CAST(dl_pc_ext.et_PC_CPTRANSACTION.AMOUNT AS DECIMAL) AS AMOUNT,
CAST(dl_pc_ext.et_pc_CPCOST.ACTUALAMOUNT AS DECIMAL) AS ACTUALAMOUNT,
dl_pc_ext.et_PC_CPTRANSACTION.AMOUNT as TRANSACTION_AMOUNT,
TO_CHAR(DL_PC_EXT.et_PC_CPTRANSACTION.WRITTENDATE,'MMYYYY')::NUMBER AS ACCTG_PRD_ID,
CAST(dl_pc_ext.et_PC_CPTRANSACTION.EFFDATE AS DATETIME) AS TRANS_EFF_DATE,
cast(dl_pc_ext.et_PC_CPTRANSACTION.EXPDATE AS DATETIME) AS TRANS_EXP_DATE,
'BA' AS RISK_TYPE_CODE,
CASE WHEN (dl_pc_ext.et_PC_CPTRANSACTION.Written = 1 AND dl_pc_ext.et_PC_CPTRANSACTION.TOBEACCRUED =1) THEN 'Y' ELSE 'N' END AS PREM_FULLY_EARNED_FL,
CURRENCY_CODE,
CASE WHEN (CTE_CHARGE_TYPECODE.CHARGE_TYPECODE='Premium' AND dl_pc_ext.et_PC_CPTRANSACTION.CHARGED=1 )THEN dl_pc_ext.et_PC_CPTRANSACTION.AMOUNT ELSE 0 END AS INFORCE_PREM_AMOUNT
FROM DL_PC_EXT.ET_PC_CPTRANSACTION LEFT OUTER JOIN DL_PC_EXT.ET_PC_cpcost 
ON DL_PC_EXT.ET_PC_CPTRANSACTION.CPCOST = DL_PC_EXT.ET_PC_CPCOST.ID

LEFT OUTER JOIN DL_PC_EXT.ET_PC_POLICYPERIOD
ON DL_PC_EXT.ET_PC_CPTRANSACTION.BRANCHID = DL_PC_EXT.ET_PC_POLICYPERIOD.ID

LEFT OUTER JOIN DL_PC_EXT.ET_PC_POLICYPERIOD AS PC_POLICYPERIOD_1 ON 
DL_PC_EXT.ET_PC_CPCOST.BRANCHID = PC_POLICYPERIOD_1.ID

LEFT OUTER JOIN DL_PC_EXT.ET_PC_POLICY
ON DL_PC_EXT.ET_PC_POLICYPERIOD.POLICYID = DL_PC_EXT.ET_PC_POLICY.ID

LEFT OUTER JOIN DL_PC_EXT.ET_PC_CPBUILDINGCOV
ON 
DL_PC_EXT.ET_PC_CPCOST.BRANCHID = DL_PC_EXT.ET_PC_CPBUILDINGCOV.BRANCHID and
DL_PC_EXT.ET_PC_CPCOST.CPBUILDINGCOV = DL_PC_EXT.ET_PC_CPBUILDINGCOV.FIXEDID and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE >= COALESCE(DL_PC_EXT.ET_PC_CPBUILDINGCOV.EFFECTIVEDATE ,PC_POLICYPERIOD_1.PERIODSTART) and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE < COALESCE(DL_PC_EXT.ET_PC_CPBUILDINGCOV.EXPIRATIONDATE , PC_POLICYPERIOD_1.PERIODEND)

LEFT OUTER JOIN DL_PC_EXT.ET_PC_CPBUILDING
ON 
DL_PC_EXT.ET_PC_CPBUILDINGCOV.BRANCHID = DL_PC_EXT.ET_PC_CPBUILDING.BRANCHID and
DL_PC_EXT.ET_PC_CPBUILDINGCOV.CPBUILDING = DL_PC_EXT.ET_PC_CPBUILDING.FIXEDID and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE >= COALESCE(DL_PC_EXT.ET_PC_CPBUILDING.EFFECTIVEDATE ,PC_POLICYPERIOD_1.PERIODSTART)  and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE < COALESCE(DL_PC_EXT.ET_PC_CPBUILDING.EXPIRATIONDATE,PC_POLICYPERIOD_1.PERIODEND)

LEFT OUTER JOIN DL_PC_EXT.ET_PC_building
ON 
DL_PC_EXT.ET_PC_CPBUILDING.BRANCHID = DL_PC_EXT.ET_PC_BUILDING.BRANCHID and
DL_PC_EXT.ET_PC_CPBUILDING.BUILDING = DL_PC_EXT.ET_PC_BUILDING.FIXEDID and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE >= COALESCE(DL_PC_EXT.ET_PC_BUILDING.EFFECTIVEDATE,PC_POLICYPERIOD_1.PERIODSTART) and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE < COALESCE( DL_PC_EXT.ET_PC_BUILDING.EXPIRATIONDATE,PC_POLICYPERIOD_1.PERIODEND)

LEFT OUTER JOIN DL_PC_EXT.ET_PC_policylocation 
ON 
DL_PC_EXT.ET_PC_BUILDING.BRANCHID = DL_PC_EXT.ET_PC_POLICYLOCATION.BRANCHID and
DL_PC_EXT.ET_PC_BUILDING.POLICYLOCATION = DL_PC_EXT.ET_PC_POLICYLOCATION.FIXEDID and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE >=COALESCE(DL_PC_EXT.ET_PC_POLICYLOCATION.EFFECTIVEDATE,PC_POLICYPERIOD_1.PERIODSTART) AND 
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE < COALESCE(DL_PC_EXT.ET_PC_POLICYLOCATION.EXPIRATIONDATE,PC_POLICYPERIOD_1.PERIODEND)

LEFT OUTER JOIN DL_PC_EXT.ET_PC_job
ON DL_PC_EXT.ET_PC_JOB.ID = DL_PC_EXT.ET_PC_POLICYPERIOD.JOBID

LEFT OUTER JOIN DL_PC_EXT.ET_PC_effectivedatedfields 
ON 
DL_PC_EXT.ET_PC_CPCOST.BRANCHID = DL_PC_EXT.ET_PC_EFFECTIVEDATEDFIELDS.BRANCHID and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE >= COALESCE(DL_PC_EXT.ET_PC_EFFECTIVEDATEDFIELDS.EFFECTIVEDATE,PC_POLICYPERIOD_1.PERIODSTART) and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE < COALESCE(DL_PC_EXT.ET_PC_EFFECTIVEDATEDFIELDS.EXPIRATIONDATE,PC_POLICYPERIOD_1.PERIODEND)

LEFT OUTER JOIN DL_PC_EXT.ET_PC_policylocation AS PC_policylocation_1
ON 
DL_PC_EXT.ET_PC_EFFECTIVEDATEDFIELDS.BRANCHID = PC_POLICYLOCATION_1.BRANCHID and
DL_PC_EXT.ET_PC_EFFECTIVEDATEDFIELDS.PRIMARYLOCATION = PC_POLICYLOCATION_1.FIXEDID and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE >= COALESCE (PC_POLICYLOCATION_1.EFFECTIVEDATE,PC_POLICYPERIOD_1.PERIODSTART) and
PC_POLICYPERIOD_1.EDITEFFECTIVEDATE < COALESCE(PC_POLICYLOCATION_1.EXPIRATIONDATE,PC_POLICYPERIOD_1.PERIODEND)
LEFT OUTER JOIN  DL_PC_EXT.ET_PC_AUDITINFORMATION ON
DL_PC_EXT.ET_PC_AUDITINFORMATION.ID = DL_PC_EXT.ET_PC_JOB.AUDITINFORMATIONID
    JOIN CTE_TRANSACTION_TYPE_CODE    ON (dl_pc_ext.et_pc_CPTRANSACTION.CPCost = CTE_TRANSACTION_TYPE_CODE.PC_CPCOST_ID )
    LEFT OUTER JOIN CTE_TRANSACTION_CODE ON ( dl_pc_ext.et_pc_CPTRANSACTION.ID = CTE_TRANSACTION_CODE.PC_JOB_ID)
    LEFT OUTER JOIN CTE_CHARGE_TYPECODE ON (dl_pc_ext.et_pc_CPTRANSACTION.ID = CTE_CHARGE_TYPECODE.PC_BOPCOST_ID)
    LEFT OUTER JOIN CTE_CURRENCY_CODE ON(dl_pc_ext.et_pc_CPTRANSACTION.ID =CTE_CURRENCY_CODE.PC_CPTRANSACTION_ID)
    LEFT OUTER JOIN CTE_PCTL_TYPECODE    ON(dl_pc_ext.et_pc_CPTRANSACTION.ID = CTE_PCTL_TYPECODE.PC_POLICYPERIOD_ID)
    LEFT OUTER JOIN dl_pc_ext.et_pc_POLICYTERM ON (dl_pc_ext.et_pc_CPTRANSACTION.ID =dl_pc_ext.et_pc_POLICYTERM.ID )
    WHERE PCTL_TYPECODE IN ('Bound','AuditComplete');