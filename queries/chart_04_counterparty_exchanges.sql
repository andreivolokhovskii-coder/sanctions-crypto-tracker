-- Chart 04 | Bar Chart (horizontal) | entity / total_vol_usd

WITH

eth_cluster AS (
    SELECT from_hex(address) AS address FROM query_7372298 WHERE chain = 'ethereum'
),

tron_cluster AS (
    SELECT from_hex(address) AS address FROM query_7372298
    WHERE chain = 'tron' AND category = 'cluster'
),

eth_cp AS (
    SELECT
        CASE WHEN t."from" IN (SELECT address FROM eth_cluster)
             THEN to_hex(t."to")
             ELSE to_hex(t."from") END   AS cp_addr,
        SUM(t.amount)                    AS vol,
        'ethereum'                       AS chain
    FROM tokens_ethereum.transfers t
    WHERE
        (t."from" IN (SELECT address FROM eth_cluster)
         OR t."to"  IN (SELECT address FROM eth_cluster))
        AND NOT (t."from" IN (SELECT address FROM eth_cluster)
             AND t."to"   IN (SELECT address FROM eth_cluster))
        AND t.symbol IN ('USDT', 'USDC', 'DAI', 'BUSD')
        AND t.block_time >= TIMESTAMP '2022-01-01'
    GROUP BY 1
),

tron_cp AS (
    SELECT
        CASE WHEN t."from" IN (SELECT address FROM tron_cluster)
             THEN to_hex(t."to")
             ELSE to_hex(t."from") END   AS cp_addr,
        SUM(t.amount)                    AS vol,
        'tron'                           AS chain
    FROM tokens_tron.transfers t
    WHERE
        (t."from" IN (SELECT address FROM tron_cluster)
         OR t."to"  IN (SELECT address FROM tron_cluster))
        AND NOT (t."from" IN (SELECT address FROM tron_cluster)
             AND t."to"   IN (SELECT address FROM tron_cluster))
        AND t.symbol = 'USDT'
        AND t.block_time >= TIMESTAMP '2022-01-01'
    GROUP BY 1
),

all_cp AS (
    SELECT cp_addr, vol, chain FROM eth_cp
    UNION ALL
    SELECT cp_addr, vol, chain FROM tron_cp
),

labeled AS (
    SELECT
        a.cp_addr, a.chain, a.vol,
        COALESCE(l.name, 'Unknown / OTC / P2P') AS entity,
        COALESCE(l.category, 'unknown')          AS category
    FROM all_cp a
    LEFT JOIN labels.addresses l
        ON a.cp_addr = to_hex(l.address)
        AND l.blockchain = a.chain
)

SELECT
    entity,
    category,
    SUM(vol) AS total_vol_usd
FROM labeled
GROUP BY entity, category
HAVING SUM(vol) > 1000000
ORDER BY total_vol_usd DESC
LIMIT 15
