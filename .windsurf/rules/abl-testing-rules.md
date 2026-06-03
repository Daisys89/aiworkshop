---
trigger: always_on
---

# ABL Testing Guidelines

## Test Case Separation
Always separate **positive use cases** (expected success paths) from **negative use cases** (error/edge paths). Use clear comment blocks:

```abl
/* --- Positive use cases --- */
/* Positive 1: description of the expected success */

/* --- Negative use cases --- */
/* Negative 1: description of the expected edge case */
```

## Test Result Labeling
Prefix every test result message with `[+]` for positive or `[-]` for negative, and use `PASS` or `FAIL` consistently:

```abl
cReport = cReport + SUBSTITUTE("PASS [+]: Customer 1 returned &1 orderlines", iTotal) + CHR(10).
cReport = cReport + SUBSTITUTE("FAIL [-]: Customer 99999 expected 0 but got &1", iTotal) + CHR(10).
```

## Explicit Expectations
Do not use loose assertions like `>= 0` when the exact expected value is known. Verify exact values or ranges that prove correctness:

**Incorrect:**
```abl
IF iTotal >= 0 THEN
```

**Correct:**
```abl
IF iTotal = 12 THEN
```
(Use exact match when the test data is controlled and deterministic.)

## Structured Error Handling
Every test procedure must include `BLOCK-LEVEL ON ERROR UNDO, THROW.` at the top. Individual test blocks may use `DO ON ERROR UNDO, THROW:` with `CATCH` blocks:

```abl
BLOCK-LEVEL ON ERROR UNDO, THROW.

TestBlock:
DO ON ERROR UNDO, THROW:
    /* test logic */
    CATCH eError AS Progress.Lang.Error:
        iFailed += 1.
        cReport = cReport + SUBSTITUTE("FAIL [-]: error: &1", eError:GetMessage(1)) + CHR(10).
    END CATCH.
END.
```

## Test Summary
Always end the test suite with a summary message showing total passed vs failed:

```abl
cReport = cReport + CHR(10)
        + SUBSTITUTE("Tests passed: &1   Tests failed: &2", iPassed, iFailed).
MESSAGE cReport VIEW-AS ALERT-BOX.
```

## No Interactive Input in Automated Tests
Do not use `UPDATE`, `PROMPT-FOR`, or `WAIT-FOR` in automated test procedures. All test inputs should be hard-coded constants so tests can run unattended.
