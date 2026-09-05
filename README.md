# olist-instalment-growth-analysis

SQL growth analysis of the Olist Brazilian e-commerce dataset. Tests whether instalment payments are a monetisation lever Olist is leaving on the table, using cohort retention, RFM segmentation, and a state-level income correlation. Decision memo included.

# Olist Instalment Growth Analysis

A growth analyst case study built on the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (~99,440 orders, Sept 2016 to Oct 2018). The core question: does Olist's data support treating instalment payments as a growth lever rather than a risk to be managed. The analysis is written up as a retrospective decision memo addressed to Olist leadership.

**[Read the decision memo](olist_DA_report.pdf)** · **[Interactive dashboard](olist_dashboard.html)**

## The finding in one sentence

Two thirds of Olist's revenue comes from customers paying in instalments, Olist earns nothing from the payment itself, and the cheapest way to test whether that is worth anything is to negotiate a better processing rate with the payment partners Olist already uses — before building anything.

## Summary

Instalment payments already carry the majority of Olist's revenue: 51.5% of orders, 63.5% of revenue, with no elevated cancellation risk and higher repeat rates than single-payment customers. Yet Olist's own description of its business names three pillars, and payments is not one of them. The memo argues the right first move is a low-cost negotiation play, not building a payment gateway.

## Key findings

| Finding | Result | What it means |
| --- | --- | --- |
| Instalment share of orders vs revenue | 51.5% of orders, 63.5% of revenue | Half the orders, two thirds of the money |
| Avg order value, instalment vs single payment | R$198.68 vs R$121.04 (+64.1%) | Instalment orders are substantially bigger |
| Median order value, instalment vs single payment | R$134.90 vs R$79.51 (+69.7%) | Not driven by a few outliers — the whole distribution sits higher |
| Cancellation rate, instalment orders vs baseline | 48.3% of cancellations vs 51.5% baseline (p = 0.12) | No elevated cancellation risk; the small gap is not statistically significant |
| Income vs cancellation correlation | r = 0.02 across 27 states | No relationship — poorer regions are not absorbing hidden risk |
| Repeat rate, instalment-majority vs single-payment-majority customers | 3.84% vs 2.34% | Instalment users come back more often |
| Instalment usage, repeat customers vs whole base | 63.6% vs 51.6% | The same relationship seen from the other direction |
| Revenue concentration | 96.9% of customers order once, generating 94.1% of revenue | Growth here is an acquisition story, not a retention story |
| Income vs instalment usage (state level) | r = −0.67 linear (R² = 0.45), r = −0.76 log-linear (R² = 0.57), n = 27 | Lower-income states use instalments more, but usage flattens rather than falling to zero |
| Inequality (Gini) vs instalment usage | r = 0.37 (p = 0.054) | Points the same way, but only borderline significant — a secondary signal |

Full detail, caveats, and what each finding does *not* establish are in the memo and in `FINDINGS_LOG.md`.

## Recommendation

Not that Olist should become a payment gateway; its position as a middle layer between sellers and third-party marketplaces makes that impractical near-term. Instead: use Olist's aggregated instalment volume to negotiate better processing rates with existing payment partners, and pass part of the saving back to sellers. A staged, low-cost test of whether the volume has negotiating leverage, before any bigger commitment.

## Methodology

- **Pipeline:** a numbered sequence of DuckDB SQL scripts (01 through 13), each producing a CSV consumed by the next stage or by the final report.
- **Four core deliverables:** cohort retention, funnel breakdown, RFM segmentation, and the decision memo.
- **State-level income correlation:** PIB per capita and Gini figures sourced from IBGE (SIDRA Tabelas 6784 and 7435, 2017-2018), joined against state-level instalment and cancellation rates. Run across all 27 states, with no minimum-volume exclusion.
- **Correlation and regression:** linear and log-linear Pearson correlations, R², slope and intercept computed natively in DuckDB using `CORR`/`REGR_SLOPE`/`REGR_INTERCEPT` on the raw and log-transformed income columns.
- **Robustness checks:** a log-linear vs linear model comparison, run to test whether the income relationship holds up to functional form, plus a Spearman rank correlation (ρ = −0.78) as an outlier check — not a native DuckDB computation, so treat it as a figure to re-verify. Excluding DF, the strongest-income state, strengthens rather than weakens the relationship.

## Stated limitations

- The income relationship is measured between states, not between individual customers. Olist's data has no individual income field, so this cannot be extended to customer-level claims without risking an ecological fallacy.
- Cancellation and instalment default are different things. The dataset only records the former; nothing here speaks to repayment or credit risk.
- The instalment-to-order-value association is real and consistent but not shown to be causal in either direction.
- The cost side of the recommendation is unmeasured. Processing fees by instalment count, settlement timing, and non-completion rates are not in this dataset and would need to be obtained before any commitment beyond negotiation.

## Repo structure

```
├── olist_DA_report.pdf        # Decision memo (final deliverable)
├── olist_dashboard.html       # Interactive companion to the memo
├── FINDINGS_LOG.md            # Working log of every question investigated, including ones not in the final memo
├── SQL/                       # Numbered DuckDB pipeline (01 to 13)
├── new_csv/                   # Output CSVs from each pipeline stage
├── Brazil income data/        # IBGE state income and Gini source data
└── Brazilian E-Commerce Public Dataset by Olist/   # Raw source dataset
```

## Tools

DuckDB (SQL), IBGE SIDRA (state income/Gini data).
