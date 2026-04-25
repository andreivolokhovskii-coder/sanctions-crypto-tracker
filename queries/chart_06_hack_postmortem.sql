-- Chart 06 | Bar Chart | hour / usdt_volume / cumulative_usdt
-- Proxy: all Tron USDT transfers >$100K during the Grinex hack window (Apr 15-17 2026)
-- For precise tracking add the 54 Grinex source wallets to query_7372298 (category='grinex')

WITH

hourly AS (
    SELECT
        DATE_TRUNC('hour', block_time)   AS hour,
        COUNT(DISTINCT to_hex("from"))   AS unique_senders,
        SUM(amount)                      AS usdt_volume,
        COUNT(*)                         AS tx_count
    FROM tokens_tron.transfers
    WHERE
        symbol = 'USDT'
        AND amount >= 100000
        AND block_time >= TIMESTAMP '2026-04-15'
        AND block_time <  TIMESTAMP '2026-04-18'
    GROUP BY 1
)

SELECT
    hour,
    unique_senders,
    usdt_volume,
    tx_count,
    SUM(usdt_volume) OVER (ORDER BY hour ROWS UNBOUNDED PRECEDING) AS cumulative_usdt
FROM hourly
ORDER BY hour
