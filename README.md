# Conversion Funnel Analysis (SQL)

Where do users drop off between landing on the site and paying? This is a funnel analysis for FormWise, a made-up
online legal-document subscription service. The data is simulated. generate_data.py builds a SQLite database
with 180,000 visitors and the events they triggered.

The metrics are written in SQL. The notebook runs the queries, adds a few stats tests, and makes the
charts.

## Queries
| File | What it does |
|---|---|
| `01_overall_funnel.sql` | Distinct visitors at each funnel step |
| `02_funnel_by_device.sql` | Step-by-step conversion by device (conditional aggregation) |
| `03_form_completion_by_doc_and_device.sql` | Form completion rate by document type and device |
| `04_time_to_complete.sql` | Minutes from starting a form to finishing it |
| `05_monthly_trend.sql` | Monthly conversion with month-over-month change and a 3-month rolling average (window functions) |
| `06_channel_performance.sql` | Conversion and revenue per visitor by acquisition channel |

Funnel steps count distinct visitors, and purchases come from the billing tables rather than the purchase event,
which has duplicates and some missing IDs.

## Findings
- Mobile users complete forms at **47%** vs **64%** on desktop. The gap is significant (chi-square, p < 0.001) for
  every document type.
- Mobile users who do finish take about as long as desktop users (~22 minutes), so the problem is people leaving
  the form, not filling it in slowly.
- The will template has the lowest completion on both devices.
- Closing half the mobile gap would mean about **18% more mobile purchases**.

![Form completion by document type] form_completion_by_doc.png

## Recommendations
1. Make the mobile form the top funnel priority.
2. Add field-level tracking (`form_field_error`, `form_abandon`) before redesigning, so the fix targets the right
   fields.
3. Test save-and-resume on mobile, starting with the will template.

## Run it
```
pip install -r requirements.txt
python data/generate_data.py
jupyter notebook analysis.ipynb
```

Tools: SQL (SQLite), Python, pandas, SciPy, Matplotlib
