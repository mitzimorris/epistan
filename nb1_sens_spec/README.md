How can we account for the specificity and sensitivity of diagnostic tests when estimating disease prevalence in a population?

This notebook recreates Gelman and Carpenter 2020.

Assay:
immunoglobulin G (IgG) and immunoglobulin M (IgM) antibodies to SARS-CoV-2 

Assay calibration by manufacturer:
18 independent test-kit assessments: 14 for specificity and 4 for sensitivity.

Gelman and Carpenter 2020:

- Use a hierarchical model to capture the structure of the analysis -
there is an underlying test sensitivity and specificity which is used
as a prior on the individual assessments.


- Use the resulting estimates to inform the sensitivity and specificity
of a set of test results where the test processing facility is unknown
or hasn't performed its own test calibration.

- Requires a sensitivity analysis of the choice of hyperpriors for the
latent hierarchical parameters.


Context:  PCR tests for Covid-19 positivity became available in spring 2020.
In order to properly interpret the test results, we need to provide reasonable
estimates of test sensitivity and specificity.


(Lateral Flow Tests kits (rapid-result home test kits) became available the following winter.
Most public health service data is PCR test data.)



