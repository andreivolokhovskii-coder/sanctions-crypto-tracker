-- Chart 02 | Line Chart | day / eth_usdt / tron_usdt / a7a5_tokens / total_usd
-- Reference lines: 2022-04-05 | 2025-03-06 | 2025-08-14 | 2026-04-16

WITH

eth_cluster  AS (SELECT from_hex(address) AS address FROM query_7372298 WHERE chain = 'ethereum'),
tron_cluster AS (SELECT from_hex(address) AS address FROM query_7372298 WHERE chain = 'tron' AND category = 'cluster'),

eth_daily AS (
    SELECT DATE_TRUNC('day', t.block_time) AS day, SUM(t.amount) AS vol
    FROM tokens_ethereum.transfers t
    WHERE
        (t."from" IN (SELECT address FROM eth_cluster)
         OR t."to"  IN (SELECT address FROM eth_cluster))
        AND t.symbol IN ('USDT', 'USDC', 'DAI', 'BUSD')
        AND t.block_time >= TIMESTAMP '2022-01-01'
    GROUP BY 1
),

tron_daily AS (
    SELECT DATE_TRUNC('day', t.block_time) AS day, SUM(t.amount) AS vol
    FROM tokens_tron.transfers t
    WHERE
        (t."from" IN (SELECT address FROM tron_cluster)
         OR t."to"  IN (SELECT address FROM tron_cluster))
        AND t.symbol = 'USDT'
        AND t.block_time >= TIMESTAMP '2022-01-01'
    GROUP BY 1
),

a7a5_daily AS (
    SELECT DATE_TRUNC('day', t.block_time) AS day, SUM(t.amount) AS vol
    FROM tokens_tron.transfers t
    WHERE
        t.contract_address = from_hex('751f6515e355dc49474a8565a1234bf3424b9fe4')
        AND t.block_time >= TIMESTAMP '2025-01-01'
    GROUP BY 1
),

all_days AS (
    SELECT day FROM eth_daily UNION SELECT day FROM tron_daily UNION SELECT day FROM a7a5_daily
)

SELECT
    d.day,
    COALESCE(e.vol, 0)                           AS eth_usdt,
    COALESCE(tr.vol, 0)                          AS tron_usdt,
    COALESCE(a.vol, 0)                           AS a7a5_tokens,
    COALESCE(e.vol, 0) + COALESCE(tr.vol, 0)
    + COALESCE(a.vol, 0) * 0.011                AS total_usd
FROM all_days d
LEFT JOIN eth_daily  e  ON d.day = e.day
LEFT JOIN tron_daily tr ON d.day = tr.day
LEFT JOIN a7a5_daily a  ON d.day = a.day
ORDER BY d.day
