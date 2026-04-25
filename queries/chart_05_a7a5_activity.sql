-- Chart 05 | Bar (total_vol) + Line (cumulative_vol) | month

WITH

a7a5_tron AS (
    SELECT
        DATE_TRUNC('month', block_time) AS month,
        COUNT(*)                        AS tx_count,
        SUM(amount)                     AS vol,
        COUNT(DISTINCT "from")          AS unique_senders,
        'tron'                          AS chain
    FROM tokens_tron.transfers
    WHERE
        contract_address = from_hex('751f6515e355dc49474a8565a1234bf3424b9fe4')
        AND block_time >= TIMESTAMP '2025-01-01'
    GROUP BY 1
),

a7a5_eth AS (
    SELECT
        DATE_TRUNC('month', block_time) AS month,
        COUNT(*)                        AS tx_count,
        SUM(amount)                     AS vol,
        COUNT(DISTINCT "from")          AS unique_senders,
        'ethereum'                      AS chain
    FROM tokens_ethereum.transfers
    WHERE
        contract_address = 0x6fA0BE17e4beA2fCfA22ef89BF8ac9aab0AB0fc9
        AND block_time >= TIMESTAMP '2025-01-01'
    GROUP BY 1
),

wa7a5_eth AS (
    SELECT
        DATE_TRUNC('month', block_time) AS month,
        COUNT(*)                        AS tx_count,
        SUM(amount)                     AS vol,
        COUNT(DISTINCT "from")          AS unique_senders,
        'ethereum_w'                    AS chain
    FROM tokens_ethereum.transfers
    WHERE
        contract_address = 0x0d57436f2d39c0664c6f0f2e349229483f87ea38
        AND block_time >= TIMESTAMP '2025-01-01'
    GROUP BY 1
),

agg AS (
    SELECT
        month,
        SUM(tx_count)       AS total_txs,
        SUM(vol)            AS total_vol,
        SUM(unique_senders) AS total_senders,
        SUM(CASE WHEN chain = 'tron'    THEN vol ELSE 0 END) AS tron_vol,
        SUM(CASE WHEN chain LIKE 'eth%' THEN vol ELSE 0 END) AS eth_vol
    FROM (
        SELECT * FROM a7a5_tron
        UNION ALL SELECT * FROM a7a5_eth
        UNION ALL SELECT * FROM wa7a5_eth
    )
    GROUP BY 1
)

SELECT
    month,
    total_txs,
    total_vol,
    total_senders,
    tron_vol,
    eth_vol,
    SUM(total_vol) OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS cumulative_vol
FROM agg
ORDER BY month
