# EndALS 2025 Evaluation
Validation and scoring scripts for the [EndALS 2025 Challenge](https://www.synapse.org/EndALS_2025).

Metrics returned and used for ranking are:

* ROC‑AUC
* secondary metric TBD

## Usage - Python

### Validate

```text
python validate.py \
  -p PATH/TO/PREDICTIONS_FILE.CSV \
  -g PATH/TO/GOLDSTANDARD_FILE.CSV [-o RESULTS_FILE]
```
If `-o/--output` is not provided, then results will print
to STDOUT, e.g.

```json
{"submission_status": "VALIDATED", "submission_errors": ""}
```

What it will check for:

- Two columns named `id`, `probability` (extraneous columns 
  will be ignored)
- `id` values are strings
- `probability` values are floats between 0.0 
  and 1.0, and cannot be null/None
- There is exactly one prediction per ID (so: no missing
  or duplicated `id`s)
- There are no extra predictions (so: no unknown `id`s)

### Score

```text
python score.py \
  -p PATH/TO/PREDICTIONS_FILE.CSV \
  -g PATH/TO/GOLDSTANDARD_FILE.CSV [-o RESULTS_FILE]
```

If `-o/--output` is not provided, then results will output
to `results.json`.
