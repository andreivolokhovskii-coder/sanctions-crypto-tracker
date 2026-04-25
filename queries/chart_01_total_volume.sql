-- Chart 01 | Big Number | total_volume_usd_approx

WITH

eth_cluster AS (
    SELECT from_hex(address) AS address FROM query_7372298 WHERE chain = 'ethereum'
),

tron_cluster AS (
    SELECT from_hex(address) AS address FROM query_7372298 WHERE chain = 'tron' AND category = 'cluster'
),

eth_vol AS (
    SELECT COALESCE(SUM(t.amount), 0) AS vol
    FROM tokens_ethereum.transfers t
    WHERE
        (t."from" IN (SELECT address FROM eth_cluster)
         OR t."to"  IN (SELECT address FROM eth_cluster))
        AND t.symbol IN ('USDT', 'USDC', 'DAI', 'BUSD')
        AND t.block_time >= TIMESTAMP '2022-01-01'
),

tron_vol AS (
    SELECT COALESCE(SUM(t.amount), 0) AS vol
    FROM tokens_tron.transfers t
    WHERE
        (t."from" IN (SELECT address FROM tron_cluster)
         OR t."to"  IN (SELECT address FROM tron_cluster))
        AND t.symbol = 'USDT'
        AND t.block_time >= TIMESTAMP '2022-01-01'
),

-- 1 A7A5 ≈ 1 RUB ≈ $0.011
a7a5_vol AS (
    SELECT COALESCE(SUM(t.amount), 0) AS vol
    FROM tokens_tron.transfers t
    WHERE
        t.contract_address = from_hex('751f6515e355dc49474a8565a1234bf3424b9fe4')
        AND t.block_time >= TIMESTAMP '2025-01-01'
)

SELECT
    (SELECT vol FROM eth_vol)                             AS eth_usdt_usd,
    (SELECT vol FROM tron_vol)                            AS tron_usdt_usd,
    (SELECT vol FROM a7a5_vol)                            AS a7a5_tokens,
    (SELECT vol FROM eth_vol)
    + (SELECT vol FROM tron_vol)
    + (SELECT vol FROM a7a5_vol) * 0.011                 AS total_volume_usd_approx
