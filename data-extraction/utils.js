const { readdirSync, readFileSync, writeFileSync, lstatSync } = require('fs');
const { join } = require('path');

const CODESET_DIR = join(__dirname, 'codesets');

const loadTemplate = () => readFileSync(join(__dirname, 'template.sql'), 'utf8');
const loadGroupTemplate = () => readFileSync(join(__dirname, 'template-group.sql'), 'utf8');
const loadGroupIncidenceTemplatePart = () => readFileSync(join(__dirname, 'template-group-incidence-part.sql'), 'utf8');
const loadGroupPrevalenceTemplatePart = () => readFileSync(join(__dirname, 'template-group-prevalence-part.sql'), 'utf8');

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

const createQueryFromFile = ({reportDateString, filename, directory = CODESET_DIR, group = ''}) => {
  const { codeString, nameDashed, nameCapitalCase, nameLowerSpaced } = getCodeStringAndNames(directory, filename);
  
  const template = loadTemplate();
  let query = template;  
  query = query.replace(/\{\{NAME_LOWER_SPACED\}\}/g, nameLowerSpaced);
  query = query.replace(/\{\{NAME_CAPITAL_NO_SPACE\}\}/g, nameCapitalCase);
  query = query.replace(/\{\{NAME_DASHED\}\}/g, nameDashed);
  query = query.replace(/\{\{CLINICAL_CODES\}\}/g, codeString);
  query = query.replace(/\{\{REPORT_DATE\}\}/g, reportDateString);

  writeFileSync(join(__dirname, 'sql-queries', `dx-${group}-${nameDashed}.sql`), query);
}

const getNonJSONInDir = (directory) => readdirSync(directory)
  .filter(x => {
    if(x.indexOf('.json') > -1) return false; // don't want the metadata
    return true;
  })

const createQueriesFromDirectory = ({reportDateString, dirname}) => {
  const subDirectory = join(CODESET_DIR, dirname);
  const { nameCapitalCase, nameDashed } = getNames(dirname);
  const files = getNonJSONInDir(join(CODESET_DIR, dirname));
  const codeFiles = files.map(filename => getCodeStringAndNames(subDirectory, filename));
  files.forEach(filename => createQueryFromFile({reportDateString, filename, directory: subDirectory, group: nameDashed }));
  const mainQuery = codeFiles
    .map(x => {
      let query = loadGroupIncidenceTemplatePart();
      query = query.replace(/\{\{CLINICAL_CODES\}\}/g, x.codeString);
      query = query.replace(/\{\{REPORT_DATE\}\}/g, reportDateString);
      query = query.replace(/\{\{NAME_LOWER_SPACED\}\}/g, x.nameLowerSpaced);
      return query;
    })
    .join('\n UNION ALL \n'); 
    // so that a person with condition 1 and condition 2 incident on same day counts as 2 towards total incidence 
    // - would only be 1 if we used simply "UNION" which would remove duplicates
  const prevalenceQuery = codeFiles
    .map(x => {
      let query = loadGroupPrevalenceTemplatePart();
      query = query.replace(/\{\{CLINICAL_CODES\}\}/g, x.codeString);
      query = query.replace(/\{\{REPORT_DATE\}\}/g, reportDateString);
      query = query.replace(/\{\{NAME_LOWER_SPACED\}\}/g, x.nameLowerSpaced);
      return query;
    })
    .join('\n UNION ALL \n'); 
  
  const allCodesCodeString = codeFiles.map(x => x.codeString).join("','")
    
  let groupQuery = loadGroupTemplate();
  groupQuery = groupQuery.replace(/\{\{INCIDENCE_TEMPLATE_PARTS\}\}/g, mainQuery);
  groupQuery = groupQuery.replace(/\{\{PREVALENCE_TEMPLATE_PARTS\}\}/g, prevalenceQuery);
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
