create or replace external table ET_PC_BOPCOST(
	FXRATECONVERSIONUSED NUMBER(38,0) AS (TO_NUMBER(GET($1, 'FXRateConversionUsed'))),
	STANDARDAMOUNTBILLING NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardAmountBilling'))),
	STANDARDAMOUNTBILLING_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardAmountBilling_cur'))),
	FIXEDID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'FixedID'))),
	OVERRIDEREASON VARCHAR(16777216) AS (CAST(GET($1, 'OverrideReason') AS VARCHAR(16777216))),
	OVERRIDETERMAMOUNT NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideTermAmount'))),
	PRORATIONMETHOD NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ProrationMethod'))),
	OVERRIDETERMAMOUNT_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideTermAmount_cur'))),
	BOPLOCATIONCOV NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BOPLocationCov'))),
	OVERRIDABLE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'Overridable'))),
	UPDATETIME TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'UpdateTime') AS TIMESTAMP_NTZ(9))),
	STANDARDTERMAMOUNTBILLING NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardTermAmountBilling'))),
	ID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ID'))),
	STANDARDTERMAMOUNTBILLING_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardTermAmountBilling_cur'))),
	CREATEUSERID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'CreateUserID'))),
	OVERRIDEAMOUNT NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideAmount'))),
	OVERRIDEAMOUNT_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideAmount_cur'))),
	BEANVERSION NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BeanVersion'))),
	BUSINESSOWNERSCOV NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BusinessOwnersCov'))),
	STANDARDADJRATE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardAdjRate'))),
	UPDATEUSERID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'UpdateUserID'))),
	BOPBUILDINGCOV NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BOPBuildingCov'))),
	ROUNDINGMODE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'RoundingMode'))),
	ACTUALADJRATE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualAdjRate'))),
	OVERRIDEADJRATE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'FXRateConversionUsed'))),
	BRANCHID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BranchID'))),
	BASIS NUMBER(38,0) AS (TO_NUMBER(GET($1, 'Basis'))),
	ACTUALBASERATE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualBaseRate'))),
	STANDARDTERMAMOUNT NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardTermAmount'))),
	STANDARDTERMAMOUNT_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardTermAmount_cur'))),
	PUBLICID VARCHAR(16777216) AS (CAST(GET($1, 'PublicID') AS VARCHAR(16777216))),
	TAXSTATE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'TaxState'))),
	CREATETIME TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'CreateTime') AS TIMESTAMP_NTZ(9))),
	RATEBOOK NUMBER(38,0) AS (TO_NUMBER(GET($1, 'RateBook'))),
	CHARGEGROUP VARCHAR(16777216) AS (CAST(GET($1, 'ChargeGroup') AS VARCHAR(16777216))),
	ACTUALTERMAMOUNT NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualTermAmount'))),
	ACTUALTERMAMOUNT_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualTermAmount_cur'))),
	BUSINESSOWNERSLINE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BusinessOwnersLine'))),
	EFFECTIVEDATE TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'EffectiveDate') AS TIMESTAMP_NTZ(9))),
	ACTUALAMOUNTBILLING NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualAmountBilling'))),
	STANDARDAMOUNT NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardAmount'))),
	ACTUALAMOUNTBILLING_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualAmountBilling_cur'))),
	STANDARDAMOUNT_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardAmount_cur'))),
	OVERRIDEAMOUNTBILLING NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideAmountBilling'))),
	OVERRIDEAMOUNTBILLING_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideAmountBilling_cur'))),
	CHARGEPATTERN NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ChargePattern'))),
	EXPIRATIONDATE TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'ExpirationDate') AS TIMESTAMP_NTZ(9))),
	ONPREMISES NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OnPremises'))),
	ADDITIONALINSURED NUMBER(38,0) AS (TO_NUMBER(GET($1, 'AdditionalInsured'))),
	POLICYFXRATE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'PolicyFXRate'))),
	ACTUALAMOUNT NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualAmount'))),
	SUBJECTTOREPORTING NUMBER(38,0) AS (TO_NUMBER(GET($1, 'SubjectToReporting'))),
	OVERRIDESOURCE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideSource'))),
	ACTUALAMOUNT_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualAmount_cur'))),
	ARCHIVEPARTITION NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ArchivePartition'))),
	ACTUALTERMAMOUNTBILLING NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualTermAmountBilling'))),
	CHANGETYPE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ChangeType'))),
	ACTUALTERMAMOUNTBILLING_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ActualTermAmountBilling_cur'))),
	OVERRIDETERMAMOUNTBILLING NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideTermAmountBilling'))),
	OVERRIDETERMAMOUNTBILLING_CUR NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideTermAmountBilling_cur'))),
	BASEDONID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BasedOnID'))),
	NUMDAYSINRATEDTERM NUMBER(38,0) AS (TO_NUMBER(GET($1, 'NumDaysInRatedTerm'))),
	STANDARDBASERATE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'StandardBaseRate'))),
	ROUNDINGLEVEL NUMBER(38,0) AS (TO_NUMBER(GET($1, 'RoundingLevel'))),
	RATEAMOUNTTYPE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'RateAmountType'))),
	BOPBUILDING NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BOPBuilding'))),
	SUBTYPE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'Subtype'))),
	OVERRIDEBASERATE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'OverrideBaseRate'))))
location=@CSVLOADING/
auto_refresh=false
pattern='.*dbo_PC_BOPCOST_.*'
file_format=(TYPE=PARQUET NULL_IF=())
;