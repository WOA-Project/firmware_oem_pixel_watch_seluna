/*
New data-base items added by Google
16. 110 and 119 should dial as ECC when no service or limited service in Taiwan.
Add 110 and 119 without any service limitation in MCC = '466' (Taiwan)
*/

INSERT OR REPLACE INTO qcril_properties_table (property, value) VALUES ('qcrildb_version', 16);

INSERT OR REPLACE INTO qcril_emergency_source_mcc_table (MCC, NUMBER, IMS_ADDRESS, SERVICE) VALUES ('466','110','','');
INSERT OR REPLACE INTO qcril_emergency_source_mcc_table (MCC, NUMBER, IMS_ADDRESS, SERVICE) VALUES ('466','119','','');
INSERT OR REPLACE INTO qcril_emergency_source_voice_table (MCC, NUMBER, IMS_ADDRESS, SERVICE) VALUES ('466','110','','full');
INSERT OR REPLACE INTO qcril_emergency_source_voice_table (MCC, NUMBER, IMS_ADDRESS, SERVICE) VALUES ('466','119','','full');
