/*
 * BASE ADDRESSES — Query ID: 7372298
 * ════════════════════════════════════════════════════════════════
 * ВСЕ адреса хранятся как 40-char LOWERCASE HEX (без 0x-префикса).
 * Это единственный формат совместимый с to_hex(t."from") в DuneSQL —
 * т.к. "from"/"to"/"contract_address" везде varbinary.
 *
 * Tron Base58 → hex: сконвертировано через Base58Check decode
 *   (убираем первый байт 0x41 и последние 4 байта checksum = 20 байт)
 *
 * В чарт-запросах используй:
 *   cluster AS (SELECT address FROM query_7372298 WHERE category = 'cluster')
 *   ...
 *   WHERE to_hex(t."from") IN (SELECT address FROM cluster)
 * ════════════════════════════════════════════════════════════════
 */

SELECT address, chain, entity, label, category
FROM (VALUES

    -- ── Ethereum (40-char lowercase hex) ────────────────────────────────
    ('7ff9cfad3877f21d41da833e2f775db0569ee3d9', 'ethereum', 'Garantex',   'Garantex Hot Wallet',   'cluster'),
    ('6fa0be17e4bea2fcfa22ef89bf8ac9aab0ab0fc9', 'ethereum', 'Old Vector', 'A7A5 Token Contract',   'cluster'),
    ('0d57436f2d39c0664c6f0f2e349229483f87ea38', 'ethereum', 'Old Vector', 'wA7A5 Token Contract',  'cluster'),

    -- ── Tron (40-char lowercase hex, конвертировано из Base58) ──────────
    -- A7A5 contract: TLeVfrdym8RoJreJ23dAGyfJDygRtiWKBZ
    ('751f6515e355dc49474a8565a1234bf3424b9fe4', 'tron', 'Old Vector',       'A7A5 Contract (Tron)',  'cluster'),
    -- OFAC SDN-санкционированные Tron-кошельки (entity TBD — проверить по SDN XML)
    ('0529ebc9ff01a4d390f91687d7c7406bf0dab24e', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('0655b7211f302b42a7bfa16a6c45284ab82fd85b', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('091a964948da0f8f638c8b688e391e5a3df1a43e', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('0e6b8e34dc115a2848f585851af23d99d09b8463', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('11fe0fd1a9fb17746eb9877a396ddf1b3a632838', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('17b65262f73d2a8668dededc6a40274c3e0ea058', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('180242dc6b95c786c2d9c397532c679a956a1d12', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('18f703184349667cdae85a07e7f2efac36052b89', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('2020b536fd363c82fc3f6ab26aeea94b4ffa1404', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('2136ed3902c1d7217d9b19cf313bbb035ed9bfd7', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('240fd853e1509a975bd95348d49c923fb0b5d43c', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('283fcf7f260da7c3c9aad91beab58882990a66eb', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('2ec6c5fe3d7acd8e2e6185c17d9acb136e66f3e0', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('3301843d4d8c3314706a6526940bc2a38ed29475', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('3e14d41891a30ac7473556d7c3256a5ddf9ef1aa', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('418949a4a7da9e07192909722072dded8f670d58', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('47df0606a84a52763887d7aa280cc4f068326b16', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('48ea81d8db01cc3f551be8ecc8627b5a803eb075', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('4bae1c4b2167fe4ebcd6d7baac1138d943a2609f', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('6042c2f32769454c5ff226fdae52b81e49cd922f', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('6315bdc714ebb7a08e5ec10f351b6ca61d052bee', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('6e2bf91ff62095e759301a1e46df3278f7d6bf07', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('783a4cc2478f1b44f37052bac72abaa3fc6f992a', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('7de5ab1914e241177344936dc33b4a8157c98248', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('82df92ebaa039dd6c9e0689390d7298a5ca1f59c', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('8660f3ab5285f9e497ffbf2997285c24466aa2a1', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('88ef69134150f35b1e91fa2d8bfbb44ba2c51e62', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('8a33c4dccc7e840e536c1abc9af4612f876f54de', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('8be1904f7e8d196ef670835e2893be5f75c1e63e', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('8c5f37d4db13967643e33d5404f66f86569221ca', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('8d55c4306745f05a31af596c6bfa19374073e797', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('8dd586d12164a98e319607295935ee968919608e', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('9145fc390e71e3b56da4bfe51460cbdbb1a8a3f9', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('9227c54226014afcb588dc49818e28a3a2367557', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('9ab7a3e606677ddf6f3538dd4472ec770c282b3e', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('a6cc8ab881debc3c9e8adb32549d0cbe614168c5', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('ab4302cfcf1c2337c1b59af1d23bd97189fe962c', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('ba475bb43ee21013fd14c85e2c74b24bcf5a54c1', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('be5e683633ddd17d8a89b4e10860a0e426c5ed24', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('bf92b14aa9fd088182178e2ebf208da946521ee5', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('bff703730a21167e430ff151128592a98786b9b4', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('c29c4df7111a39030a037a3abc8dc68c8d1d8ceb', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('c685132e908cce284c063415ea353af5f555c6c6', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('d4e976441a1cad72ee5cbd2fd1b677fe7ce8afdf', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('ee61f0eeee09eed3583baab61fa2e64b96207478', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('f405df57cc3a2df4dd262b6494d76e346ca778f1', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('f8bc582628cd0c721b554161a1cb59ea003742c0', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),
    ('fe88af78cfc99bea57f2fb708489cfc0f0b7f704', 'tron', 'OFAC-Sanctioned', 'Sanctioned Tron Wallet','cluster'),

    -- ── Hack attacker (NOT sanctioned — трекинг) ─────────────────────────
    -- TH9kgjfrKeTNeyXtDKvxCXZ1dVKr7neKVa
    ('4ec77d187b692465fd6ad86db3793c9352df7704', 'tron', 'Hack Attacker', 'Grinex Hack Consolidation (45.89M TRX)', 'hack')

) AS t(address, chain, entity, label, category)
