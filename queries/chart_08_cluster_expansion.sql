-- Chart 08 | Bar (new_count) + Line (cumulative) | week
-- Narrative: network grew AFTER Garantex shutdown — enforcement alone doesn't stop it

WITH

tron_cluster AS (
    SELECT from_hex(address) AS address FROM query_7372298
    WHERE chain = 'tron' AND category = 'cluster'
),

pre AS (
    SELECT DISTINCT
        CASE WHEN t."from" IN (SELECT address FROM tron_cluster)
             THEN to_hex(t."to")
             ELSE to_hex(t."from") END AS addr
    FROM tokens_tron.transfers t
    WHERE
        t.symbol = 'USDT'
        AND t.block_time >= TIMESTAMP '2022-01-01'
        AND t.block_time <  TIMESTAMP '2025-03-06'
        AND (t."from" IN (SELECT address FROM tron_cluster)
          OR t."to"   IN (SELECT address FROM tron_cluster))
        AND NOT (t."from" IN (SELECT address FROM tron_cluster)
             AND t."to"   IN (SELECT address FROM tron_cluster))
),

post AS (
    SELECT
        CASE WHEN t."from" IN (SELECT address FROM tron_cluster)
             THEN to_hex(t."to")
             ELSE to_hex(t."from") END        AS addr,
        DATE_TRUNC('week', MIN(t.block_time)) AS first_week
    FROM tokens_tron.transfers t
    WHERE
        t.symbol = 'USDT'
        AND t.block_time >= TIMESTAMP '2025-03-06'
        AND (t."from" IN (SELECT address FROM tron_cluster)
          OR t."to"   IN (SELECT address FROM tron_cluster))
        AND NOT (t."from" IN (SELECT address FROM tron_cluster)
             AND t."to"   IN (SELECT address FROM tron_cluster))
    GROUP BY 1
),

weekly AS (
    SELECT first_week AS week, COUNT(*) AS new_count
    FROM post
    WHERE addr NOT IN (SELECT addr FROM pre)
    GROUP BY 1
)

SELECT
    week,
    new_count,
    SUM(new_count) OVER (ORDER BY week ROWS UNBOUNDED PRECEDING) AS cumulative
FROM weekly
ORDER BY week
