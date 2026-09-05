# olist-instalment-growth-analysis
SQL and Python growth analysis of the Olist Brazilian e-commerce dataset. Tests whether instalment payments are a monetisation lever Olist is leaving on the table, using cohort retention, RFM segmentation, and a state-level income correlation. Decision memo included.

# Olist Instalment Growth Analysis

A growth analyst case study built on the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (~99,440 orders, Sept 2016 to Oct 2018). The core question: does Olist's data support treating instalment payments as a growth lever rather than a risk to be managed. The analysis is written up as a retrospective decision memo addressed to Olist leadership.

**[Read the decision memo](./olist_DA_report.pdf)** · **[Interactive dashboard](./olist_dashboard.html)**

## Summary

Instalment payments already carry the majority of Olist's revenue: 51.5% of orders, 63.5% of revenue, with no elevated cancellation risk and higher repeat rates than single-payment customers. Yet Olist's own description of its business names three pillars, and payments is not one of them. The memo argues the right first move is a low-cost negotiation play, not building a payment gateway.

## Key findings

| Finding | Result |
|---|---|
| Instalment share of orders vs revenue | 51.5% of orders, 63.5% of revenue |
| Avg order value, instalment vs single payment | R$198.68 vs R$121.04 (+64.1%) |
| Median order value, instalment vs single payment | R$134.90 vs R$79.51 (+69.7%) |
| Cancellation rate, instalment customers vs baseline | 52.16% vs 52.09% baseline (no elevated risk) |
| Income vs cancellation correlation | r = 0.04 across 24 states (no relationship) |
| Repeat rate, instalment-majority vs single-payment-majority customers | 3.84% vs 2.34% |
| Revenue concentration | 96.88% of customers order once, generate 94.1% of revenue |
| Income vs instalment usage (state level) | r = -0.73 linear (R² = 0.53), r = -0.81 log-linear (R² = 0.66) |
| Inequality (Gini) vs instalment usage | r = 0.56 |

Full detail, caveats, and what each finding does *not* establish are in the memo and in `FINDINGS_LOG.md`.

## Recommendation

Not that Olist should become a payment gateway; its position as a middle layer between sellers and third-party marketplaces makes that impractical near-term. Instead: use Olist's aggregated instalment volume to negotiate better processing rates with existing payment partners, and pass part of the saving back to sellers. A staged, low-cost test of whether the volume has negotiating leverage, before any bigger commitment.

## Methodology

- **Pipeline:** a numbered sequence of DuckDB SQL scripts (00 diagnostics through 12), each producing a CSV consumed by the next stage or by the final report.
- **Four core deliverables:** cohort retention, funnel breakdown, RFM segmentation, and the decision memo.
- **State-level income correlation:** PIB per capita and Gini figures sourced from IBGE (SIDRA Tabelas 6784 and 7435, 2017-2018), joined against state-level instalment and cancellation rates.
- **Cross-validation:** correlation and regression figures reproduced independently in both DuckDB (native `CORR`/`REGR_SLOPE`/`REGR_INTERCEPT`) and Python/scipy, matching to within float rounding.
- **Robustness checks:** Spearman's rank correlation and a log-linear vs linear model comparison, run to test whether the income relationship holds up to outliers and functional form.

## Stated limitations

- The income relationship is measured between states, not between individual customers. Olist's data has no individual income field, so this cannot be extended to customer-level claims without risking an ecological fallacy.
- Cancellation and instalment default are different things. The dataset only records the former; nothing here speaks to repayment or credit risk.
- The instalment-to-order-value association is real and consistent but not shown to be causal in either direction.

## Repo structure

```
├── olist_DA_report.pdf        # Decision memo (final deliverable)
├── olist_dashboard.html       # Interactive companion to the memo
├── FINDINGS_LOG.md            # Working log of every question investigated, including ones not in the final memo
├── sql/                       # Numbered DuckDB pipeline (00 to 12)
└── data/                      # Output CSVs from each pipeline stage
```

*(Update the tree above to match your actual folder layout when you push.)*

## Tools

DuckDB (SQL), Python (pandas, scipy for cross-validation), IBGE SIDRA (state income/Gini data).

---

This repo is being updated with newer data and additional pipeline stages; the memo and findings log above reflect the most recent completed analysis.
