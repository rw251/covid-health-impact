# COVID-19 impact on mental and physical health

[![DOI](https://zenodo.org/badge/253420880.svg)](https://zenodo.org/badge/latestdoi/253420880)

Exploratory work to determine what (if any) effect the COVID-19 outbreak is having on the reporting, diagnosis and treatment of mental and physical health conditions.

## Instructions

1. Updated codesets are placed in `data-extraction/codesets`
2. Run `node main.js` to create the SQL queries necessary for data extraction
3. When on the server execute `data-extraction/RunToExtractData.bat` to extract the data
4. Data ends up in `data-extraction/data`

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

All outputs appear in the `./outputs` directory.

## Proposals

***This has been superseded - I think...***

1. Has there been any change in new diagnoses for these conditions of interest? Ideally, calculating incidence rates per month.
2. For those with existing mental illness disorders, is there any change in the frequency and type of consultation for those people? In other words, are they consulting less often under the current situation or are they just consulting differently (switch from face-to-face to video/telephone consultation, etc).
  - does this vary per condition
  - is it larger/smaller when compared with physical health conditions
  - need a shortlist of such physical health conditions - preferably those not related to mental health
3. We have a lot of speculative codes for these conditions - many of which relate to symptoms. Could we examine whether the current situation has exacerbated symptoms (or increased the frequency of episodes) among patients with prior diagnoses?