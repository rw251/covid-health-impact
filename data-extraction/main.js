const { 
  createSqlQueries,
  sqlDateStringFromDate,
} = require('./utils');

const reportDateString = process.argv[2] || sqlDateStringFromDate();

createSqlQueries({ reportDateString });


