CREATE OR REPLACE stage EXT_AZURE_STAGE
URL='azure://insurancetrail.blob.core.windows.net/policy-center'
CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupyx&se=2023-10-07T14:55:13Z&st=2023-09-19T06:55:13Z&spr=https&sig=aMttQM57uqT0aTSK30ibgfpvYvpAzn5ACImPCUfUkF8%3D')