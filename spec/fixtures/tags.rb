# Phase 2 (XML)
FIXTURES_XML_TAGS = {
  xml_invoice_hash: "IMrlHO1gbqbjsx6jC01lb677OP5XwyjInXSqnWH55bk=",
  ecdsa_signature: "MEUCIC/QVP5KzXmA0EV02ORa32JJyP78tdsUzYI8kKoOBnyAAiEA2nNQZKNgnUruakSXmV4M+MstX91zlkg51iTMWm0wQcM=",
  ecdsa_public_key: "0V0\x10\x06\a*\x86H\xCE=\x02\x01\x06\x05+\x81\x04\x00\n\x03B\x00\x04a\x83\f\xA0\xE6\x85`\bL;\xFB-z\x8B_g&\xAF\xAF\xAAu\xD5$\xA5\xC2\xC2\xBDk9\xAC-\x8E\xDB\xD5\xBF\x85.\x1A\x8C\x02\xB8A\xD9\xDA\x87)\xBA1\xA8\xA3_\xBEB\x83x\xF8i\xAA;\xA2\xE6\x17'\xD1",
  ecdsa_stamp_signature: "0F\x02!\x00\xEEa\xD3\xEB(<\xE6;P\x19jw3\xBBOO\xB2d\xDB\xEC\xEC\xBDQ\xC6\xB3v\xD4\xE5\x9E\xD8\x13\xAF\x02!\x00\xFA\xD1\xE6\xD0jf#b\xF7^nqc5\xFCx_\x87h\xA7\xB2\xEC\x10\x11B5+\vcB\x05i"
}.freeze

FIXTURES_TAGS = {
  seller_name: "Mrsool",
  vat_registration_number: "310228833400003",
  timestamp: "2021-10-20T19:29:32Z",
  vat_total: "15",
  invoice_total: "115",
  **FIXTURES_XML_TAGS
}.freeze

FIXTURES_UNICODE_TAGS = {
  seller_name: "مرسول",
  vat_registration_number: "310228833400003",
  timestamp: "2021-10-20T19:29:32Z",
  vat_total: "15",
  invoice_total: "115",
  **FIXTURES_XML_TAGS
}.freeze
