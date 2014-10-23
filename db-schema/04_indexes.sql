PROMPT CEATING IDEXES
/*
CREATE OR REPLACE INDEX user_nick_idx
	(UPPER(dev_ts.users.nick)) COMPUTE STATISTICS;

CREATE OR REPLACE INDEX product_name_idx
	(UPPER(dev_ts.products.name));
	
CREATE OR REPLACE INDEX product_feature_feat_idx
	(DEV_TS.PRODUCT_FEATURES.FEATure_id);



*/

CREATE INDEX upper_feature_type_idx
ON FEATURES
	(UPPER(feature_type));

CREATE INDEX upper_feature_name_idx
ON FEATURES
	(UPPER(feature_name));
	
CREATE INDEX upper_product_name_idx
ON PRODUCTS
	(UPPER(name));
	
/* Created by Julia Osiak, PJWSTK 2014, Bachelor of Science Thesis */