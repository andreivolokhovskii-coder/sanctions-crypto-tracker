# Sanctions Crypto Tracker: Garantex → Grinex → A7A5

**Open-source Dune Analytics dashboard tracking $110B+ in flows through Russia's sanctions evasion crypto network.**

> Chainalysis sells this analysis for $50k+/year. This is the open-source version.

[![Dune Dashboard](https://img.shields.io/badge/Dune-Live%20Dashboard-orange)](https://dune.com/desertear/sanctions-crypto-tracker)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## What This Tracks

Three interconnected entities that form Russia's shadow crypto economy:

| Entity | Status | Role |
|--------|--------|------|
| **Garantex** | Shut down March 2025 | Russia's largest crypto exchange. OFAC-sanctioned April 2022. ~$96B lifetime volume. |
| **Grinex** | Suspended April 2026 | Garantex successor — same team, same infrastructure, registered in Kyrgyzstan. OFAC-sanctioned August 2025. Collapsed after $13.7M hack. |
| **A7A5** | Active | Ruble-pegged stablecoin on Tron + Ethereum. Issued by Kyrgyz firm Old Vector. $93B+ in 2025 transactions. |

---

## Live Dashboard

**[dune.com/desertear/sanctions-crypto-tracker](https://dune.com/desertear/sanctions-crypto-tracker)**

### Charts

| # | Chart | Type | Description |
|---|-------|------|-------------|
| 01 | Total Volume | Counter | $110B+ cumulative USD flow since Jan 2022 |
| 02 | Daily Flow Timeline | Line | Daily USDT volume with enforcement event annotations |
| 03 | Fund Flow | Table | Sources → Cluster → Destinations (Tron USDT >$100K) |
| 04 | Top Counterparties | Bar | Exchanges and entities by volume |
| 05 | A7A5 Activity | Bar + Line | Monthly A7A5 ruble stablecoin volume |
| 06 | Grinex Hack | Bar | Hourly USDT drain, Apr 15–17 2026 |
| 07 | Top 50 Whales | Table | Highest-volume wallets through the cluster |
| 08 | Cluster Expansion | Bar + Line | New counterparty wallets added post-Garantex shutdown |

---

## Key Numbers (on-chain, as of April 2026)

| Metric | Value |
|--------|-------|
| **Total tracked volume** | **$110.7B** |
| Tron USDT through sanctioned cluster | $3.69B |
| A7A5 ruble stablecoin volume (2025–2026) | 9.73 trillion tokens (~$107B) |
| ETH stablecoin volume | $1.45M |
| Grinex hack (Apr 16, 2026) | $13.74M USDT → 45.9M TRX |
| Sanctioned addresses tracked | 50 (48 OFAC Tron + 2 ETH) |
| Counterparty volume through known exchanges | $0 — 100% P2P/OTC |

---

## Repository Structure

```
├── queries/
│   ├── _addresses_base.sql         # Base query (deploy to Dune first — query_id needed)
│   ├── chart_01_total_volume.sql
│   ├── chart_02_daily_timeline.sql
│   ├── chart_03_sankey_flows.sql
│   ├── chart_04_counterparty_exchanges.sql
│   ├── chart_05_a7a5_activity.sql
│   ├── chart_06_hack_postmortem.sql
│   ├── chart_07_top_whales.sql
│   └── chart_08_cluster_expansion.sql
├── data/
│   ├── addresses.csv               # Full address list with sources and dates
│   └── key_events.csv              # Timeline of enforcement events
└── methodology/
    └── methodology.md              # Address sourcing, limitations, conversion notes
```

---

## How to Reproduce

### Step 1 — Deploy the base address query

1. Go to [dune.com](https://dune.com), create a free account
2. **New Query** → paste contents of `queries/_addresses_base.sql`
3. Click **Save** (not just Run) — Dune assigns a query ID (e.g. `7372298`)
4. Note your query ID

### Step 2 — Update chart queries

In each `chart_*.sql` file, replace `query_7372298` with your own query ID:
```sql
-- Change this:
SELECT address FROM query_7372298 WHERE chain = 'tron'
-- To your ID:
SELECT address FROM query_YOUR_ID WHERE chain = 'tron'
```

### Step 3 — Run charts

For each `chart_*.sql`:
1. **New Query** → paste SQL → select **Medium engine** → **Run**
2. **Save** → **Add visualization** (see chart headers for recommended type)
3. Add to dashboard

> ⚠️ These queries scan 3+ years of Tron/Ethereum transfer data. The **Medium engine** is required (free tier times out at 2 minutes). Medium engine is available on Dune's free plan with limited runs per month.

---

## Address Methodology

All addresses sourced exclusively from public documents:

1. **OFAC SDN List** — [sanctionslist.ofac.treas.gov](https://sanctionslist.ofac.treas.gov)
2. **Chainalysis** published reports
3. **TRM Labs** published reports
4. **Elliptic** published reports
5. **On-chain verification** via Etherscan / TronScan

Addresses labeled "linked to" — not "owned by." Attribution is based on published source documents and may be incomplete.

Full address list with sources: [`data/addresses.csv`](data/addresses.csv)

**PRs with additional verified addresses (source citation required) are welcome.**

---

## Technical Notes

- All addresses stored as 40-char lowercase hex (no `0x` prefix)
- Tron Base58 addresses converted via Base58Check decode: strip version byte `0x41` + 4-byte checksum
- DuneSQL uses `varbinary` for address columns — use `from_hex(address)` for efficient comparison
- A7A5 price: 1 A7A5 ≈ 1 RUB ≈ $0.011 (mid-2025 rate)

---

## Disclaimer

This project analyzes publicly available blockchain data using publicly disclosed OFAC address lists. It is intended for research, journalism, and compliance education. The author has no affiliation with any sanctioned entities and does not provide financial or legal advice.

---

## Contributing

PRs welcome for:
- Additional verified addresses (source citation required)
- SQL optimizations
- Attribution corrections
- New chart ideas

## License

MIT — fork freely, citation appreciated.
