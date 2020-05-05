const { readdirSync, readFileSync, writeFileSync, createWriteStream } = require('fs');
const { join } = require('path');

const codesFromFile = (pathToFile) => readFileSync(pathToFile, 'utf8')
  .split('\n')
  .map(x => x.split('\t')[0]);

const codesWithoutTermCode = (codes) => {
  const codesWithoutTermExtension = codes
    .filter(x => x.length===7 && x[5] === '0' && x[6] === '0')
    .map(x => x.substr(0,5));
  return codes.concat(codesWithoutTermExtension);
}

const createQueryFromFile = ({ reportDateString }) => (filename) => {
  const template = readFileSync(join(__dirname, 'template.sql'), 'utf8');

  let query = template;

  const diagnosisDashed = filename.split('.')[0];
  const diagnosisCapitalCase = diagnosisDashed.split('-').map(x => x[0].toUpperCase() + x.slice(1)).join('');
  const diagnosisLowerSpaced = diagnosisDashed.split('-').map(x => x.toLowerCase()).join(' ');
  const codes = codesFromFile(join(__dirname, 'codesets', filename));
  const allCodes = codesWithoutTermCode(codes);
  const codeString = allCodes.join("','");
  query = query.replace(/\{\{DIAGNOSIS_LOWER_SPACED\}\}/g, diagnosisLowerSpaced);
  query = query.replace(/\{\{DIAGNOSIS_CAPITAL_NO_SPACE\}\}/g, diagnosisCapitalCase);
  query = query.replace(/\{\{DIAGNOSIS_DASHED\}\}/g, diagnosisDashed);
  query = query.replace(/\{\{CLINICAL_CODES\}\}/g, codeString);
  query = query.replace(/\{\{REPORT_DATE\}\}/g, reportDateString);
  writeFileSync(join(__dirname, 'sql-queries', `dx-${diagnosisDashed}.sql`), query);
}

exports.createSqlQueries = ({ reportDateString }) => { 
  readdirSync(join(__dirname, 'codesets'))
    .filter(x => {
      if(x.indexOf('.json') > -1) return false; // don't want the metadata
      return true;
    })
    .map(createQueryFromFile({ reportDateString }));
};

exports.sqlDateStringFromDate = (date = new Date()) => date.toISOString().substr(0,10);
