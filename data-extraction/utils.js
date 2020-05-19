const { readdirSync, readFileSync, writeFileSync, lstatSync } = require('fs');
const { join } = require('path');

const CODESET_DIR = join(__dirname, 'codesets');

const loadTemplate = () => readFileSync(join(__dirname, 'template.sql'), 'utf8');
const loadGroupTemplate = () => readFileSync(join(__dirname, 'template-group.sql'), 'utf8');
const loadGroupTemplatePart = () => readFileSync(join(__dirname, 'template-group-part.sql'), 'utf8');

const codesFromFile = (pathToFile) => readFileSync(pathToFile, 'utf8')
  .split('\n')
  .map(x => x.split('\t')[0]);

const codesWithoutTermCode = (codes) => {
  const codesWithoutTermExtension = codes
    .filter(x => x.length===7 && x[5] === '0' && x[6] === '0')
    .map(x => x.substr(0,5));
  return codes.concat(codesWithoutTermExtension);
}

const getNames = (filename) => {
  const nameDashed = filename.split('.')[0];
  const nameCapitalCase = nameDashed.split('-').map(x => x[0].toUpperCase() + x.slice(1)).join('');
  const nameLowerSpaced = nameDashed.split('-').map(x => x.toLowerCase()).join(' ');

  return { nameDashed, nameCapitalCase, nameLowerSpaced };
}

const getCodeStringAndNames = (directory, filename) => {
  const codes = codesFromFile(join(directory, filename));
  const allCodes = codesWithoutTermCode(codes);
  const codeString = allCodes.join("','");
  return {
    codeString,
    ...getNames(filename),
  }
}

const createQueryFromFile = ({reportDateString, filename}) => {
  const { codeString, nameDashed, nameCapitalCase, nameLowerSpaced } = getCodeStringAndNames(CODESET_DIR, filename);
  
  const template = loadTemplate();
  let query = template;  
  query = query.replace(/\{\{NAME_LOWER_SPACED\}\}/g, nameLowerSpaced);
  query = query.replace(/\{\{NAME_CAPITAL_NO_SPACE\}\}/g, nameCapitalCase);
  query = query.replace(/\{\{NAME_DASHED\}\}/g, nameDashed);
  query = query.replace(/\{\{CLINICAL_CODES\}\}/g, codeString);
  query = query.replace(/\{\{REPORT_DATE\}\}/g, reportDateString);

  writeFileSync(join(__dirname, 'sql-queries', `dx-${nameDashed}.sql`), query);
}

const getNonJSONInDir = (directory) => readdirSync(directory)
  .filter(x => {
    if(x.indexOf('.json') > -1) return false; // don't want the metadata
    return true;
  })

const createQueriesFromDirectory = ({reportDateString, dirname}) => {
  const subDirectory = join(CODESET_DIR, dirname);
  const { nameCapitalCase, nameDashed } = getNames(dirname);
  const codeFiles = getNonJSONInDir(join(CODESET_DIR, dirname))
    .map(filename => getCodeStringAndNames(subDirectory, filename));
  const mainQuery = codeFiles
    .map(x => {
      let query = loadGroupTemplatePart();
      query = query.replace(/\{\{CLINICAL_CODES\}\}/g, x.codeString);
      query = query.replace(/\{\{REPORT_DATE\}\}/g, reportDateString);
      query = query.replace(/\{\{NAME_LOWER_SPACED\}\}/g, x.nameLowerSpaced);
      return query;
    })
    .join('\n UNION \n');
  
  const allCodesCodeString = codeFiles.map(x => x.codeString).join("','")
    
  let groupQuery = loadGroupTemplate();
  groupQuery = groupQuery.replace(/\{\{TEMPLATE_PARTS\}\}/g, mainQuery);
  groupQuery = groupQuery.replace(/\{\{REPORT_DATE\}\}/g, reportDateString);
  groupQuery = groupQuery.replace(/\{\{ALL_CLINICAL_CODES\}\}/g, allCodesCodeString);
  groupQuery = groupQuery.replace(/\{\{NAME_CAPITAL_NO_SPACE\}\}/g, nameCapitalCase);
  
  writeFileSync(join(__dirname, 'sql-queries', `dx-GROUP-${nameDashed}.sql`), groupQuery);
};

const createQuery = ({reportDateString}) => (fileOrFolderName) => lstatSync(join(CODESET_DIR, fileOrFolderName)).isDirectory()
  ? createQueriesFromDirectory({reportDateString, dirname: fileOrFolderName})
  : createQueryFromFile({reportDateString, filename: fileOrFolderName});

exports.createSqlQueries = ({ reportDateString }) => getNonJSONInDir(CODESET_DIR).map(createQuery({ reportDateString }));

exports.sqlDateStringFromDate = (date = new Date()) => date.toISOString().substr(0,10);
