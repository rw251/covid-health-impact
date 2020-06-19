# COVID-19 impact on mental and physical health

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3901288.svg)](https://doi.org/10.5281/zenodo.3901288)

Exploring the indirect effects the COVID-19 public health emergency on the reporting, diagnosis and treatment of mental and physical health conditions. There is particular focus on the potential missed diagnoses as a result of patient's avoiding healthcare settings and the widespread move to remote consultations.

## Instructions

1. Updated codesets are placed in `data-extraction/codesets`
2. Run `node main.js` to create the SQL queries necessary for data extraction
3. When on the server execute `data-extraction/RunToExtractData.bat` to extract the data
4. Data with daily counts ends up in a directory outside of this repo due to small numbers
5. Analysis instructions are below

## Analysis

### Pre-requisites

1. R installed and bin directory added to the PATH variable - e.g. so that `Rscript` entered at a command prompt actually does something
2. nodejs installed
3. In root of project execute `npm i` to install dependencies (none at present but you never know)

### Execution

Navigate to the root of the project and execute:

```
npm run analyse
```

All outputs appear in the `./outputs` directory. Redacted monthly data will be written to the `./data-extraction/data` directory. Any counts `<10` are replaced with `0`s.
