-- Chart 03 | Table (Sankey on Pro) | source / target / value

WITH

tron_cluster AS (SELECT from_hex(address) AS address FROM query_7372298 WHERE chain = 'tron' AND category = 'cluster'),

raw AS (
    SELECT
        to_hex(t."from")                                 AS from_hex,
        to_hex(t."to")                                   AS to_hex,
        t.amount                                         AS vol,
        (t."from" IN (SELECT address FROM tron_cluster)) AS from_in,
        (t."to"   IN (SELECT address FROM tron_cluster)) AS to_in
    FROM tokens_tron.transfers t
    WHERE
        t.symbol = 'USDT'
        AND t.block_time >= TIMESTAMP '2022-01-01'
        AND (t."from" IN (SELECT address FROM tron_cluster)
          OR t."to"   IN (SELECT address FROM tron_cluster))
),

labeled AS (
    SELECT to_hex(address) AS address, COALESCE(name, 'Unknown / P2P / OTC') AS lbl
    FROM labels.addresses WHERE blockchain = 'tron'
),

inflows AS (
    SELECT
        COALESCE(l.lbl, 'Unknown / P2P / OTC') AS source,
        'Sanctioned Cluster'                    AS target,
        SUM(r.vol)                              AS value
    FROM raw r
    LEFT JOIN labeled l ON r.from_hex = l.address
    WHERE r.to_in AND NOT r.from_in
    GROUP BY 1, 2
),

outflows AS (
    SELECT
        'Sanctioned Cluster'                    AS source,
        COALESCE(l.lbl, 'Unknown / P2P / OTC') AS target,
        SUM(r.vol)                              AS value
    FROM raw r
    LEFT JOIN labeled l ON r.to_hex = l.address
    WHERE r.from_in AND NOT r.to_in
    GROUP BY 1, 2
)

SELECT source, target, value FROM inflows  WHERE value > 100000
UNION ALL
SELECT source, target, value FROM outflows WHERE value > 100000
ORDER BY value DESC
