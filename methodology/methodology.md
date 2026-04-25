# Methodology

## Overview

This dashboard tracks on-chain flows through three interconnected entities:
1. **Garantex** — Russian crypto exchange, OFAC-sanctioned April 2022, shut down March 2025
2. **Grinex** — Garantex's Kyrgyzstan-registered successor, OFAC-sanctioned August 2025
3. **A7A5** — Ruble-pegged stablecoin issued by Old Vector (Kyrgyzstan), OFAC-sanctioned August 2025

---

## Address Compilation

### Sources (in priority order)

| Source | Type | How to Access |
|--------|------|---------------|
| OFAC SDN List | Authoritative | [sanctionslist.ofac.treas.gov](https://sanctionslist.ofac.treas.gov) — download JSON, filter `digitalCurrencyAddresses` |
| Chainalysis Blog | Secondary | [chainalysis.com/blog](https://www.chainalysis.com/blog/) — search "Garantex", "Grinex", "A7A5" |
| TRM Labs Blog | Secondary | [trmlabs.com/resources/blog](https://www.trmlabs.com/resources/blog/) |
| Elliptic Blog | Secondary | [elliptic.co/blog](https://www.elliptic.co/blog/) |
| Grinex Public Statement | Primary (hack) | Grinex published source + destination addresses after April 2026 hack |
| TronScan / Etherscan | Verification | Verify contract addresses match symbol and deployer |

### How to Pull OFAC SDN Addresses

```bash
# Download OFAC SDN JSON
curl -o sdn.json https://sanctionslist.ofac.treas.gov/Home/SdnList

# Extract all digital currency addresses with Python
python3 -c "
import json
data = json.load(open('sdn.json'))
for entry in data.get('sdnList', {}).get('sdnEntry', []):
    name = entry.get('lastName', '') or entry.get('firstName', '')
    for addr in entry.get('idList', {}).get('id', []):
        if addr.get('idType', '') in ['Digital Currency Address - XBT', 
                                       'Digital Currency Address - ETH',
                                       'Digital Currency Address - USDT',
                                       'Digital Currency Address - XMR']:
            print(addr.get('idType'), addr.get('idNumber'), name)
" | grep -i -E 'garantex|grinex|old.vector|mendeleev|a7'
```

### Attribution Language

- Addresses are labeled **"linked to"** — not "owned by"
- Each address entry in `data/addresses.csv` includes a `source` field with the originating document
- Attributions may be incomplete; the cluster is likely larger than documented

---

## Volume Calculation

### USDT Flows (USD-denominated)
- USDT is pegged 1:1 to USD → raw token amount = USD value
- Sources: `tokens_tron.transfers` (Tron) + `tokens_ethereum.transfers` (Ethereum)
- Filter: `symbol = 'USDT'` on Tron; `symbol IN ('USDT','USDC','DAI')` on Ethereum

### A7A5 Flows
- A7A5 is pegged to 1 Russian Ruble (RUB)
- USD conversion: `amount_a7a5 × (1 / RUB_USD_rate)`
  - Mid-2025 rate: ~90 RUB/USD → 1 A7A5 ≈ $0.011
  - Rate fluctuates; cross-reference with a price feed for accuracy
- The $93B figure cited in reports likely uses this methodology

### Double-Counting Risk
- Garantex → A7A5 flows exist: customer funds moved to A7A5 after Garantex shutdown
- Do **not** naively add Garantex total + A7A5 total without de-duplicating cross-entity flows
- Dashboard computes each component separately; combined view is approximate

---

## On-Chain Data Source (Dune Analytics)

| Table | Chain | Content |
|-------|-------|---------|
| `tokens_tron.transfers` | Tron | TRC-20 token transfers (USDT, A7A5) |
| `tokens_ethereum.transfers` | Ethereum | ERC-20 token transfers (USDT, A7A5, wA7A5) |
| `tron.transfers` | Tron | Native TRX transfers (used for hack postmortem) |
| `labels.addresses` | Multi | Community labels mapping addresses to entity names |
| `prices.usd` | Multi | USD prices by contract address and minute |

All tables are publicly accessible on [Dune Analytics](https://dune.com) free tier.

---

## Limitations

1. **Incomplete address list** — The sanctioned cluster is larger than what OFAC has publicly listed. This dashboard is a floor, not a ceiling.

2. **Tron data coverage** — Dune's Tron data coverage may lag behind Ethereum. Verify row counts against TronScan for sanity checks.

3. **Labeling gaps** — `labels.addresses` community labels are incomplete. Many counterparty addresses will appear as "Unknown / P2P / OTC" even if they belong to identifiable entities.

4. **A7A5 price** — Using a fixed RUB/USD rate introduces error. For production use, join against a proper price feed or use CoinGecko's A7A5 price history.

5. **Grinex hack addresses** — Source wallet addresses and the consolidation address are included in Chart 06 as placeholders. Fill from Grinex's public statement or TRM Labs / Chainalysis reports.

6. **Hop depth** — Charts 03 and 08 use 1-hop from the seed cluster. The real network extends further; deeper hops require more computation and risk false positives.

---

## Key Verified Addresses

| Address | Chain | Entity | Source |
|---------|-------|--------|--------|
| `0x7FF9cFad3877F21d41Da833E2F775dB0569eE3D9` | Ethereum | Garantex Hot Wallet | OFAC SDN 2022-04-05 |
| `0x6fA0BE17e4beA2fCfA22ef89BF8ac9aab0AB0fc9` | Ethereum | A7A5 Token Contract | OFAC SDN 2025-08-14 + Etherscan |
| `0x0d57436f2d39c0664c6f0f2e349229483f87ea38` | Ethereum | wA7A5 Token Contract | Etherscan |
| `TLeVfrdym8RoJreJ23dAGyfJDygRtiWKBZ` | Tron | A7A5 TRC-20 Contract | TronScan |

For a full list with BTC addresses and additional ETH addresses, see `data/addresses.csv`.

---

## Disclaimer

This analysis uses publicly available blockchain data and publicly disclosed address lists from government and compliance firm publications. It is intended for research, journalism, and compliance education only. The author has no affiliation with any sanctioned entities and does not provide financial or legal advice.
