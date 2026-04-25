-- Chart 07 | Table | rank / wallet / chain / entity / vol_usd / total_txs / last_active

WITH

eth_cluster AS (
    SELECT from_hex(address) AS address FROM query_7372298 WHERE chain = 'ethereum'
),

tron_cluster AS (
    SELECT from_hex(address) AS address FROM query_7372298
    WHERE chain = 'tron' AND category = 'cluster'
),

tron_whales AS (
    SELECT
        CASE WHEN t."from" IN (SELECT address FROM tron_cluster)
             THEN to_hex(t."to")
             ELSE to_hex(t."from") END  AS wallet,
        SUM(t.amount)                   AS vol,
        COUNT(*)                        AS txs,
        MAX(t.block_time)               AS last_active,
        'tron'                          AS chain
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

eth_whales AS (
    SELECT
        CASE WHEN t."from" IN (SELECT address FROM eth_cluster)
             THEN to_hex(t."to")
             ELSE to_hex(t."from") END  AS wallet,
        SUM(t.amount)                   AS vol,
        COUNT(*)                        AS txs,
        MAX(t.block_time)               AS last_active,
        'ethereum'                      AS chain
    FROM tokens_ethereum.transfers t
    WHERE
        (t."from" IN (SELECT address FROM eth_cluster)
         OR t."to"  IN (SELECT address FROM eth_cluster))
        AND NOT (t."from" IN (SELECT address FROM eth_cluster)
             AND t."to"   IN (SELECT address FROM eth_cluster))
        AND t.symbol IN ('USDT', 'USDC', 'DAI')
        AND t.block_time >= TIMESTAMP '2022-01-01'
    GROUP BY 1
),

agg AS (
    SELECT wallet, chain, SUM(vol) AS total_vol, SUM(txs) AS total_txs, MAX(last_active) AS last_active
    FROM (SELECT * FROM tron_whales UNION ALL SELECT * FROM eth_whales)
    GROUP BY wallet, chain
)

SELECT
    ROW_NUMBER() OVER (ORDER BY a.total_vol DESC) AS rank,
    a.wallet,
    a.chain,
    COALESCE(l.name, 'Unknown')     AS entity,
    COALESCE(l.category, 'unknown') AS category,
    a.total_vol                     AS vol_usd,
    a.total_txs,
    a.last_active
FROM agg a
LEFT JOIN labels.addresses l
    ON a.wallet = to_hex(l.address)
    AND l.blockchain = a.chain
ORDER BY a.total_vol DESC
LIMIT 50
